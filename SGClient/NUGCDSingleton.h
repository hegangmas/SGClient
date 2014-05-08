//
//  NUGCDSingleton.h
//  SGClient
//
//  Created by JY on 14-5-5.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#define GCD_SYNTHESIZE_SINGLETON_FOR_CLASS(classname)\
\
+(classname *)shared##classname {\
\
    static classname *sharedInstance = nil;\
\
    static dispatch_once_t predicate;\
\
    dispatch_once(&predicate, ^{\
\
        sharedInstance = [[self alloc] init];\
\
    });\
\
    return sharedInstance;\
}