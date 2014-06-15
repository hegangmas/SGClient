//
//  SGLeftDock.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "UIImage+Fit.h"
#import "SGLeftDock.h"
#import "SGLeftDockItem.h"
#import "SGLeftDockButton.h"


@interface SGLeftDock()

@property (nonatomic,strong) NSArray *dockItems;
@property (nonatomic,strong) SGLeftDockButton* currentDockBtn;
@property (nonatomic,strong) UIImageView* dockDivider;
@property (nonatomic,strong) UIImageView* topDivider;
@property (nonatomic,strong) SGLeftDockButton *defualtBtn;
@end

@implementation SGLeftDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialItems];
    }
    return self;
}

-(void)initialItems{
    _dockItems =  @[[SGLeftDockItem initWithTitle:@"主页" withBgImage:@"tab_bar_app_icon.png" withController:@"SGMainViewController" withModalShow:NO],
                    [SGLeftDockItem initWithTitle:@"设置" withBgImage:@"tab_bar_pic_setting_icon.png" withController:@"SGSettingViewController" withModalShow:NO],
                    [SGLeftDockItem initWithTitle:@"扫描" withBgImage:@"tab_bar_pic_wall_icon.png" withController:@"SGScanViewController" withModalShow:NO]];
//    self.fisrtDockItem = _dockItems[0];
    for(int i = 0; i<[_dockItems count];i++){
        SGLeftDockButton *dockBtn = [[SGLeftDockButton alloc] init];
        dockBtn.frame = CGRectMake(0, i * kDockMenuItemHeight+200, self.frame.size.width, kDockMenuItemHeight);
        dockBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dockBtn.dockItem = [_dockItems objectAtIndex:i];
        [dockBtn addTarget:self action:@selector(dockButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:dockBtn];
        
        if (!i) {
            _defualtBtn = dockBtn;
        }
    }
    
    _dockDivider = [[UIImageView alloc] init];
    _dockDivider.image = [UIImage resizeImage:@"tabbar_separate_ugc_line_v.png"];
    [self addSubview:_dockDivider];
    
    _topDivider = [[UIImageView alloc] init];
    _topDivider.image = [UIImage resizeImage:@"tabbar_separate_line.png"];
    _topDivider.frame = CGRectMake(0, 200,self.frame.size.width, 2);
    _topDivider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_topDivider];
}

- (void)dockButtonClick:(SGLeftDockButton *)sender
{
//    if(![sender.dockItem.controller isEqualToString:@"SGSettingViewController"]) {
//        _currentDockBtn.selected = NO;
//        sender.selected = YES;
//        _currentDockBtn = sender;
//    }
    
    _currentDockBtn.selected = NO;
    sender.selected = YES;
    _currentDockBtn = sender;

    if (_dockItemClickBlock) {
        _dockItemClickBlock(sender.dockItem);
    }
}

- (void)setDefaultSelected{
    [self dockButtonClick:_defualtBtn];
}

- (void)unselectAll
{
    _currentDockBtn.selected = NO;
    _currentDockBtn = nil;
}

#pragma mark 旋转到某个方向
- (void)rotate:(UIInterfaceOrientation)orientation
{
    CGFloat width = 0;

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        width  = kDockComposeItemWidthL;
    } else {
        width  = kDockComposeItemWidthP;
    }
    _dockDivider.frame = CGRectMake(width, 0, 2, kDockHeight(orientation));
    self.frame = CGRectMake(0, 0, width,kDockHeight(orientation));
}

@end
