//
//  NUApp-Config.h
//  NUWebOffice
//
//  Created by JY on 14-4-18.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#define DrawLine(x1,y1,x2,y2,s) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:3\" onclick=\"self.location.href='@@@@%@'\"/>",x1,y1,x2,y2,s]

#define DrawLineT(x1,y1,x2,y2,s) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:1\" onclick=\"self.location.href='@@@@%@'\"/>",x1,y1,x2,y2,s]

#define DrawLineArrow(x1,y1,x2,y2,s) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:2\" marker-end=\"url(#triangle)\" onclick=\"self.location.href='@@@@%@'\"/>",x1,y1,x2,y2,s]

#define DrawCircle(x,y,r) [NSString stringWithFormat:@"<circle cx=\"%f\" cy=\"%f\" r=\"%f\" style=\"stroke:black; fill:black\"/>",x,y,r]


#define DrawText(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]

#define DrawTextL(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" style=\"text-anchor: left;\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]

#define DrawTextR(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" style=\"text-anchor: end\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]

#define DrawTextM(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" style=\"text-anchor: middle\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]





#define DrawTextClicked(x,y,z,c,f,s,i) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" font-style=\"%@\" onclick=\"self.location.href='@@@@%@'\">%@</text>",x,y,z,c,f,i,s]


#define DrawRectH(x,y,w,h) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:navy;stroke:white;stroke-width:1;opacity:0.5\"/>",x,y,w,h]

#define DrawRect(x,y,w,h) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:#5A5AAD;stroke:black;stroke-width:1;opacity:0.5\"/>",x,y,w,h]

#define DrawRectD(x,y,w,h) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:#B8B8DC;stroke:black;stroke-width:1;opacity:0.5\"/>",x,y,w,h]




#define DrawRectW(x,y,w,h,p) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:#5A5AAD;stroke:white;stroke-width:1;opacity:0.5\" onclick=\"self.location.href='@@@@%@'\"/>",x,y,w,h,p]

#define DrawRectWD(x,y,w,h,p) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:#B8B8DC;stroke:white;stroke-width:1;opacity:0.5\" onclick=\"self.location.href='@@@@%@'\"/>",x,y,w,h,p]
 



#define LineInfo(n,c,i,t) [NSString stringWithFormat:@"%@*%@*%d*%d",n,c,i,t]

//#define kDockComposeItemWidthL 130

#define kDockComposeItemWidthL 90


#define kDockComposeItemHeightL kDockComposeItemWidthL

//#define kDockComposeItemWidthP 65
#define kDockComposeItemWidthP 40

//#define kDockComposeItemHeightP kDockComposeItemWidthP
//
//#define kDockMenuItemHeight kDockComposeItemHeightP

#define kDockComposeItemHeightP 65

#define kDockMenuItemHeight 65


#define kGlobalBg kGetColor(46, 46, 46)
#define kDockHeight(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height) - 10)
#define kScreenWidth(orientation) ((UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width) - 5)


#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

#define RgbHex2UIColor(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RgbHex2UIColorWithAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define NSNumWithInt(i)      ([NSNumber numberWithInt:(i)])
#define NSNumWithFloat(f)    ([NSNumber numberWithFloat:(f)])
#define NSNumWithBool(b)     ([NSNumber numberWithBool:(b)])

#define UA_runOnMainThread if (![NSThread isMainThread]) { dispatch_sync(dispatch_get_main_queue(), ^{ [self performSelector:_cmd]; }); return; };
#define ApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#define SharedApplication [UIApplication sharedApplication]
#define MainBundle [NSBundle mainBundle]
#define MainScreen [UIScreen mainScreen]
#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x) [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar self.navigationController.navigationBar
#define TabBar self.tabBarController.tabBar
#define NavBarHeight self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault 44
#define TouchHeightSmall 32
#define ViewWidth(v) v.frame.size.width
#define ViewHeight(v) v.frame.size.height
#define ViewX(v) v.frame.origin.x
#define ViewY(v) v.frame.origin.y
#define SelfViewWidth self.view.bounds.size.width
#define SelfViewHeight self.view.bounds.size.height
#define RectX(f) f.origin.x
#define RectY(f) f.origin.y
#define RectWidth(f) f.size.width
#define RectHeight(f) f.size.height
#define RectSetWidth(f, w) CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h) CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x) CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y) CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h) CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y) CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define DATE_COMPONENTS NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p) [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];