//
//  SGViewController.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGViewController.h"
#import "SGMainPageBussiness.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    NSLog(@"开始%@",[NSDate date]);
    NSLog(@"%@",[[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForOuterRoom]);
    NSLog(@"结束%@",[NSDate date]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
