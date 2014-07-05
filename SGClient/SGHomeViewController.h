//
//  SGHomeViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGLeftDockItem.h"
#import "SGLeftDock.h"

@interface SGHomeViewController : UIViewController
@property (nonatomic,strong) SGLeftDock* leftDock;
@property (nonatomic,strong) UINavigationController *currentChild;

@end
