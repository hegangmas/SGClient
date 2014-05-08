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
    
    NSLog(@"%@",[[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForRoomWithRoomId:1]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
