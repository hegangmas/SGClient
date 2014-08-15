//
//  SGPortPageBussiness.h
//  SGClient
//
//  Created by JY on 14-6-14.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGBaseBussiness.h"
 

@interface SGPortPageBussiness : SGBaseBussiness

+(SGPortPageBussiness*)sharedSGPortPageBussiness;

-(NSArray*)queryPortsInfoByPortId:(NSString*)portId;

-(NSArray*)queryAllInfoById:(NSString*)portId;

@property (nonatomic,assign) BOOL isShowAll;
@end
