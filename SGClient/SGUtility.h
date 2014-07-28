//
//  SGUtility.h
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "FMDatabase.h"

@interface SGUtility : NSObject

+ (NSURL *)applicationDocumentsDirectory;
+ (NSString *)dataBasePath;

+ (NSArray*)getResultlistForFMSet:(FMResultSet*)fmResultSet
                       withEntity:(NSString*)entity;

+(NSString*)getCurrentDB;
+(void)setCurrentDB:(NSString*)db;

+(BOOL)getDBChangeFlag;
+(void)restoreDBChangeFlag;
@end
