//
//  SGFiberViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGFiberViewController.h"
#import "SGFiberPageBussiness.h"


@interface SGFiberViewController ()

@end

#define DrawSpanStart(x,y,v) [NSString stringWithFormat:@"<tspan x='%f' dy='%f' fill='white' text-anchor='start' font-style='italic'>%@</tspan>",x,y,v]
#define DrawSpan(x,v) [NSString stringWithFormat:@"<tspan x='%f' fill='white' text-anchor='start' font-style='italic'>%@</tspan>",x,v]


@implementation SGFiberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)drawSvgFileOnWebview{
    NSMutableString* svgStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"];
    
    [svgStr appendString:@"<svg width=\"##@@@##\" height=\"++@@@++\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"];
    
    float margin_x = 5;
    float margin_y = 50;
    float cWidth   = 240;
    float cHeight  = 60;
    float linelen  = 100;
    float linetext_y_origin = 10;
    
    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    //连接类型
    [svgStr appendString:DrawText(margin_x,
                                  margin_y  - 15,18,
                                  @"navy",
                                  @"italic",
                                  @"连接图")];
    
    if (self.isTX) {
        self.connection = @[self.connection,self.connection];
    }
    
    for(int i = 0; i < self.connection.count;i++){
        
        id cubicle = self.connection[i];
        
        if (i==0) {
            
            [svgStr appendString:DrawRect(margin_x  + i*(cWidth+linelen),
                                          margin_y,
                                          cWidth,
                                          cHeight)];
            
            [svgStr appendString:DrawText(margin_x  + i*(cWidth+linelen),
                                          margin_y + cHeight/2,14,
                                          @"white",
                                          @"italic",
                                          [cubicle valueForKey:@"cubicle_name"])];
        }else{
            //画线缆
            [svgStr appendString:DrawLine(margin_x+i*cWidth+(i-1)*linelen,
                                          margin_y + 0.5*cHeight,
                                          margin_x+i*(cWidth+linelen),
                                          margin_y + 0.5*cHeight,@"")];
            //线缆名称
            [svgStr appendString:DrawText(margin_x+i*cWidth+(i-1)*linelen,
                                          margin_y + 0.5*cHeight - linetext_y_origin,14,
                                          @"gray",
                                          @"italic",
                                          [cubicle valueForKey:@"cable_name"])];
            
            [svgStr appendString:DrawRect(margin_x + i*(cWidth+linelen),
                                          margin_y,
                                          cWidth,
                                          cHeight)];
            
            [svgStr appendString:DrawText(margin_x  + i*(cWidth+linelen),
                                          margin_y  + cHeight/2,14,
                                          @"white",
                                          @"italic",
                                          [cubicle valueForKey:@"cubicle_name"])];
            
        }
    }
    
    float tbOffset = 0;
    
    [svgStr appendString:@"<g id='rowGroup' transform='translate(0, 100)'>"];
    
    NSArray* fiberList = [[SGFiberPageBussiness sharedSGFiberPageBussiness] queryFiberInfoWithCableId:[_cableId integerValue]];
    
    [svgStr appendString:DrawRectW(margin_x, margin_y + tbOffset, 900.0, 60.0)];
    [svgStr appendString:[NSString stringWithFormat:@"<text x='%f' y='%f' font-size='17' text-anchor='start'>",margin_x, 40.0]];
    [svgStr appendString:DrawSpanStart(margin_x,45.0, @"数据类型")];
    [svgStr appendString:DrawSpan(margin_x + 120, @"设备")];
    [svgStr appendString:DrawSpan(margin_x + 250, @"端口")];
    [svgStr appendString:DrawSpan(margin_x + 330, @"TX")];
    [svgStr appendString:DrawSpan(margin_x + 400, @"ODF")];
    [svgStr appendString:DrawSpan(margin_x + 480, @"ODF")];
    [svgStr appendString:DrawSpan(margin_x + 530, @"TX")];
    [svgStr appendString:DrawSpan(margin_x + 600, @"端口")];
    [svgStr appendString:DrawSpan(margin_x + 690, @"设备")];
    [svgStr appendString:DrawSpan(margin_x + 810, @"数据类型")];
    [svgStr appendString:@"</text>"];
    
    for(id fiberItem in fiberList){
        tbOffset+=60;
        [svgStr appendString:DrawRectW(margin_x, margin_y + tbOffset, 900.0, 60.0)];
        [svgStr appendString:[NSString stringWithFormat:@"<text x='%f' y='%f' font-size='13' text-anchor='start'>",margin_x, 40.0]];
        [svgStr appendString:DrawSpanStart(margin_x,45.0 + tbOffset, [fiberItem valueForKey:@"type1"])];
        [svgStr appendString:DrawSpan(margin_x + 90, [fiberItem valueForKey:@"device1"])];
        [svgStr appendString:DrawSpan(margin_x + 240, [fiberItem valueForKey:@"port1"])];
        [svgStr appendString:DrawSpan(margin_x + 320, [fiberItem valueForKey:@"tx1"])];
        [svgStr appendString:DrawSpan(margin_x + 400, [fiberItem valueForKey:@"odf1"])];
        [svgStr appendString:DrawSpan(margin_x + 440, [fiberItem valueForKey:@"middle"])];
        [svgStr appendString:DrawSpan(margin_x + 480, [fiberItem valueForKey:@"odf2"])];
        [svgStr appendString:DrawSpan(margin_x + 520, [fiberItem valueForKey:@"tx2"])];
        [svgStr appendString:DrawSpan(margin_x + 600, [fiberItem valueForKey:@"port2"])];
        [svgStr appendString:DrawSpan(margin_x + 660, [fiberItem valueForKey:@"device2"])];
        [svgStr appendString:DrawSpan(margin_x + 810, [fiberItem valueForKey:@"type2"])];
        [svgStr appendString:@"</text>"];
    }

    [svgStr appendString:@"</g></svg>"];
    NSString* result = [NSString stringWithString:svgStr];
    
    result = [result stringByReplacingOccurrencesOfString:@"++@@@++" withString:[NSString stringWithFormat:@"%f",(fiberList.count+1)*60.0 + 150 + 30]];
    result = [result stringByReplacingOccurrencesOfString:@"##@@@##" withString:[NSString stringWithFormat:@"%f",950.0]];
    
        result = [result stringByReplacingOccurrencesOfString:@"(null)" withString:@"--"];
    
    NSData *svgData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSString* dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                        objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"fiber.svg"];
    [svgData writeToFile:dbPath atomically:YES];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.webView   loadData:svgData
                    MIMEType:@"image/svg+xml"
            textEncodingName:@"UTF-8"
                     baseURL:baseURL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
