//
//  SGBaseViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLReader.h"
#import "NUApp-Macro.h"


#define DockWidth(v) (UIInterfaceOrientationIsLandscape(v)?kDockComposeItemWidthL: kDockComposeItemWidthP)

#define MainScreenWidth(o) ((UIInterfaceOrientationIsLandscape(o)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)) - DockWidth(o)

#define MainScreenHeight(o) ((UIInterfaceOrientationIsLandscape(o)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height))

@interface SGBaseViewController : UIViewController

@end
