                                                                                                                                                                                        //
//  SGUtility.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGUtility.h"
#import "SGAPPConfig.h"


@implementation SGUtility

static NSString *DB_NAME = @"DB_NAME";
static NSString *DB_CHANGE_FLAG =@"DB_CHANGE_FLAG";

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
    
    dbPath = [dbPath stringByAppendingPathComponent:[self getCurrentDB]];
    
    return dbPath;
}

/*－－－－－－－－－－－－－－－－－
 根据DB结果集和实体名称返回列表
 －－－－－－－－－－－－－－－－－*/
+(NSArray*)getResultlistForFMSet:(FMResultSet*)fmResultSet withEntity:(NSString*)entity{
    
    NSMutableArray* resultList = [NSMutableArray array];
    while ([fmResultSet next]) {
        Class _class = NSClassFromString(entity);
        id _entity = [[_class alloc] init];
        for(int i = 0; i < [fmResultSet columnCount];i++){
            [_entity setValue:[fmResultSet stringForColumn:[fmResultSet columnNameForIndex:i]]
                       forKey:[fmResultSet columnNameForIndex:i]];
        }
        [resultList addObject:_entity];}
    return resultList;
}

+(BOOL)getDBChangeFlag{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:DB_CHANGE_FLAG];
}
+(void)restoreDBChangeFlag{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DB_CHANGE_FLAG];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getCurrentDB{
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:DB_NAME];
}

+(void)setCurrentDB:(NSString *)db{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DB_CHANGE_FLAG];
    [[NSUserDefaults standardUserDefaults] setObject:db forKey:DB_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
