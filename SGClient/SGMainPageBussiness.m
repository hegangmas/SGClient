//
//  SGDbBussiness.m
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGMainPageBussiness.h"
#import "SGDataBase.h"
#import "FMDatabase.h"


@implementation SGDataBaseRowItem

@end


@implementation SGMainPageBussiness

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGMainPageBussiness)

/*－－－－－－－－－－－－－－－－－
 SQL 获得指定ROOM ID 的DEVICE列表
 INPUT: ROOM_ID (INT)
 －－－－－－－－－－－－－－－－－*/
#define MP_GetDevicelistForRoom  "select room.room_id as roomid,room.name as roomname,cubicle.cubicle_id as cubicleid,cubicle.name as cubiclename,device.device_id as deviceid,device.description as devicename from device,cubicle,room where room.room_id = cubicle.room_id and device.cubicle_id = cubicle.cubicle_id and cubicle.room_id = ?  and device.device_id !=2 order by room.room_id, cubicle.cubicle_id, device.cubicle_pos"


/*－－－－－－－－－－－－－－－－－
 SQL 获得ROOM ID ＝ 0 设备列表
 INPUT: NULL
 －－－－－－－－－－－－－－－－－*/
#define MP_GetDevicelistForOuterRoom  "select cubicle.cubicle_id as cubicleid,cubicle.name as cubiclename,device.device_id as deviceid,device.description as devicename from device,cubicle where device.cubicle_id = cubicle.cubicle_id and cubicle.room_id = 0  and device.device_id !=2 order by  cubicle.cubicle_id, device.cubicle_pos"

#pragma mark - Query
/*－－－－－－－－－－－－－－－－－
 获得指定ROOM ID 的DEVICE列表
 
 INPUT: ROOM_ID (INT)
－－－－－－－－－－－－－－－－－*/
-(NSString*)queryDevicelistForRoomWithRoomId:(NSInteger)roomId{

    FMResultSet * fmResultSet = [self.dataBase executeQuery:@MP_GetDevicelistForRoom,
                                 [NSNumber numberWithInteger:roomId]];

    return [self buildXMLForResultSet:fmResultSet];
}

/*－－－－－－－－－－－－－－－－－
 获得ROOM ID ＝ 0 DEVICE列表
 
 INPUT: NULL
 －－－－－－－－－－－－－－－－－*/
-(NSString*)queryDevicelistForOuterRoom{
    
    FMResultSet * fmResultSet = [self.dataBase executeQuery:@MP_GetDevicelistForOuterRoom];
    
    return [self buildXMLForResultSet:fmResultSet];
}
#pragma mark -



#pragma mark - buildXML
/*－－－－－－－－－－－－－－－－－
 根据FMResultSet 生成XML
 －－－－－－－－－－－－－－－－－*/
-(NSString*)buildXMLForResultSet:(FMResultSet*)fmResultSet{
    
    NSMutableArray* finalResultlist    = [NSMutableArray array];
    NSMutableArray* subResultlist      = [NSMutableArray array];
    
    while ([fmResultSet next]) {
        subResultlist = [NSMutableArray array];
        SGDataBaseRowItem* resultItem = [[SGDataBaseRowItem alloc] init];
        
        for(int i = 0; i < [fmResultSet columnCount];i++){
            [resultItem setValue:[fmResultSet stringForColumn:[fmResultSet columnNameForIndex:i]]
                          forKey:[fmResultSet columnNameForIndex:i]];}
        [finalResultlist addObject:resultItem];}

    NSPredicate* predicate;
    
    NSMutableString* xMLString = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>"];

    for(NSString *rowId in [[finalResultlist valueForKeyPath:@"@distinctUnionOfObjects.roomid"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]){
        
        predicate = [NSPredicate predicateWithFormat:@"roomid == %@",
                     rowId];
        
        NSArray* firstClasslist = [finalResultlist filteredArrayUsingPredicate:predicate];
        
        [xMLString appendString:[NSString stringWithFormat:@"<room id=\"%@\" name=\"%@\">",
                                 [(SGDataBaseRowItem*)[firstClasslist objectAtIndex:0] roomid],
                                 [(SGDataBaseRowItem*)[firstClasslist objectAtIndex:0] roomname]]];
 
        for(NSString* cubicleId in [[firstClasslist valueForKeyPath:@"@distinctUnionOfObjects.cubicleid"] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]){
            
            predicate = [NSPredicate predicateWithFormat:@"cubicleid == %@",
                         cubicleId];
            
            NSArray* secondClasslist = [firstClasslist filteredArrayUsingPredicate:predicate];
            
            [xMLString appendString:[NSString stringWithFormat:@"<cubicle id=\"%@\" name=\"%@\">",
                                     [(SGDataBaseRowItem*)[secondClasslist objectAtIndex:0] cubicleid],
                                     [(SGDataBaseRowItem*)[secondClasslist objectAtIndex:0] cubiclename]]];
            
            for(SGDataBaseRowItem * rowItem__ in secondClasslist){
                [xMLString appendString:@"<device><deviceid>"];
                [xMLString appendString:rowItem__.deviceid];
                [xMLString appendString:@"</deviceid><devicename>"];
                [xMLString appendString:rowItem__.devicename];
                [xMLString appendString:@"</devicename></device>"];
            }
            
            [xMLString appendString:@"</cubicle>"];} [xMLString appendString:@"</room>"]; }
    
    [xMLString appendString:@"</root>"];  return xMLString;
}
#pragma mark -

@end

