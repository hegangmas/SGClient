//
//  SGBaseBussiness.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGBaseBussiness.h"
#import "SGAPPConfig.h"

@implementation SGBaseBussiness

#pragma mark - init
-(id)init{
    if (self = [super init]) {
    }
    return self;
}

-(FMDatabase*)dataBase{
    
//    if (!_dataBase || [SGUtility getDBChangeFlag]) {
//        
//        _dataBase = [[SGDataBase sharedSGDataBase] dataBase];
//        [SGUtility restoreDBChangeFlag];
//    }
    return [[SGDataBase sharedSGDataBase] dataBase];
}
#pragma mark -
@end
