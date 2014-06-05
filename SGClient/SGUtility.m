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

@end
