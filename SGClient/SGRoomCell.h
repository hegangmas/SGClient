//
//  SGRoomCell.h
//  SGClient
//
//  Created by JY on 14-6-16.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGRoomCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceListView;
@property (weak, nonatomic) IBOutlet UILabel *roomInfo;
@property (nonatomic,strong) NSDictionary* data;

+(CGSize) cellsize;
@end
