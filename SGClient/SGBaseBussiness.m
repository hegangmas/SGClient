//
//  SGBaseBussiness.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGBaseBussiness.h"

@implementation SGBaseBussiness

#pragma mark - init
-(id)init{
    if (self = [super init]) {
        _dataBase = [[SGDataBase sharedSGDataBase] dataBase];
    }
    return self;
}
#pragma mark -
@end
