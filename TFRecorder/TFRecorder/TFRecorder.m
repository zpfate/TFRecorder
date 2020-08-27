//
//  TFRecorder.m
//  TFRecorder
//
//  Created by Twisted Fate on 2020/8/7.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import "TFRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface TFRecorder ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation TFRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

/// 请求权限
+ (BOOL)checkRecordPermission {
    
    __block BOOL authorized = NO;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusAuthorized) {
        
        authorized = YES;
    } else if (status == AVAuthorizationStatusDenied) {
        // 拒绝
        authorized = NO;
    } else if (status == AVAuthorizationStatusRestricted) {
        
        authorized = NO;
    } else if (status == AVAuthorizationStatusNotDetermined) {
        /// 第一次申请录音权限
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session requestRecordPermission:^(BOOL granted) {
            authorized = granted;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    return authorized;
}

/// 开始录制
- (void)startRecording {
    
    NSURL *fileUrl = [NSURL fileURLWithPath:[self recordFilePath]];
    NSError *err;
    NSDictionary *settings = [self recordSettings];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:settings error:&err];
    /// 开启表盘绘制分贝数
    self.recorder.meteringEnabled = YES;
    /// 设置音频录制的长度
    [_recorder recordForDuration:0];
    /// 准备录制,把录音文件加载缓冲区
    [self.recorder prepareToRecord];
    /// 开始录制或者继续录制
    [self.recorder record];
}

- (void)pauseRecording {
    [self.recorder pause];
}

- (void)stopRecording {
    [self.recorder stop];
}

/// 录音设置
- (NSDictionary *)recordSettings {
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    /// 录音格式
    [settings setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    /// 采样率,影响音频的质量
    [settings setObject:@(8000.f) forKey:AVSampleRateKey];
    /// 录音通道1或2, 需要转换成mp3格式则必须要设置双通道
    [settings setObject:@(2) forKey:AVNumberOfChannelsKey];
    /// 录音质量
    [settings setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    /// 线性采样位数  8、16、24、32
    [settings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    return settings;
}

/// 会话设置
- (void)setupSession {
    
    /// 用来管理APP对音频硬件(扬声器 麦克风)的使用
    /// 获取会话单例
    AVAudioSession *session = [AVAudioSession sharedInstance];
    /// 设置Category
    NSError *sessionErr;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionErr];
    NSAssert(sessionErr, sessionErr.description);
    NSError *activeErr;
    /// 激活
    [session setActive:YES error:&activeErr];
    NSAssert(activeErr, activeErr.description);
}

/// 默认存储地址
- (NSString *)recordFilePath {
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dir = [cachePath stringByAppendingPathComponent:@"soundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *err;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
    }
    NSString *fileName = [NSString stringWithFormat:@"record-%.2f", [[NSDate date] timeIntervalSince1970]];
    NSString *path = [dir stringByAppendingPathComponent:fileName];
    return path;
}

@end
