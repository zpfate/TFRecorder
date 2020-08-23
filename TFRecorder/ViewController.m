//
//  ViewController.m
//  TFRecorder
//
//  Created by Twisted Fate on 2020/7/24.
//  Copyright © 2020 Twisted Fate. All rights reserved.
//

#import "ViewController.h"
#import "TFRecorder.h"
@interface ViewController ()

@property (nonatomic, strong) TFRecorder *record;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL result = [TFRecorder checkRecordPermission];
    NSLog(@"result ==== %d", result);
}

- (IBAction)testAction:(id)sender {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_queue_create("queue", 0), ^{
        sleep(3);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

@end
