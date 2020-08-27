//
//  TFRecorder.h
//  TFRecorder
//
//  Created by Twisted Fate on 2020/8/7.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFRecorder : NSObject

/// 检测录音权限
+ (BOOL)checkRecordPermission;
/// 开始录制
- (void)startRecording;
/// 暂停录制
- (void)pauseRecording;
/// 停止录制
- (void)stopRecording;
/// 录音文件保存地址
- (NSString *)recordFilePath;

@end

NS_ASSUME_NONNULL_END
