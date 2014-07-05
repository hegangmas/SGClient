//
//  SGMainViewController.h
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseViewController.h"

@interface SGMainViewController : SGBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


//扫码功能调用接口
-(void)scanModeWithCubicleId:(NSInteger)cubicleId withCableId:(NSInteger)cableId;
@end
