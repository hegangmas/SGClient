//
//  SGCablePageBussiness.m
//  SGClient
//
//  Created by JY on 14-5-19.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGCablePageBussiness.h"
#import <objc/message.h>

@implementation SGCPConnectionItem
@end

@implementation SGCPDataBaseRowItem
@end

@implementation SGCPDataItem

-(instancetype)initWithCableId:(NSString*)cableId withCableName:(NSString*)cableName
       withCableType:(NSString*)cableType
       withCubicleId:(NSString*)cubicleId
     withCubicleName:(NSString*)cubicleName
        withDrawFlag:(NSString *)drawFlag{
    
    if (self = [super init]) {
        _cable_id = cableId;
        _cable_name = cableName;
        _cable_type = cableType;
        _cubicle_id = cubicleId;
        _cubicle_name = cubicleName;
        _drawFlag = drawFlag;
    }
    return self;
}
@end

@interface SGCablePageBussiness()

@property(nonatomic,strong) NSArray *connectionList;
@property(nonatomic,strong) NSArray *cableOfType0List;
@property(nonatomic,strong) NSArray *cableOfType1List;
@property(nonatomic,strong) NSArray *connectionOrder;


@end

#define CABLETYPE0 0
#define CABLETYPE1 1
#define CABLETYPE2 2

/*－－－－－－－－－－－－－－－－－
 SQL 根据Cubicleidid
 
 获取Connection表信息
 －－－－－－－－－－－－－－－－－*/
#define CP_GetCubicleConnect(v) [NSString stringWithFormat:@"select use_odf1,use_odf2,connection_id,cubicle1_id,passcubicle1_id,cubicle2_id,passcubicle2_id\
                                                 from cubicle_connection where cubicle1_id = %d or cubicle2_id = %d or \
                                                      passcubicle1_id = %d or passcubicle2_id = %d",v,v,v,v]

/*－－－－－－－－－－－－－－－－－
 SQL 根据Cubicleidid 和 CableTyoe
 
 获取该Id相关的Cable信息
 －－－－－－－－－－－－－－－－－*/
#define CP_GetCablelist(v,t) [NSString stringWithFormat:@"select cable_id,cubicle1_id,cubicle2_id,name as cable_name,cable_type,\
                           (select name from cubicle where cable.cubicle1_id =cubicle.cubicle_id) as cubicle1_name, \
                           (select name from cubicle where cable.cubicle2_id =cubicle.cubicle_id) as cubicle2_name \
                            from cable where (cubicle1_id in ( \
                            select * from ( select cubicle1_id from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or \
                            passcubicle1_id = %d or passcubicle2_id = %d union \
                            select passcubicle1_id  from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or \
                            passcubicle1_id = %d or passcubicle2_id = %d union \
                            select passcubicle2_id  from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or\
                            passcubicle1_id = %d or passcubicle2_id = %d union \
                            select cubicle2_id from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or \
                            passcubicle1_id = %d or passcubicle2_id = %d \
                            )) or cubicle2_id in ( \
                            select * from (select cubicle1_id from cubicle_connection\
                            where cubicle1_id = %d or cubicle2_id = %d or\
                            passcubicle1_id = %d or passcubicle2_id = %d union\
                            select passcubicle1_id  from cubicle_connection\
                            where cubicle1_id = %d or cubicle2_id = %d or\
                            passcubicle1_id = %d or passcubicle2_id = %d union \
                            select passcubicle2_id  from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or \
                            passcubicle1_id = %d or passcubicle2_id = %d union \
                            select cubicle2_id from cubicle_connection \
                            where cubicle1_id = %d or cubicle2_id = %d or \
                            passcubicle1_id = %d or passcubicle2_id = %d\
                            ))) and cable.cable_type = %d",v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,v,t]

/*－－－－－－－－－－－－－－－－－
 SQL 根据Cubicleid
 
 获取Cable信息  type = 2
 －－－－－－－－－－－－－－－－－*/
#define CP_GetCubicleItem(v,t) [NSString stringWithFormat:@"select cable.cable_id,cable.cable_type,cable.name as cable_name,%d as cubicle_id,\
                                          (select name from cubicle where cubicle_id = %d) as cubicle_name from cable where \
                                          (cable.cubicle1_id = %d  and cable.cubicle2_id = %d)   \
                                            and cable_type = %d",v,v,v,v,t]



@implementation SGCablePageBussiness

GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(SGCablePageBussiness)

-(id)init{
    if (self = [super init]) {
        //连接顺序
        _connectionOrder = [NSArray arrayWithObjects:
                            @"cubicle1_id",
                            @"passcubicle1_id",
                            @"passcubicle2_id",
                            @"cubicle2_id", nil];
    }
    return self;
}


/*－－－－－－－－－－－－－－－－－－－－－
 根据请求CubicleId返回XML STRING
 
 1.光缆连接  2.尾缆连接 3.跳缆连接
 绘制光缆连接时 如有光缆连接 则也需画出尾缆连接
 －－－－－－－－－－－－－－－－－－－－－*/
-(NSDictionary*)queryCablelistWithCubicleId:(NSInteger)cubicleId{

//    NSLog(@"%@",CP_GetCablelist(cubicleId,CABLETYPE0));
//    NSLog(@"%@",CP_GetCubicleConnect(cubicleId));
    
    //光缆列表
    self.cableOfType0List = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:CP_GetCablelist(cubicleId,CABLETYPE0)]
                                             withEntity:@"SGCPDataBaseRowItem"];
    //尾缆列表
    self.cableOfType1List = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:CP_GetCablelist(cubicleId,CABLETYPE1)]
                                             withEntity:@"SGCPDataBaseRowItem"];
    //连接关系列表
    self.connectionList   = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:CP_GetCubicleConnect(cubicleId)]
                                             withEntity:@"SGCPConnectionItem"];
    
    NSArray* type0List = [self requestListWithCubicleId:cubicleId WithType:CABLETYPE0];
    NSArray* type1List = [self requestListWithCubicleId:cubicleId WithType:CABLETYPE1];
    
    NSArray* type2List = [SGUtility getResultlistForFMSet:[self.dataBase executeQuery:CP_GetCubicleItem(cubicleId, CABLETYPE2)]
                                          withEntity:@"SGCPDataItem"];
    type0List = [self verifyType0ListWithCubicleId:cubicleId withList:type0List];
    
    NSDictionary* result = [NSDictionary dictionaryWithObjectsAndKeys:type0List,@"type0",
                            type1List,@"type1",
                            type2List,@"type2",
                            nil];
    return result;
//    return [self buildXMLForResultSet:result];
}


/*－－－－－－－－－－－－－－－－－
 请求Cubicle直连的左右两边光缆 
 如有重复只需绘制一次
 
 如直连的左右两边没有光缆 删除此条记录
 －－－－－－－－－－－－－－－－－*/
-(NSArray*)verifyType0ListWithCubicleId:(NSInteger)cubicleId withList:(NSArray*)list{
    
    NSMutableDictionary* cachedSet = [NSMutableDictionary dictionary];
    NSMutableArray* _list = [list mutableCopy];
    NSString* key;
    NSInteger index;
    SGCPDataItem* tmpItem1;
    SGCPDataItem* tmpItem2;
    BOOL flag = NO;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"cubicle_id == %@",
                              [NSString stringWithFormat:@"%d",cubicleId]];
    for(NSArray* connection in [NSArray arrayWithArray:_list]){
        NSArray* tmp = [connection filteredArrayUsingPredicate:predicate];
        index = [connection indexOfObject:[tmp objectAtIndex:0]];
 
        if ((index-1)>=0) {
            
            tmpItem1 = [connection objectAtIndex:index-1];
            key = [NSString stringWithFormat:@"%@##%d",tmpItem1.cubicle_id,cubicleId];
            if ([tmpItem1.cable_type integerValue] == 0) {
                flag = YES;
            } else { flag = NO;}

            if ([cachedSet valueForKey:key]) {
                [(SGCPDataItem*)[connection objectAtIndex:index-1] setValue:@"0" forKey:@"drawFlag"];
            } else {
                [cachedSet setObject:@"Y" forKey:key];
            }
        }
        if ((index+1)<[connection count]) {
            tmpItem2 = [connection objectAtIndex:index+1];
            key = [NSString stringWithFormat:@"%d##%@",cubicleId,
                   tmpItem2.cubicle_id];
            if ([tmpItem2.cable_type integerValue] == 0) {
                flag = YES;
            } else { flag = NO;}
            
            if ([cachedSet valueForKey:key]) {
                [tmpItem2 setValue:@"0" forKey:@"drawFlag"];
            } else {
                [cachedSet setObject:@"Y" forKey:key];
            }
        }
        if (!flag) {
            [_list removeObject:connection];
        }
    }

    return _list;
}

/*－－－－－－－－－－－－－－－－－
 连接是否已添加
 －－－－－－－－－－－－－－－－－*/
-(BOOL)checkConnectionExistsWithList:(NSArray*)list withSubList:(NSArray*)slist{
    
    NSArray* idlist1;
    NSArray* slistId = [slist valueForKeyPath:@"@distinctUnionOfObjects.cubicle_id"];
    BOOL flag = YES;
    for(NSArray* cubicles in list){
        idlist1 = [cubicles valueForKeyPath:@"@distinctUnionOfObjects.cubicle_id"];
        
        flag = YES;
        if ([idlist1 count] == [slistId count]) {
            for(NSString* cubicleId in idlist1){
                if (![slistId containsObject:cubicleId]) {
                    flag = NO;
                }
            }
            if (flag) {
                return YES;
            }
        }
    }
    return NO;
}

/*－－－－－－－－－－－－－－－－－
 根据CubicleId Type 获取List
 
 －－－－－－－－－－－－－－－－－*/
-(NSArray*)requestListWithCubicleId:(NSInteger)cubicleId WithType:(NSInteger)type{
    
    NSInteger indexInOrderList;
    NSInteger indexInOrderListTmp;
    NSString* tmpValue;
    
    NSMutableArray* connection;
    NSMutableArray* connectionCubicles;
    NSMutableArray* retList;
    NSArray* cableItem;
    NSMutableDictionary* kvPairs;
    
    BOOL isContainsGLConn = NO;   //连接关系是否连有光缆
    
    retList = [NSMutableArray array];
    
    //遍历连接关系表
    for(SGCPConnectionItem* connectionItem in self.connectionList){
        isContainsGLConn = NO;
        //use_odf1=1 OR use_odf2=1 则必包含光缆连接
        if ([connectionItem.use_odf1 integerValue]||[connectionItem.use_odf2 integerValue]) {
            isContainsGLConn = YES;
        }
        
        connection = [NSMutableArray array];
        kvPairs    = [NSMutableDictionary dictionary];
        
        //获取主CubicleId在连接顺序表中的位置
        indexInOrderList = [self getIndexOfCurrentCubicleWithConnItem:connectionItem
                                                               withId:cubicleId];
      
        indexInOrderListTmp = indexInOrderList;
        //关系链向前查询
        while (indexInOrderListTmp>=0) {
            indexInOrderListTmp--;
            if (indexInOrderListTmp>=0) {
                tmpValue = [connectionItem valueForKey:[self.connectionOrder objectAtIndex:indexInOrderListTmp]];
                //值不等于cubicleId不等于0
                if ([tmpValue integerValue] != cubicleId && ![tmpValue isEqualToString:@"0"]) {
                    //添加目标cubicleId到数组
                    [connection addObject:tmpValue];
                    [kvPairs setValue:[self.connectionOrder objectAtIndex:indexInOrderListTmp]
                               forKey:tmpValue];
                }
            }
        }
        
        //调整数据顺序
        connection = [[[connection reverseObjectEnumerator] allObjects] mutableCopy];
        
        //添加主cubicleId
        [connection addObject:[NSString stringWithFormat:@"%d",cubicleId]];
        [kvPairs setValue:[self.connectionOrder objectAtIndex:indexInOrderList]
                   forKey:[NSString stringWithFormat:@"%d",cubicleId]];
        
        indexInOrderListTmp = indexInOrderList;
        
        //关系链向后查询
        while (indexInOrderListTmp<=[self.connectionOrder count]-1) {
            indexInOrderListTmp++ ;
            if (indexInOrderListTmp<=[self.connectionOrder count]-1) {
                tmpValue = [connectionItem valueForKey:[self.connectionOrder objectAtIndex:indexInOrderListTmp]];
                if ([tmpValue integerValue] != cubicleId && ![tmpValue isEqualToString:@"0"]) {
                    [connection addObject:tmpValue];
                    [kvPairs setValue:[self.connectionOrder objectAtIndex:indexInOrderListTmp]
                               forKey:tmpValue];
                }
            }
        }
        //调整连接方向 如在尾部，把请求Cubicle置于开始
        //如果请求Cubicle不在首尾，其左侧绘制同序Cubicle 右侧绘制不同序Cubicle
        connection = [[self resortConnectionOrderWithArray:connection
                                                 withPairs:kvPairs
                                             withCubicleId:cubicleId] mutableCopy];

        //有和指定Cubicle连接的
        if ([connection count] > 1) {
            if (type == CABLETYPE0) {
                if (!isContainsGLConn) {
                    continue;
                }
            }

            connectionCubicles = [NSMutableArray array];
            
            //两两检查Cubicle的光缆连接情况
            for(int i = 0; i < [connection count]-1; i++){
                
                //获取光缆
                cableItem = [self getConnectedCubicleInfoWithTmpId:[[connection objectAtIndex:i] integerValue]
                                                         withTmpId:[[connection objectAtIndex:i + 1] integerValue]
                                                         withPairs:kvPairs
                                                          withType:(NSInteger)type
                                                       withUseOdf1:[connectionItem.use_odf1 integerValue]
                                                       withUseOdf2:[connectionItem.use_odf2 integerValue]];
                //连接存在
                if (cableItem) {
                    if ([connectionCubicles count]) {
                        [connectionCubicles addObject:[cableItem objectAtIndex:1]];
                    } else {
                        [connectionCubicles addObject:[cableItem objectAtIndex:0]];
                        [connectionCubicles addObject:[cableItem objectAtIndex:1]];
                    }
                //否则中止
                } else { break;}
            }
        }
        if (connectionCubicles) {
            if ([connectionCubicles count]>0) {
                if (![self checkConnectionExistsWithList:retList
                                             withSubList:connectionCubicles]) {
                    
                    //尾缆调整顺序 如请求Cubicle在尾部 倒转顺序
                    if (type == CABLETYPE1) {
                        SGCPDataItem* cubicle = [connectionCubicles objectAtIndex:[connectionCubicles count]-1];
                        if ([cubicle.cubicle_id integerValue] == cubicleId) {
                            
                            SGCPDataItem* tmp;
                            connectionCubicles = [[[connectionCubicles reverseObjectEnumerator] allObjects] mutableCopy];
                            
                            for(int i = 0; i<[connectionCubicles count]-1;i++){
                                SGCPDataItem* cubicle1 = [connectionCubicles objectAtIndex:i];
                                SGCPDataItem* cubicle2 = [connectionCubicles objectAtIndex:i+1];
                                SGCPDataItem* _tmp;
                                
                                if (!i) {_tmp = cubicle1;} else {_tmp = tmp;}
                                
                                tmp = cubicle2;
                                cubicle2.cable_id   = _tmp.cable_id;
                                cubicle2.cable_type = _tmp.cable_type;
                                cubicle2.cable_name = _tmp.cable_name;
                            }
                            tmp = [connectionCubicles objectAtIndex:0];
                            tmp.cable_type = @"";
                            tmp.cable_name = @"";
                            tmp.cable_id   = @"";
                        }}
                    [retList addObject:connectionCubicles];
                }
            }
        }
    }
    return retList;
}


/*－－－－－－－－－－－－－－－－－
 获取CubicleId在连接顺序中的索引
 －－－－－－－－－－－－－－－－－*/
-(NSInteger)getIndexOfCurrentCubicleWithConnItem:(SGCPConnectionItem*)item
                                          withId:(NSInteger)cubcleId{
    unsigned int outCount;
    NSString* property;
    objc_property_t *properties;
    properties = class_copyPropertyList([SGCPConnectionItem class], &outCount);
    
    for(int i = 0; i < outCount;i++){
        property = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        if ([[item valueForKey:property] integerValue] == cubcleId) {
            return [self.connectionOrder indexOfObject:property];
        }
    }
    return -1;
}

/*－－－－－－－－－－－－－－－－－
 判断两个Field之间的光缆类型
 Or
 排序时判断是否同一边
 －－－－－－－－－－－－－－－－－*/
-(NSInteger)getCableTypeBetweenField1:(NSString*)field1
                               field2:(NSString*)field2
                          withUseOdf1:(NSInteger)useOdf1
                          withUseOdf2:(NSInteger)useOdf2{
    if (!useOdf1 && !useOdf2) {
        return 1;
    }
    
    if (([field1 isEqualToString:@"cubicle1_id"] && [field2 isEqualToString:@"passcubicle1_id"]) ||
        ([field1 isEqualToString:@"passcubicle1_id"] && [field2 isEqualToString:@"cubicle1_id"]) ||
        ([field1 isEqualToString:@"cubicle2_id"] && [field2 isEqualToString:@"passcubicle2_id"]) ||
        ([field1 isEqualToString:@"passcubicle2_id"] && [field2 isEqualToString:@"cubicle2_id"])){
        return 1;
    }
    return 0;
}

/*－－－－－－－－－－－－－－－－－
 根据cubicleid1 cubicleid2 type 
 
 获取Cable信息
 －－－－－－－－－－－－－－－－－*/
-(NSArray*)getConnectedCubicleInfoWithTmpId:(NSInteger)tid1
                                  withTmpId:(NSInteger)tid2
                                  withPairs:(NSDictionary*)dic
                                   withType:(NSInteger)_type
                                withUseOdf1:(NSInteger)useOdf1
                                withUseOdf2:(NSInteger)useOdf2{
    
    NSString* stid1 = [NSString stringWithFormat:@"%d",tid1];
    NSString* stid2 = [NSString stringWithFormat:@"%d",tid2];
    
    NSInteger type = [self getCableTypeBetweenField1:[dic valueForKey:stid1]
                                              field2:[dic valueForKey:stid2]
                                         withUseOdf1:useOdf1
                                         withUseOdf2:useOdf2];
    
    //如果是只绘制尾缆 跳过光缆
    if (_type == CABLETYPE1) {
        if (type!=_type) {
            return nil;
        }
    }
    
    SGCPDataBaseRowItem * cableRowItem;
    SGCPDataItem* basicItem;
    NSMutableArray* retList;
    NSString* cubicleName;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"(cubicle1_id == %@ and cubicle2_id == %@) or \
                              (cubicle2_id == %@ and cubicle1_id == %@)",stid1,stid2,stid1,stid2];
    
    NSArray* filteredList;
    
    switch (type) {
            //光缆
        case CABLETYPE0:
            filteredList = [self.cableOfType0List filteredArrayUsingPredicate:predicate];
            break;
            //尾缆
        case CABLETYPE1:
            filteredList = [self.cableOfType1List filteredArrayUsingPredicate:predicate];
            break;
        default:
            break;
    }
    
    if (filteredList) {
        if ([filteredList count]>0) {
            cableRowItem = [filteredList objectAtIndex:0];
            retList = [NSMutableArray array];
            if (cableRowItem) {
                
                cubicleName = ([stid1 isEqualToString:cableRowItem.cubicle1_id])? cableRowItem.cubicle1_name:
                cableRowItem.cubicle2_name;
                basicItem = [[SGCPDataItem alloc] initWithCableId:@""
                                                    withCableName:@""
                                                    withCableType:@""
                                                    withCubicleId:stid1
                                                  withCubicleName:cubicleName
                                                     withDrawFlag:@""];
                [retList addObject:basicItem];
                
                cubicleName = ([stid2 isEqualToString:cableRowItem.cubicle1_id])? cableRowItem.cubicle1_name:
                cableRowItem.cubicle2_name;
                basicItem = [[SGCPDataItem alloc] initWithCableId:cableRowItem.cable_id
                                                    withCableName:cableRowItem.cable_name
                                                    withCableType:cableRowItem.cable_type
                                                    withCubicleId:stid2
                                                  withCubicleName:cubicleName
                                                     withDrawFlag:@"1"];
                [retList addObject:basicItem];
            }
        }
    }
    return retList;
}

/*－－－－－－－－－－－－－－－－－
 重新排序
 －－－－－－－－－－－－－－－－－*/
-(NSArray*)resortConnectionOrderWithArray:(NSArray*)array
                                withPairs:(NSDictionary*)pair
                            withCubicleId:(NSInteger)cubicleId{
    
    NSString* scubicleId = [NSString stringWithFormat:@"%d",cubicleId];
    NSInteger index = [array indexOfObject:scubicleId];
    
    if (index == 0) {
    } else if (index==[array count]-1){
        return [[array reverseObjectEnumerator] allObjects];
    } else {
        
        NSString* field1 = [pair valueForKey:scubicleId];
        NSString* field2 = [pair valueForKey:[array objectAtIndex:index - 1]];
        
        if (![self getCableTypeBetweenField1:field1
                                      field2:field2
                                 withUseOdf1:1
                                 withUseOdf2:1]) {
            
            return [[array reverseObjectEnumerator] allObjects];
        }
    }
    return array;
}

/*－－－－－－－－－－－－－－－－－
 根据RESULT LIST 生成XML
 －－－－－－－－－－－－－－－－－*/
-(NSString*)buildXMLForResultSet:(NSDictionary*)resultList{
    
    NSMutableString* xMLString = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>"];
    [resultList.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [xMLString appendString:[NSString stringWithFormat:@"<%@>",(NSString*)obj]];
        
        if (![obj isEqualToString:@"type2"]) {

            NSArray* connList = [resultList valueForKey:(NSString*)obj];
            [connList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [xMLString appendString:@"<connection>"];
                NSArray* connItem = (NSArray*)obj;
                [connItem enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    [xMLString appendString:@"<cubicle>"];
                    SGCPDataItem* cubicle = (SGCPDataItem*)obj;
                    unsigned int outCount;
                    objc_property_t *properties;
                    NSString* property;
                    
                    properties = class_copyPropertyList([SGCPDataItem class], &outCount);
                    
                    for(int i = 0; i < outCount;i++){
                        property = [NSString stringWithUTF8String:property_getName(properties[i])];
                        
                        [xMLString appendString:[NSString stringWithFormat:@"<%@>%@</%@>",
                                                 property,
                                                 [cubicle valueForKey:property],
                                                 property]];
                    }
                    
                    [xMLString appendString:@"</cubicle>"];}];
                    [xMLString appendString:@"</connection>"];}];
            
        }else {
            
            NSArray* connList = [resultList valueForKey:(NSString*)obj];
            if (connList.count) {
                SGCPDataItem* dataItem = [connList objectAtIndex:0];
                [xMLString appendString:[NSString stringWithFormat:@"<cubicle id = \"%@\" name = \"%@\">",dataItem.cubicle_id,dataItem.cubicle_name]];
                [connList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    SGCPDataItem* dataItem = (SGCPDataItem*)obj;
                    [xMLString appendString:[NSString stringWithFormat:@"<cable id = \"%@\" type =\"%@\">%@</cable>",
                                             dataItem.cable_id,
                                             dataItem.cable_type,
                                             dataItem.cable_name]];
                }];[xMLString appendString:@"</cubicle>"];
            }}
               [xMLString appendString:[NSString stringWithFormat:@"</%@>",(NSString*)obj]];}];
               [xMLString appendString:@"</root>"];
    
    return xMLString;
}
@end
