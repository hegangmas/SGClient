//
//  SGDbBussiness.h
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGBaseBussiness.h"

@interface SGMainPageBussiness : SGBaseBussiness

+(SGMainPageBussiness*)sharedSGMainPageBussiness;


/*－－－－－－－－－－－－－－－－－
 获得指定ROOM ID 的DEVICE列表
 INPUT: ROOM_ID (INT)
 －－－－－－－－－－－－－－－－－*/
-(NSString*)queryDevicelistForRoomWithRoomId:(NSInteger)roomId;


/*－－－－－－－－－－－－－－－－－
 获得ROOM ID ＝ 0 DEVICE列表
 INPUT: NULL
 －－－－－－－－－－－－－－－－－*/
-(NSString*)queryDevicelistForOuterRoom;

-(NSString*)buildXMLForResultSet:(FMResultSet*)fmResultSet;

@end



@interface SGDataBaseRowItem : NSObject

@property(nonatomic,strong) NSString *roomid;
@property(nonatomic,strong) NSString *roomname;
@property(nonatomic,strong) NSString *cubicleid;
@property(nonatomic,strong) NSString *cubiclename;
@property(nonatomic,strong) NSString *deviceid;
@property(nonatomic,strong) NSString *devicename;

@end


