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

-(NSString*)queryPortsInfoByPortId:(NSString*)portId;

@end
