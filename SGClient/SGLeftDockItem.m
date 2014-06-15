//
//  SGLeftDockItem.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGLeftDockItem.h"



@implementation SGLeftDockItem

+(SGLeftDockItem*)initWithTitle:(NSString*)title withBgImage:(NSString*)bgImage withController:(NSString*)controller withModalShow:(BOOL)isModalShow{
    
    SGLeftDockItem *leftDockItem = [SGLeftDockItem new];
    leftDockItem.title = title;
    leftDockItem.bgImage = bgImage;
    leftDockItem.controller = controller;
    leftDockItem.isModalShow = isModalShow;
    
    return leftDockItem;
}
@end
