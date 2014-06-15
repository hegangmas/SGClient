//
//  SGLeftDockItem.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGLeftDockItem : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *bgImage;
@property (nonatomic,strong) NSString *controller;
@property (nonatomic,assign) BOOL isModalShow;

+(SGLeftDockItem*)initWithTitle:(NSString*)title withBgImage:(NSString*)bgImage withController:(NSString*)controller withModalShow:(BOOL)isModalShow;
@end
