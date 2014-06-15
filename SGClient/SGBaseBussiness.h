//
//  SGBaseBussiness.h
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUGCDSingleton.h"
#import "SGDataBase.h"
#import "FMDatabase.h"
#import "SGEntity.h"

@interface SGBaseBussiness : NSObject

@property (nonatomic,strong) FMDatabase* dataBase;

@end


