//
//  SGDataBase.h
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUGCDSingleton.h"
#import "FMDatabase.h"
#import "SGUtility.h"

@interface SGDataBase : NSObject

+(SGDataBase*)sharedSGDataBase;

-(FMDatabase*)dataBase;

@end


