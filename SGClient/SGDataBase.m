//
//  SGDataBase.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGDataBase.h"

@implementation SGDataBase

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGDataBase)

static FMDatabase *db = nil;

#pragma mark - init dataBase

-(FMDatabase*)dataBase
{
    if (db) {
        return db;
    }
    db = [FMDatabase databaseWithPath:[SGUtility dataBasePath]];
    
    if (![db open]) {
        NSLog(@"failed open db!");
        
        return nil;
    }
    return db;
}
@end
