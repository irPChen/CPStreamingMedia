//
//  CPPushEngine.m
//  Record
//
//  Created by P.Chen on 16/9/28.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPPushEngine.h"
#import "rtmp.h"

static RTMP *_rtmp;

@interface CPPushEngine ()

@property (assign, nonatomic) float ts;
@property (assign, nonatomic) NSTimeInterval ft;

@end

@implementation CPPushEngine

- (instancetype)initWithURL:(NSString*)URL{
    
    self = [super init];
    
    if (self) {
        
        self.isFirstVideoPacket = YES;
        self.isFirstAudioPacket = YES;
        
        _rtmp = RTMP_Alloc();
        if (_rtmp == NULL) {
            NSLog(@"RTMP_Alloc=NULL");
            return NULL;
        }
        RTMP_Init(_rtmp);
        
        int ret = RTMP_SetupURL(_rtmp, "rtmp://10.57.9.88/live/gha8l7");//测试接口
        //int ret = RTMP_SetupURL(_rtmp, "rtmp://upload.rtmp.kukuplay.com/live/gha8l7");//线上上传接口
        NSLog(@"RTMP_SetupURL ret:%d",ret);
        
        if (!ret) {
            RTMP_Free(_rtmp);
            _rtmp = NULL;
            return NULL;
        }
        
        RTMP_EnableWrite(_rtmp);
        
        ret = RTMP_Connect(_rtmp, NULL);
        NSLog(@"RTMP_Connect ret:%d",ret);
        if (!ret) {
            RTMP_Free(_rtmp);
            _rtmp = NULL;
            return NULL;
        }
        
        ret = RTMP_ConnectStream(_rtmp, 0);
        NSLog(@"RTMP_ConnectStream ret:%d",ret);
        if (!ret) {
            ret = RTMP_ConnectStream(_rtmp, 0);
            RTMP_Close(_rtmp);
            RTMP_Free(_rtmp);
            _rtmp = NULL;
            return NULL;
        }
        
        [self pushMetaData];
    }
    
    return self;
}

//Send onMetaData
- (void)pushMetaData{
    
    NSLog(@"发送onMetaData");
    
    /*onMetadata
     02  00 0d  40 73 65 74 44 61 74 61 46 72 61 6d 65                            //setDataFrame
     02  00 0A  6F 6E 4D 65 74 61 44 61 74 61                                     //onMetaData
     08 00 00 04                                                                  //数据开始4个元素
     00 05 77 69 64 74 68                             00 40 94 00 00 00 00 00 00  //width
     00 06 68 65 69 67 68 74                          00 40 86 80 00 00 00 00 00  //height
     00 0c 76 69 64 65 6f 63 6f 64 65 63 69 64        00 40 1c 00 00 00 00 00 00  //videocodecid
     00 0e 76 69 64 65 6f 66 72 61 6d 65 72 61 74 65  00 40 3e 00 00 00 00 00 00  //videoframerate
     00 00 09                                                                     //数组结束符
     */
    
    uint32_t metaDataSize = 118;
    char metaData[] = {0x02, 0x00, 0x0d, 0x40, 0x73, 0x65, 0x74, 0x44, 0x61, 0x74, 0x61, 0x46, 0x72, 0x61, 0x6d, 0x65,
        
        0x02, 0x00, 0x0A, 0x6F, 0x6E, 0x4D, 0x65, 0x74, 0x61, 0x44, 0x61, 0x74, 0x61,
        
        0x08 ,0x00, 0x00, 0x00, 0x04,
        
        0x00, 0x05, 0x77, 0x69, 0x64, 0x74, 0x68, 0x00, 0x40, 0x94, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x06, 0x68, 0x65, 0x69, 0x67, 0x68, 0x74, 0x00, 0x40, 0x86, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
        
        0x00, 0x0c, 0x76, 0x69, 0x64, 0x65, 0x6f, 0x63, 0x6f, 0x64, 0x65, 0x63, 0x69, 0x64,  0x00, 0x40, 0x1c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        
        0x00, 0x0e, 0x76, 0x69, 0x64, 0x65, 0x6f, 0x66, 0x72, 0x61, 0x6d, 0x65, 0x72, 0x61, 0x74, 0x65, 0x00, 0x40, 0x3e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        
        0x00, 0x00, 0x09};
    
    RTMPPacket *packet = (RTMPPacket*)malloc(sizeof(RTMPPacket));
    RTMPPacket_Alloc(packet, metaDataSize);
    RTMPPacket_Reset(packet);
    packet->m_nChannel = 0x03;
    packet->m_nInfoField2 = _rtmp->m_stream_id;
    memcpy(packet->m_body,  metaData,  metaDataSize);
    packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
    packet->m_hasAbsTimestamp = FALSE;
    packet->m_nTimeStamp = 0;
    packet->m_packetType = RTMP_PACKET_TYPE_INFO;
    packet->m_nBodySize  = metaDataSize;
    RTMP_SendPacket(_rtmp, packet, 0);
    RTMPPacket_Free(packet);
}

//Send Audio Tag
- (void)pushAudioData:(NSData*)audioData sampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    /**
     * UB[4] 10 = AAC
     * UB[2] 3  = 44kHz
     * UB[1] 1  = 16-bit
     * UB[1] 0  = MonoSound
     */
    
    if (self.isFirstAudioPacket) {
        
        char *dst = malloc(4 * sizeof(char));
        dst[0] = 0xAE;
        dst[1] = 0x00;
        dst[2] = 0x12;
        dst[3] = 0x08;
        
        RTMPPacket *firstPacket = (RTMPPacket*)malloc(sizeof(RTMPPacket));
        int ret = RTMPPacket_Alloc(firstPacket, 4);
        RTMPPacket_Reset(firstPacket);
        firstPacket->m_nChannel = 0x05;
        firstPacket->m_nInfoField2 = _rtmp->m_stream_id;
        memcpy(firstPacket->m_body, dst, 4);
        firstPacket->m_headerType = RTMP_PACKET_SIZE_LARGE;
        firstPacket->m_hasAbsTimestamp = FALSE;
        firstPacket->m_nTimeStamp = 0;
        firstPacket->m_packetType = RTMP_PACKET_TYPE_AUDIO;
        firstPacket->m_nBodySize  = 4;
        RTMP_SendPacket(_rtmp, firstPacket, 0);
        RTMPPacket_Free(firstPacket);
        
        self.isFirstAudioPacket = NO;
    }
    
    char *dst = malloc(2 * sizeof(char));
    dst[0] = 0xAE;
    dst[1] = 0x01;
    
    NSMutableData *fullData = [NSMutableData dataWithData:[NSData dataWithBytes:dst length:2]];
    [fullData appendData:audioData];
    int fullDataLength = fullData.length;
    
    char *fullChar = malloc(fullData.length);
    [fullData getBytes:fullChar length:fullData.length];
    
    //PTS
    CMTime pts = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
    
    RTMPPacket *packet = (RTMPPacket*)malloc(sizeof(RTMPPacket));
    int ret = RTMPPacket_Alloc(packet, fullDataLength);
    RTMPPacket_Reset(packet);
    packet->m_nChannel = 0x05;
    packet->m_nInfoField2 = _rtmp->m_stream_id;
    memcpy(packet->m_body, fullChar, fullDataLength);
    packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
    packet->m_hasAbsTimestamp = FALSE;
    packet->m_nTimeStamp = (pts.value) / pts.timescale * 1000;
    packet->m_packetType = RTMP_PACKET_TYPE_AUDIO;
    packet->m_nBodySize  = fullDataLength;
    ret = RTMP_SendPacket(_rtmp, packet, 0);
    RTMPPacket_Free(packet);
    if (ret) {
        NSLog(@"音频数据发送成功！");
    }
}

//Send Video Tag
- (void)pushVideoData:(NSData*)rawVideoData Buffer:(CMSampleBufferRef)sampleBuffer isKeyFrame:(BOOL)isKeyFrame{
    
    if (self.isFirstVideoPacket) {//第一个视频数据包
        
        //第一个视频包头
        uint32_t firstVideoPacketHeader = 5;
        char firstVideoPacketHeaderChar [] = {0x17, 0x00, 0x00, 0x00, 0x00};
        NSData *firstVideoPacketHeaderData = [NSData dataWithBytes:firstVideoPacketHeaderChar length:firstVideoPacketHeader];
        
        //获取avcC数据 = SPS + PPS
        CMFormatDescriptionRef fmtDesc = CMSampleBufferGetFormatDescription(sampleBuffer);
        NSDictionary *formerFormatDescExtensions = (__bridge NSDictionary *)CMFormatDescriptionGetExtensions(fmtDesc);
        NSDictionary *extensionAtoms = formerFormatDescExtensions[@"SampleDescriptionExtensionAtoms"];
        NSData *avcCData = [extensionAtoms valueForKey:@"avcC"];
        
        //计算第一个视频包长度
        int firstVideoPacketSize = firstVideoPacketHeader + avcCData.length;
        
        //拼接第一个视频包数据
        NSMutableData *firstVideoPacketData = [NSMutableData dataWithData:firstVideoPacketHeaderData];
        [firstVideoPacketData appendData:avcCData];
        char *firstVideoPacketChar = malloc(firstVideoPacketSize * sizeof(char));
        [firstVideoPacketData getBytes:firstVideoPacketChar length:firstVideoPacketSize];
        
        NSLog(@"firstVideoPacketData:%@",firstVideoPacketData);
        
        //初始化RTMPPacket
        RTMPPacket *packet = (RTMPPacket*)malloc(sizeof(RTMPPacket));
        int ret = RTMPPacket_Alloc(packet, firstVideoPacketSize);
        RTMPPacket_Reset(packet);
        packet->m_nChannel = 0x04;
        packet->m_nInfoField2 = _rtmp->m_stream_id;
        memcpy(packet->m_body,  firstVideoPacketChar,  firstVideoPacketSize);
        packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
        packet->m_hasAbsTimestamp = FALSE;
        packet->m_nTimeStamp = 0;
        packet->m_packetType = RTMP_PACKET_TYPE_VIDEO;
        packet->m_nBodySize  = firstVideoPacketSize;
        RTMP_SendPacket(_rtmp, packet, 0);
        RTMPPacket_Free(packet);
        
        NSLog(@"发送SPS、PPS");
        
        self.isFirstVideoPacket = NO;
    }
    
    //计算当前视频包时间戳
    CMBlockBufferRef block = CMSampleBufferGetDataBuffer(sampleBuffer);
    CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, false);
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    CMTime dts = CMSampleBufferGetDecodeTimeStamp(sampleBuffer);
    CMTime tt = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
    UInt32 timeStamp = (tt.value) / tt.timescale *1000;
    
    //视频包header长度
    uint32_t videoPacketHeaderSize = 9;
    char videoPacketHeaderChar[9];
    
    if (isKeyFrame) {
        videoPacketHeaderChar[0] = 0x17;
        videoPacketHeaderChar[1] = 0x01;
        videoPacketHeaderChar[2] = 0x00;
        videoPacketHeaderChar[3] = 0x00;
        videoPacketHeaderChar[4] = 0x00;
    }else{
        videoPacketHeaderChar[0] = 0x27;
        videoPacketHeaderChar[1] = 0x01;
        videoPacketHeaderChar[2] = 0x00;
        videoPacketHeaderChar[3] = 0x00;
        videoPacketHeaderChar[4] = 0x00;
    }
    
    size_t rawVideoDataSize = rawVideoData.length;
    videoPacketHeaderChar[5] = ((rawVideoDataSize >> 24) & 0xFF);
    videoPacketHeaderChar[6] = ((rawVideoDataSize >> 16) & 0xFF);
    videoPacketHeaderChar[7] = ((rawVideoDataSize >> 8) & 0xFF);
    videoPacketHeaderChar[8] = ((rawVideoDataSize) & 0xFF);
    
    //拼接完整视频包
    int videoPacketSize = videoPacketHeaderSize + rawVideoDataSize;
    NSData *videoPacketHeaderData = [NSData dataWithBytes:videoPacketHeaderChar length:videoPacketHeaderSize];
    NSMutableData *videoPacketData = [NSMutableData dataWithData:videoPacketHeaderData];
    [videoPacketData appendData:rawVideoData];
    char *videoPacketChar = malloc(videoPacketSize * sizeof(char));
    [videoPacketData getBytes:videoPacketChar length:videoPacketSize];
    
    RTMPPacket *packet = (RTMPPacket*)malloc(sizeof(RTMPPacket));
    int ret = RTMPPacket_Alloc(packet, videoPacketSize);
    RTMPPacket_Reset(packet);
    packet->m_nChannel = 0x04;
    packet->m_nInfoField2 = _rtmp->m_stream_id;
    memcpy(packet->m_body,  videoPacketChar,  videoPacketSize);
    packet->m_headerType = RTMP_PACKET_SIZE_LARGE;
    packet->m_hasAbsTimestamp = FALSE;
    packet->m_nTimeStamp = 0;
    packet->m_packetType = RTMP_PACKET_TYPE_VIDEO;
    packet->m_nBodySize  = videoPacketSize;
    RTMP_SendPacket(_rtmp, packet, 0);
    RTMPPacket_Free(packet);
}


@end
