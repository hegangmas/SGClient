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

#define DrawLine(x1,y1,x2,y2) [NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\" stroke:rgb(99,99,99);stroke-width:2\"/>",x1,y1,x2,y2]


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
    
    NSString* strXml = [[SGCablePageBussiness sharedSGCablePageBussiness] queryCablelistWithCubicleId:[self.cubicleData[@"id"] integerValue]];
    NSError* error;
    NSDictionary* data = [XMLReader dictionaryForXMLString:strXml error:&error];
    
    if (error) {
        return;
    }
    NSArray* type0 = [[[data objectForKey:@"root" ] objectForKey:@"type0"] objectForKey:@"connection"];
    NSArray* type1 = [[[data objectForKey:@"root" ] objectForKey:@"type1"] objectForKey:@"connection"];
    NSMutableString* svgStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"];
    
    [svgStr appendString:@"<svg width=\"1500\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"];
    
    //page left margin right margin
    float margin_x = 20, margin_y = 10;
    //cubicle width
    float cWidth   = 180;
    //cubicle height
    float cHeight  = 35;
    // line length     text y
    float linelen = 100, linetext_y_origin = 15;
    //margins between vertical cubicle
    float cuVeMargin = 10;
    
    float offsetY = 0;

    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    //main cubicle
    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",
                          margin_x+cWidth+linelen,
                          margin_y,
                          cWidth,
                          type0.count*cHeight + (type0.count-1)*cuVeMargin]];
    //loop connections
    int vPostion = 0;
    for(NSDictionary* connection in type0){
        
        NSArray* cubicles;
        if ([connection isKindOfClass:[NSString class]]) {
            cubicles = [NSArray arrayWithObjects:type0, nil];
        }else{
            cubicles = connection[@"cubicle"];
        }

        int hPosition = 0;
        for(int i = 0;i < cubicles.count;i++){
            NSDictionary* cubicle = cubicles[i];
            
            //first cubicle
            if (i==0) {
                if ([[[cubicle valueForKey:@"cubicle_id"] valueForKey:@"text"] isEqualToString:self.cubicleData[@"id"]]){
                    hPosition+=2;
                } else {
                    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x  + hPosition*(cWidth+linelen),
                                          margin_y + vPostion*(cuVeMargin+cHeight),
                                          cWidth,
                                          cHeight]];
                    hPosition++;
                }
            }else{
                
                [svgStr appendString:DrawLine(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                              margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin,
                                              margin_x+hPosition*(cWidth+linelen),
                                              margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin)];
                
                if ([[[cubicle valueForKey:@"cubicle_id"] valueForKey:@"text"] isEqualToString:self.cubicleData[@"id"]]){
                }else{
                    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x + hPosition*(cWidth+linelen),
                                          margin_y + vPostion*(cuVeMargin+cHeight),
                                          cWidth,
                                          cHeight]];
                }
                hPosition++;
            }
        }
        vPostion++;
    }
    
    vPostion = 0;
    offsetY = type0.count*cHeight + (type0.count-1)*cuVeMargin + 2*margin_y;
    
    //main cubicle
    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",
                          margin_x+cWidth+linelen,
                          margin_y+offsetY,
                          cWidth,
                          type1.count*cHeight + (type1.count-1)*cuVeMargin]];
    
    for(NSDictionary* connection in type1){
        
        NSArray* cubicles;
        if ([connection isKindOfClass:[NSString class]]) {
            cubicles = [NSArray arrayWithObjects:type1, nil];
        }else{
            cubicles = connection[@"cubicle"];
        }
        
        int hPosition = 0;
        for(int i = 0;i < cubicles.count;i++){
            NSDictionary* cubicle = cubicles[i];
            
            //first cubicle
            if (i==0) {
                if ([[[cubicle valueForKey:@"cubicle_id"] valueForKey:@"text"] isEqualToString:self.cubicleData[@"id"]]){
                    hPosition+=2;
                } else {
                    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x  + hPosition*(cWidth+linelen),
                                          margin_y + vPostion*(cuVeMargin+cHeight) + offsetY,
                                          cWidth,
                                          cHeight]];
                    hPosition++;
                }
            }else{
                
                [svgStr appendString:DrawLine(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                              margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+ offsetY,
                                              margin_x+hPosition*(cWidth+linelen),
                                              margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+ offsetY)];
                
                if ([[[cubicle valueForKey:@"cubicle_id"] valueForKey:@"text"] isEqualToString:self.cubicleData[@"id"]]){
                }else{
                    [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x + hPosition*(cWidth+linelen),
                                          margin_y + vPostion*(cuVeMargin+cHeight)+ offsetY,
                                          cWidth,
                                          cHeight]];
                }
                hPosition++;
            }
        }
        vPostion++;
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
