//
//  CPH264Encoder.m
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPH264Encoder.h"
#import "rtmp.h"

static CPPushEngine *_output;

#pragma mark -- 编码回调

static void compressionOutputCallback(void * CM_NULLABLE outputCallbackRefCon,
                                      void * CM_NULLABLE sourceFrameRefCon,
                                      OSStatus status,
                                      VTEncodeInfoFlags infoFlags,
                                      CM_NULLABLE CMSampleBufferRef sampleBuffer ) {
    if (status != noErr) {
        NSLog(@"%s with status(%d)", __FUNCTION__, status);
        return;
    }
    if (infoFlags == kVTEncodeInfo_FrameDropped) {
        NSLog(@"%s with frame dropped.", __FUNCTION__);
        return;
    }

    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4;
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            
            // Read the NAL unit length
            uint32_t NALUnitLength = 0;
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            NSLog(@"Befor NALUnitLength:%d",NALUnitLength);
            
            // Convert the length value from Big-endian to Little-endian
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            NSLog(@"After NALUnitLength:%d",NALUnitLength);

            
            NSData* data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUnitLength];
            
            BOOL keyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);

            
            if (data.length==31) {
                //关键帧前有31个字节数据，不发送给服务端
            }else{
                [_output pushVideoData:data Buffer:sampleBuffer isKeyFrame:keyframe];
            }
            
            // Move to the next NAL unit in the block buffer
            bufferOffset += AVCCHeaderLength + NALUnitLength;
        }
    }
}

@interface CPH264Encoder () {
    VTCompressionSessionRef _compressionSession;
}

@end

@implementation CPH264Encoder

@synthesize outputPiple = _outputPiple;

- (void)setOutputPiple:(CPPushEngine*)outputPiple{
    if (_outputPiple != outputPiple) {
        _outputPiple = outputPiple;
    }
    _output = outputPiple;
}

- (void)encodeVideoBuffer:(CMSampleBufferRef)sampleBuffer{
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    if (!_compressionSession) {
        OSStatus createStatus =  VTCompressionSessionCreate(NULL,
                                                            width, height,
                                                            kCMVideoCodecType_H264,
                                                            NULL,
                                                            NULL,
                                                            NULL, &compressionOutputCallback, NULL, &_compressionSession);
        
        //设置实时编码输出（避免延迟）
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        //设置H264
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Main_AutoLevel);
        //设置关键帧（GOPsize)间隔
        int frameInterval = 10;
        CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        //设置期望帧率
        int fps = 30;
        CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
        //设置码率，上限，单位是bps
        int bitRate = 10000 * 1024;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        //设置码率，均值，单位是byte
        int bitRateLimit = width * height * 3 * 4;
        CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
        //编码器熵编码开启，H264_Main以上支持，H264_Base只支持kVTH264EntropyMode_CAVLC
        VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_H264EntropyMode, kVTH264EntropyMode_CABAC);
        
        OSStatus prepareStatus = VTCompressionSessionPrepareToEncodeFrames(_compressionSession);
        if (prepareStatus != noErr) {
            // FAILED.
        }
    }
    
    if(CVPixelBufferLockBaseAddress(pixelBuffer, 0) != kCVReturnSuccess) {
        // FAILED.
    }
    
    CMTime presentationTimeStamp = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
    CMTime duration = CMSampleBufferGetOutputDuration(sampleBuffer);
    
    OSStatus encodeStatus = VTCompressionSessionEncodeFrame(_compressionSession, pixelBuffer, presentationTimeStamp, duration, NULL, pixelBuffer, NULL);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

@end
