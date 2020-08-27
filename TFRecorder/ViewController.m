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
    
    
}

@end
