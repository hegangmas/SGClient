//
//  SGLeftDock.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGLeftDockItem;

@interface SGLeftDock : UIView

@property (nonatomic,copy) void (^dockItemClickBlock)(SGLeftDockItem *item);
//@property (nonatomic,strong) SGLeftDockItem* fisrtDockItem;

- (void)rotate:(UIInterfaceOrientation)orientation;
- (void)setDefaultSelected;
@end
