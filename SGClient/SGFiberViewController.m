//
//  SGFiberViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGFiberViewController.h"

@interface SGFiberViewController ()

@end

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
    
    float margin_x = 20;
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
    
    [svgStr appendString:@"</svg>"];
    NSString* result = [NSString stringWithString:svgStr];
    
    //计算出总高总宽并填回
    result = [result stringByReplacingOccurrencesOfString:@"++@@@++" withString:[NSString stringWithFormat:@"%f",cHeight + margin_y]];
    result = [result stringByReplacingOccurrencesOfString:@"##@@@##" withString:[NSString stringWithFormat:@"%f",2*margin_x+self.connection.count*cWidth+(self.connection.count-1)*linelen]];
    
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
