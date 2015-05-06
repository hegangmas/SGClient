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

#define MainScreenWidth(o) ((UIInterfaceOrientationIsLandscape(o)?1024:768)) - DockWidth(o)

#define MainScreenHeight(o) ((UIInterfaceOrientationIsLandscape(o)?768:1024))

@interface SGBaseViewController : UIViewController

@end
