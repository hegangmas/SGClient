//
//  SGSectionHeaderView.m
//  SGClient
//
//  Created by JY on 14-6-16.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGSectionHeaderView.h"

@implementation SGSectionHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = RGB(220, 220, 220);
        self.backgroundColor = [UIColor whiteColor];
        _roomLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_roomLabel setFont:[UIFont italicSystemFontOfSize:22.0]];
        _roomLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _roomLabel.backgroundColor = [UIColor clearColor];
        _roomLabel.textColor = RGB(107, 103, 185);
        _roomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_roomLabel];
        
        self.layer.masksToBounds = NO;
        [self.layer setShadowOffset:CGSizeMake(-1.5, -1.5)];
        [self.layer setShadowOpacity:0.3];
        [self.layer setShadowRadius:1.0];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        
    }
    return self;
}

//- (BOOL)isAccessibilityElement {
//    return YES;
//}
//
//- (UIAccessibilityTraits)accessibilityTraits {
//    return UIAccessibilityTraitHeader;
//}
//
//- (NSString *)accessibilityLabel {
//    return _roomLabel.text;
//}

@end
