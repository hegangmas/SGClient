//
//  SGFiberPageBussiness.m
//  SGClient
//
//  Created by JY on 14-6-3.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGFiberPageBussiness.h"

@implementation SGFiberItem
@end

@implementation SGInfoSetItem
@end

@implementation SGResult
@end

/*－－－－－－－－－－－－－－－－－
 根据CableId 获取纤芯信息列表
 －－－－－－－－－－－－－－－－－*/
#define FP_GetFiberItemList(cableId) [NSString stringWithFormat:@"select fiber_id,cable_id,port1_id,port2_id,\
                      [index],fiber_color,pipe_color,reserve from fiber where cable_id = %d",cableId]


#define FP_GetFiberItem(p1,p2) [NSString stringWithFormat:@"select fiber_id,cable_id,port1_id,port2_id,\
                      [index],fiber_color,pipe_color,reserve from fiber where (port1_id = %@ and port2_id = %@) or \
                          (port2_id = %@ and port1_id = %@)",p1,p2,p1,p2]

/*－－－－－－－－－－－－－－－－－
 根据两个端口号 获取另外两个端口
 －－－－－－－－－－－－－－－－－*/
#define FP_GetAnotherTwoPorts(p1,p2) [NSString stringWithFormat:@"select a.port1_id from(\
                      select port1_id  as port1_id  from fiber   where port1_id = %@ or port2_id = %@ union\
                      select port2_id  as port1_id  from fiber   where port1_id = %@ or port2_id = %@ union\
                      select port1_id  as port1_id  from fiber   where port1_id = %@ or port2_id = %@ union\
                      select port2_id  as port1_id  from fiber   where port1_id = %@ or port2_id = %@  ) a \
                            where a.port1_id not in (%@,%@)",p1,p1,p1,p1,p2,p2,p2,p2,p1,p2]

#define FP_CheckPortOrder(p1,p2) [NSString stringWithFormat:@"select fiber_id,cable_id,port1_id,port2_id,\
[index],fiber_color,pipe_color,reserve from fiber where (port1_id = %@ and port2_id = %@) or (port2_id = %@  and port1_id = %@)",p1,p2,p1,p2]

/*－－－－－－－－－－－－－－－－－
 根据两个端口号 获取InfoSet表信息
 －－－－－－－－－－－－－－－－－*/
#define FP_GetInfoSetList(p1,p2) [NSString stringWithFormat:@"select infoset_id,name,description,type,[group],txiedport_id,switch1_rxport_id,switch1_txport_id,\
             switch2_rxport_id,switch2_txport_id,switch3_rxport_id,switch3_txport_id,rxiedport_id from infoset \
                 where txiedport_id in (%@,%@) or switch1_rxport_id in (%@,%@) or switch1_txport_id in (%@,%@)  \
               or switch2_rxport_id in (%@,%@) or switch2_txport_id in (%@,%@) or switch3_rxport_id in (%@,%@) \
               or switch3_txport_id in (%@,%@) or rxiedport_id in (%@,%@)",p1,p2,p1,p2,p1,p2,p1,p2,p1,p2,p1,p2,p1,p2,p1,p2]

#define FP_GetDeviceInfo(p) [NSString stringWithFormat:@"select device.description from device\
               inner join board on device.device_id=board.device_id inner join port on board.board_id=port.board_id\
               where port.port_id = %@",p]

#define FP_GetPortInfo(p) [NSString stringWithFormat:@"select  port.name||'/'||board.position as  description  from port inner join board on board.board_id = port.board_id where port.port_id = %@",p]

#define FP_GetTXInfo(p1,p2) [NSString stringWithFormat:@"select cable.name ||':'||fiber.[index] as description from cable \
                                                      inner join fiber on cable.cable_id = fiber.cable_id\
                                                            where (fiber.port1_id = %@ and fiber.port2_id = %@) or (fiber.port2_id = %@ and fiber.port1_id = %@)",p1,p2,p1,p2]

#define FP_GetODFInfo(p) [NSString stringWithFormat:@"select name from port where port_id = %@",p]

@interface SGFiberPageBussiness()

@property (nonatomic,strong) NSArray *infoSetOrder;
@property (nonatomic,strong) NSArray *portList;
@end

@implementation SGFiberPageBussiness

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGFiberPageBussiness)


-(id)init{
    if (self = [super init]) {
        
        //infoset表匹配顺序
        _infoSetOrder = [NSArray arrayWithObjects:
                         @"txiedport_id",
                         @"switch1_rxport_id",
                         @"switch1_txport_id",
                         @"switch2_rxport_id",
                         @"switch2_txport_id",
                         @"switch3_rxport_id",
                         @"switch3_txport_id",
                         @"rxiedport_id",nil];
    }
    return self;
}
/*－－－－－－－－－－－－－－－－－
 根据CableId 获取纤芯信息列表
 －－－－－－－－－－－－－－－－－*/
-(NSString*)queryFiberInfoWithCableId:(NSInteger)cableId{
    
    //根据CableId 查询表 fiber
    NSArray* fiberList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetFiberItemList(cableId)]
                                                  withEntity:@"SGFiberItem"];
    NSMutableArray *retList = [NSMutableArray array];
    //遍历集合
    [fiberList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SGResult* resultItem   = [[SGResult alloc] init];
        SGFiberItem* fiberItem = (SGFiberItem*)obj;
        
        [self fillTypeFieldWithSGResult  :resultItem withSGFiberItem:fiberItem];
        [self fillDeviceFieldWithSGResult:resultItem withSGFiberItem:fiberItem];
        [self fillPortFieldWithSGResult  :resultItem withSGFiberItem:fiberItem];
        [self fillTXFieldWithSGResult    :resultItem withSGFiberItem:fiberItem];
        [self fillOdfFieldWithSGResult   :resultItem withSGFiberItem:fiberItem];
        [self fillColorFieldWithSGResult :resultItem withSGFiberItem:fiberItem];
        [retList addObject:resultItem];
    }];
    
    return nil;
}

-(void)fillColorFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{
    NSArray* desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetFiberItem(fiberItem.port1_id, fiberItem.port2_id)]
                                          withEntity:@"SGFiberItem"];
    if (desc) {
        if ([desc count]) {
            SGFiberItem* fiber = [desc objectAtIndex:0];
            NSString* color;
            switch ([fiber.fiber_color integerValue]) {
                case 0:
                    color = @"蓝";
                    break;
                case 1:
                    color = @"橙";
                    break;
                case 2:
                    color = @"绿";
                    break;
                case 3:
                    color = @"棕";
                    break;
                case 4:
                    color = @"灰";
                    break;
                case 5:
                    color = @"本";
                    break;
                case 6:
                    color = @"红";
                    break;
                case 7:
                    color = @"黑";
                    break;
                case 8:
                    color = @"黄";
                    break;
                case 9:
                    color = @"紫";
                    break;
                case 10:
                    color = @"粉红";
                    break;
                case 11:
                    color = @"青绿";
                    break;
                default:
                    break;
            }
            resultItem.mColor = color;
        }
    }
}

-(void)fillOdfFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{
    
    NSArray* desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetODFInfo(fiberItem.port1_id)]
                                          withEntity:@"SGInfoSetItem"];
    
    if (desc) {
        if ([desc count]) {
            resultItem.odf1 = [(SGInfoSetItem*)[desc objectAtIndex:0] name];
        }
    }
    
    desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetODFInfo(fiberItem.port2_id)]
                                          withEntity:@"SGInfoSetItem"];
    
    if (desc) {
        if ([desc count]) {
            resultItem.odf2 = [(SGInfoSetItem*)[desc objectAtIndex:0] name];
        }
    }
}


-(void)fillTXFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{
    
    NSArray* desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetTXInfo([[self.portList objectAtIndex:0] port1_id],fiberItem.port1_id)]
                                          withEntity:@"SGInfoSetItem"];
    if (desc) {
        if ([desc count]) {
          resultItem.tx1 = [(SGInfoSetItem*)[desc objectAtIndex:0] description];
        }
    }
    
    desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetTXInfo([[self.portList objectAtIndex:1] port1_id],fiberItem.port2_id)]
                                          withEntity:@"SGInfoSetItem"];
    if (desc) {
        if ([desc count]) {
            resultItem.tx2 = [(SGInfoSetItem*)[desc objectAtIndex:0] description];
        }
    }
}

/*－－－－－－－－－－－－－－－－－
 获取Port
 －－－－－－－－－－－－－－－－－*/
-(void)fillPortFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{

    NSLog(@"%@",FP_GetPortInfo([[self.portList objectAtIndex:0] port1_id]));
    NSArray* desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetPortInfo([[self.portList objectAtIndex:0] port1_id])]
                                          withEntity:@"SGInfoSetItem"];
    resultItem.port1 = [(SGInfoSetItem*)[desc objectAtIndex:0] description];
    
    desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetPortInfo([[self.portList objectAtIndex:1] port1_id])]
                                          withEntity:@"SGInfoSetItem"];
    resultItem.port2 = [(SGInfoSetItem*)[desc objectAtIndex:0] description];
}



/*－－－－－－－－－－－－－－－－－
 获取Device
 －－－－－－－－－－－－－－－－－*/
-(void)fillDeviceFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{
    NSArray* desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetDeviceInfo([[self.portList objectAtIndex:0] port1_id])]
                                              withEntity:@"SGInfoSetItem"];
    if (desc) {
        if ([desc count]) {
            resultItem.device1 = [[desc objectAtIndex:0] description];
        }
    }
    
    desc = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetDeviceInfo([[self.portList objectAtIndex:1] port1_id])]
                                 withEntity:@"SGInfoSetItem"];
    
    if (desc) {
        if ([desc count]) {
            resultItem.device2 = [[desc objectAtIndex:0] description];
        }
    }
}

/*－－－－－－－－－－－－－－－－－
 获取Type
 －－－－－－－－－－－－－－－－－*/
-(void)fillTypeFieldWithSGResult:(SGResult*)resultItem withSGFiberItem:(SGFiberItem*)fiberItem{
    //如果是备用
    if ([fiberItem.reserve isEqualToString:@"1"]) {
        resultItem.type1 = @"备用";
        resultItem.type2 = resultItem.type1;
    }else{
        //获得另外两个端口
        self.portList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetAnotherTwoPorts(fiberItem.port1_id,
                                                                                                               fiberItem.port2_id)]
                                                  withEntity:@"SGFiberItem"];
        if ([self checkPortListOrderWithSGFiberItem:fiberItem]) {
            self.portList = [[self.portList reverseObjectEnumerator] allObjects];
        }
        
        if (self.portList) {
            if ([self.portList count]) {
                NSArray* infoSetList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetInfoSetList([[self.portList objectAtIndex:0] port1_id],
                                                                                                                      [[self.portList objectAtIndex:1] port1_id])]
                                                             withEntity:@"SGInfoSetItem"];
                //用这两个端口遍历infoset表的顺序链
                for(SGInfoSetItem* infosetItem in infoSetList){
                    //两个端口匹配顺序链
                    if ([self checkInfoSetChainWithInfoSetItem:infosetItem withPorts:self.portList]) {
                        NSMutableString* type = [[NSMutableString alloc] init];
                        BOOL flag = [self checkIfSwFieldAllZeroWithInfoSetItem:infosetItem];
                        switch ([infosetItem.type integerValue]) {
                            case 0:
                                break;
                            case 1:
                                [type appendString:@"GOOSE"];
                                if (flag) {[type appendString:@"直跳"];}
                                break;
                            case 2:
                                [type appendString:@"SV"];
                                if (flag) {[type appendString:@"直采"];}
                                break;
                            case 3:
                                [type appendString:@"TIME"];
                                break;
                            case 4:
                                [type appendString:@"GOOSE/SV"];
                                if (flag) {[type appendString:@"直连"];}
                                break;
                            default:
                                break;
                        }
                        resultItem.type1 = type;
                        resultItem.type2 = type;
                    };
                }
            }
        }}
}

-(BOOL)checkPortListOrderWithSGFiberItem:(SGFiberItem*)fiberItem{
    
    NSArray* retList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_CheckPortOrder([[self.portList objectAtIndex:0] port1_id], fiberItem.port1_id)]
                          withEntity:@"SGFiberItem"];
    if (retList) {
        if ([retList count]) {
            return NO;
        }
    }
    return YES;
}


-(BOOL)checkInfoSetChainWithInfoSetItem:(SGInfoSetItem*)infoSetItem withPorts:(NSArray*)ports{
    
    NSString* port1 = [[ports objectAtIndex:0] port1_id];
    NSString* port2 = [[ports objectAtIndex:1] port1_id];
    NSString* tmpValue;
    NSInteger index = [self getIndexOfPortInInfoSetChainWithPort:port1 withInfoSetItem:infoSetItem];
    NSInteger indexTmp = index;
    
    while (indexTmp>=0) {
        indexTmp--;
        if (indexTmp>=0) {
             tmpValue = [infoSetItem valueForKey:[self.infoSetOrder objectAtIndex:indexTmp]];
            if ([tmpValue isEqualToString:port2]) {
                return YES;
            }
        }
    }
    indexTmp = index;
    while (indexTmp<[self.infoSetOrder count]) {
        indexTmp++;
        if (indexTmp<[self.infoSetOrder count]) {
            tmpValue = [infoSetItem valueForKey:[self.infoSetOrder objectAtIndex:indexTmp]];
            if ([tmpValue isEqualToString:port2]) {
                return YES;
            }
        }
    }
    return NO;
}

/*－－－－－－－－－－－－－－－－－
 获取Port在InfoSet连接顺序中的索引
 －－－－－－－－－－－－－－－－－*/
-(NSInteger)getIndexOfPortInInfoSetChainWithPort:(NSString*)port withInfoSetItem:(SGInfoSetItem*)infoSetItem{
    unsigned int outCount;
    NSString* property;
    objc_property_t *properties;
    properties = class_copyPropertyList([SGInfoSetItem class], &outCount);
    
    for(int i = 0; i < outCount;i++){
        property = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        if ([[infoSetItem valueForKey:property] isEqualToString:port]) {
            return [self.infoSetOrder indexOfObject:property];
        }
    }
    return -1;
}

/*－－－－－－－－－－－－－－－－－
 检查Infoset表Sw是否都为0
 －－－－－－－－－－－－－－－－－*/
-(BOOL)checkIfSwFieldAllZeroWithInfoSetItem:(SGInfoSetItem*)infoSetItem{
    
    return ([infoSetItem.switch1_rxport_id isEqualToString:@"0"]&&[infoSetItem.switch1_txport_id isEqualToString:@"0"]&&
            [infoSetItem.switch2_rxport_id isEqualToString:@"0"]&&[infoSetItem.switch2_txport_id isEqualToString:@"0"]&&
            [infoSetItem.switch3_rxport_id isEqualToString:@"0"]&&[infoSetItem.switch3_txport_id isEqualToString:@"0"]);
}

/*－－－－－－－－－－－－－－－－－
 根据RESULT LIST 生成XML
 －－－－－－－－－－－－－－－－－*/
-(NSString*)buildXMLForResultSet:(NSDictionary*)resultList{
    
    NSMutableString* xMLString = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>"];
    [resultList.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    }];
    [xMLString appendString:@"</root>"];
    return xMLString;
}

@end
