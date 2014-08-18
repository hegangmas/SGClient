//
//  SGSelectViewController.h
//  SGClient
//
//  Created by yangboshan on 14-8-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGPortPageBussinessDelegate <NSObject>
-(void)userDidSelectItem:(NSInteger)index;
@end

@interface SGSelectViewController : UIViewController

@property (nonatomic,strong) NSArray* dataSource;
@property (nonatomic,weak) id<SGPortPageBussinessDelegate> delegate;
@end
