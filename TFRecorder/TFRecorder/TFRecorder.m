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

/// 监测录音权限
- (BOOL)checkRecordPermission {
    
    __block BOOL canRecord = YES;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session requestRecordPermission:^(BOOL granted) {
            canRecord = granted;
        }];
    } else if (status == AVAuthorizationStatusDenied || AVAuthorizationStatusRestricted) {
        canRecord = NO;
    } else {
        canRecord = YES;
    }
    return YES;
}

- (void)sessionSettings {
    
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

- (void)soundFilPath

@end
