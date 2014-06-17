//
//  SGPortPageBussiness.m
//  SGClient
//
//  Created by JY on 14-6-14.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGPortPageBussiness.h"

/*－－－－－－－－－－－－－－－－－
 根据两个端口号 获取InfoSet表信息
 －－－－－－－－－－－－－－－－－*/
#define FP_GetInfoSetList(p) [NSString stringWithFormat:@"select infoset_id,name,description,type,[group],txiedport_id,switch1_rxport_id,switch1_txport_id,txied_id,rxied_id,\
           switch2_rxport_id,switch2_txport_id,switch3_rxport_id,switch3_txport_id,rxiedport_id from infoset \
            where txiedport_id = %@ or switch1_rxport_id = %@ or switch1_txport_id = %@  \
                                    or switch2_rxport_id = %@ or switch2_txport_id = %@ or switch3_rxport_id = %@ \
                                    or switch3_txport_id = %@ or rxiedport_id = %@",p,p,p,p,p,p,p,p]

#define FP_GetVterminalList(d) [NSString stringWithFormat:@"select vterminal_id,device_id,type,direction,vterminal_no,pro_desc from vterminal where device_id = %@",d]

#define FP_GetVterminalItem(v) [NSString stringWithFormat:@"select vterminal_id,device_id,type,direction,vterminal_no,pro_desc from vterminal where vterminal_id = %@",v]

#define FP_GetVterminalConnection(c) [NSString stringWithFormat:@"select rxvterminal_id,txvterminal_id from vterminal_connection where %@",c]


@interface SGPortPageBussiness()

@property(nonatomic,strong) NSMutableArray *resultList;
@end

@implementation SGPortPageBussiness

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGPortPageBussiness)


/*－－－－－－－－－－－－－－－－－
 portId满足type!=2
 －－－－－－－－－－－－－－－－－*/
-(NSString*)queryPortsInfoByPortId:(NSString*)portId{
    
    self.resultList = [NSMutableArray array];
    NSArray* infosetList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetInfoSetList(portId)] withEntity:@"SGInfoSetItem"];
    
    NSString* deviceId;
    NSString* deviceId2;
    if ([infosetList count]) {
        SGInfoSetItem* infoSetItem = infosetList[0];
        if ([infoSetItem.rxiedport_id isEqualToString:portId]) {
            deviceId  = infoSetItem.rxied_id;
            deviceId2 = infoSetItem.txied_id;
        }else{
            deviceId  = infoSetItem.txied_id;
            deviceId2 = infoSetItem.rxied_id;
        }
    }
    
    NSArray* vterminalList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetVterminalList(deviceId)] withEntity:@"SGVterminal"];
    
    NSString* conditions;
    for(SGVterminal* vterminalItem in vterminalList){
        if ([vterminalItem.direction isEqualToString:@"1"]) {
            conditions = [NSString stringWithFormat:@"txvterminal_id = %@",vterminalItem.vterminal_id];
        }else {
            conditions = [NSString stringWithFormat:@"rxvterminal_id = %@",vterminalItem.vterminal_id];
        }
        
        NSArray* tmpConnection = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetVterminalConnection(conditions)] withEntity:@"SGVterminalConnection"];
        if ([tmpConnection count]) {
            for(SGVterminalConnection *connection in tmpConnection){
                NSArray* tmpVterminal = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetVterminalItem(([vterminalItem.direction isEqualToString:@"1"]?connection.rxvterminal_id:connection.txvterminal_id))] withEntity:@"SGVterminal"];
                if ([tmpVterminal count]) {
                    SGVterminal* item = tmpVterminal[0];
                    if ([item.device_id isEqualToString:deviceId2]) {
                        [self.resultList addObject:vterminalItem];
                    }
                }
            }
        }
    }
    return nil;
}

@end
