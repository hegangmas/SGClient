//
//  SGSectionFooterView.m
//  SGClient
//
//  Created by JY on 14-6-16.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGSectionFooterView.h"

@implementation SGSectionFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(205, 205, 205);
//        self.layer.masksToBounds = NO;
//        [self.layer setShadowOffset:CGSizeMake(2.5, 2.5)];
//        [self.layer setShadowOpacity:0.5];
//        [self.layer setShadowRadius:1.0];
//        [self.layer setShadowColor:[UIColor blackColor].CGColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
