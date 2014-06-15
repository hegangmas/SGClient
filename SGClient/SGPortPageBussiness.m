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
#define FP_GetInfoSetList(p) [NSString stringWithFormat:@"select infoset_id,name,description,type,[group],txiedport_id,switch1_rxport_id,switch1_txport_id,\
           switch2_rxport_id,switch2_txport_id,switch3_rxport_id,switch3_txport_id,rxiedport_id from infoset \
            where txiedport_id = %@ or switch1_rxport_id = %@ or switch1_txport_id = %@  \
                                    or switch2_rxport_id = %@ or switch2_txport_id = %@ or switch3_rxport_id = %@ \
                                    or switch3_txport_id = %@ or rxiedport_id = %@",p,p,p,p,p,p,p,p]

@interface SGPortPageBussiness()

@end

@implementation SGPortPageBussiness

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGPortPageBussiness)


-(NSString*)queryPortsInfoByPortId:(NSString*)portId{
    
    NSArray* infosetList = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:FP_GetInfoSetList(portId)] withEntity:@"SGInfoSetItem"];
    
    
    
    
    return nil;
}

@end
