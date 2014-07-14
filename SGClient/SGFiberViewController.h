//
//  SGFiberViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDrawViewController.h"
#import "SGGenerateCubicleSvg.h"


@interface SGFiberViewController : SGDrawViewController

@property(nonatomic,strong) NSString* cubicleId;
@property(nonatomic,strong) NSString *cableId;
@property(nonatomic,strong) NSString *cableName;
@property(nonatomic,assign) NSInteger cableType;

@property (nonatomic,strong) NSArray* type0listSorted;
@property (nonatomic,strong) NSArray* type1list;
@property (nonatomic,strong) NSArray* type2list;
@property (nonatomic,strong) NSArray* mergedCubicles;
@property (nonatomic,strong) NSDictionary* cubicleData;


@end
