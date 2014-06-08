//
//  SGViewController.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGViewController.h"
#import "SGMainPageBussiness.h"
#import "SGCablePageBussiness.h"
#import "SGFiberPageBussiness.h"

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForAllInnerRoom];
    [[SGCablePageBussiness sharedSGCablePageBussiness] queryCablelistWithCubicleId:22];
    [[SGFiberPageBussiness sharedSGFiberPageBussiness] queryFiberInfoWithCableId:4559];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
