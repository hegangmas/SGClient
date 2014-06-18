//
//  SGCableViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGCableViewController.h"
#import "SGCablePageBussiness.h"

@interface SGCableViewController ()

@property (nonatomic,strong) UIWebView *webView;
@end

#define DrawLine(x1,y1,x2,y2) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:2\" onclick=\"alert('test')\"/>",x1,y1,x2,y2]

#define DrawText(x,y,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"16\">%@</text>",x,y,s]

#define DrawRect(x,y,w,h) [NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",x,y,w,h]


@implementation SGCableViewController

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
    self.title = [NSString stringWithFormat:@"%@连接图",self.cubicleData[@"name"]];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           MainScreenWidth(self.interfaceOrientation),
                                                           MainScreenHeight(self.interfaceOrientation))];
    [self.view addSubview:_webView];
    [self initial];
}



-(void)initial{

    NSDictionary* data = [[SGCablePageBussiness sharedSGCablePageBussiness] queryCablelistWithCubicleId:[self.cubicleData[@"id"] integerValue]];

    NSArray* type0 = [data valueForKey:@"type0"];
    NSArray* type1 = [data valueForKey:@"type1"];
    
    NSMutableArray* types = [NSMutableArray array];
    if (type0) {
        [types addObject:type0];
    }
    if (type1) {
        [types addObject:type1];
    }
    
    NSMutableString* svgStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"];
    
    [svgStr appendString:@"<svg width=\"1500\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"];
    
    //page left margin right margin
    float margin_x = 20, margin_y = 10;
    //cubicle width
    float cWidth   = 260;
    //cubicle height
    float cHeight  = 35;
    // line length     text y
    float linelen = 100, linetext_y_origin = 10;
    //margins between vertical cubicle
    float cuVeMargin = 10;
    float offsetY = 0;

    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    
    for(NSArray* type in types){
        //main cubicle
        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",
                              margin_x+cWidth+linelen,
                              margin_y + offsetY,
                              cWidth,
                              type.count*cHeight + (type.count-1)*cuVeMargin]];
        //main cubicle name
        [svgStr appendString:DrawText(margin_x+cWidth+linelen,
                                      margin_y + offsetY + (type.count*cHeight + (type.count-1)*cuVeMargin)/2,
                                      self.cubicleData[@"name"])];
        
        //loop connections
        int vPostion = 0;
        for(NSArray* connection in type){

            int hPosition = 0;
            for(int i = 0;i < connection.count;i++){
                id cubicle = connection[i];
                
                // handle first cubicle
                if (i==0) {
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                        hPosition++;
                    } else {
                        //draw rect
                        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x  + hPosition*(cWidth+linelen),
                                              margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                              cWidth,
                                              cHeight]];
                        
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                        
                    
                }else{
                    //draw line
                    [svgStr appendString:DrawLine(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY,
                                                  margin_x+hPosition*(cWidth+linelen),
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY)];
                    
                    [svgStr appendString:DrawText(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY - linetext_y_origin,
                                                  [cubicle valueForKey:@"cable_name"])];
                    
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                    }else{
                        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x + hPosition*(cWidth+linelen),
                                              margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                              cWidth,
                                              cHeight]];
                        
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                    
                } hPosition++;
            } vPostion++;
        }
        offsetY += type.count*cHeight + (type.count-1)*cuVeMargin + 2*margin_y;
    }
    [svgStr appendString:@"</svg>"];
    
    NSData *svgData = [svgStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString* dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                        objectAtIndex:0];
    dbPath = [dbPath stringByAppendingPathComponent:@"conn.svg"];
    [svgData writeToFile:dbPath atomically:YES];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.webView   loadData:svgData
                    MIMEType:@"image/svg+xml"
            textEncodingName:@"UTF-8"
                     baseURL:baseURL];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _webView.frame = CGRectMake(0,
                                                           0,
                                                           MainScreenWidth(toInterfaceOrientation),
                                                           MainScreenHeight(toInterfaceOrientation));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
