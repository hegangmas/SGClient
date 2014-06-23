//
//  SGDrawViewController.h
//  SGClient
//
//  Created by yangboshan on 14-6-23.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGBaseViewController.h"

#define DrawLine(x1,y1,x2,y2,s) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:3\" onclick=\"self.location.href='@@@@%@'\"/>",x1,y1,x2,y2,s]

#define DrawText(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]

#define DrawRect(x,y,w,h) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\" style=\"fill:navy;stroke:black;stroke-width:1;opacity:0.5\"/>",x,y,w,h]

#define LineInfo(c,i,t) [NSString stringWithFormat:@"%@*%d*%d",c,i,t]

@interface SGDrawViewController : SGBaseViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end
