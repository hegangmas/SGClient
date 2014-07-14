//
//  SGCableViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDrawViewController.h"
#import "SGGenerateCubicleSvg.h"

@interface SGCableViewController : SGDrawViewController
@property (nonatomic,strong) NSDictionary *cubicleData;

@property (nonatomic,assign) NSInteger scannedCubicleId;
@property (nonatomic,assign) NSInteger scannedCableId;

-(instancetype)initWithCubicleData:(NSDictionary*)cubicleData withCubicleId:(NSInteger)cubicleId withCableId:(NSInteger)cableId;

@end

 
