//
//  SGUtility.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGUtility.h"

@implementation SGUtility

+ (NSURL *)applicationDocumentsDirectory
{
    
    NSURL *url=[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                       inDomains:NSUserDomainMask]
                lastObject];
    
    return url;
}

+ (NSString *)dataBasePath{
    
    NSString* dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                        objectAtIndex:0];
    
    dbPath = [dbPath stringByAppendingPathComponent:NSLocalizedString(@"DB_NAME", nil)];
    
    return dbPath;
}

@end
