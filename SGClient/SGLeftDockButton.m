//
//  SGLeftDockButton.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGLeftDockButton.h"
#import "UIImage+Fit.h"

@interface SGLeftDockButton()

@property(nonatomic,strong) UIImageView* divider;
@end

@implementation SGLeftDockButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.adjustsImageWhenHighlighted = NO;
        
        _divider = [[UIImageView alloc] init];
        _divider.image = [UIImage resizeImage:@"tabbar_separate_line.png"];
        _divider.frame = CGRectMake(0, kDockMenuItemHeight, 0, 2);
        _divider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_divider];

        [self setBackgroundImage:[UIImage resizeImage:@"tabbar_separate_selected_bg.png"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 覆盖高亮时所做的行为
- (void)setHighlighted:(BOOL)highlighted {}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _divider.hidden = selected;
}

- (void)setDockItem:(SGLeftDockItem *)dockItem
{
    _dockItem = dockItem;
    [self setImage:[UIImage imageNamed:dockItem.bgImage] forState:UIControlStateNormal];
    [self setTitle:dockItem.title forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 12, 40, 40);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
//    CGFloat width = contentRect.size.width - kDockMenuItemHeight;
    return CGRectMake(40, 0, 60, kDockMenuItemHeight);
}

@end
