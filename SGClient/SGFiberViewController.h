//
//  SGFiberViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDrawViewController.h"

@interface SGFiberViewController : SGDrawViewController

@property(nonatomic,strong) NSString *cableId;
@property(nonatomic,strong) NSArray  *connection;
@property(nonatomic,assign) BOOL isTX;

@end
