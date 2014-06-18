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

#define DrawText(x,y,z,c,f,s) [NSString stringWithFormat:@"<text x=\"%f\" y=\"%f\" font-size=\"%d\" fill =\"%@\" font-style=\"%@\">%@</text>",x,y,z,c,f,s]

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
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.userInteractionEnabled = YES;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [self drawConnections];
}

//生成SVG文件
-(void)drawConnections{
    NSDictionary* data = [[SGCablePageBussiness sharedSGCablePageBussiness] queryCablelistWithCubicleId:[self.cubicleData[@"id"] integerValue]];
    
    NSArray *types = @[@{@"光缆连接":[data valueForKey:@"type0"]},
                       @{@"尾缆连接":[data valueForKey:@"type1"]}];
 
    NSMutableString* svgStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"];
    
    [svgStr appendString:@"<svg width=\"##@@@##\" height=\"++@@@++\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"];
    
    float margin_x = 20;
    float margin_y = 50;
    float cWidth   = 240;
    float cHeight  = 35;
    float linelen  = 100;
    float linetext_y_origin = 10;
    float cuVeMargin = 5;
    float offsetY = 0;
    int hPostionMax = 0;

    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    
    for(NSDictionary* _type in types){
        
        //没有数据不做处理
        if (!_type.allValues) {
            continue;
        }
        NSArray* type = _type.allValues[0];
        
        //画主屏
        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",
                              margin_x+cWidth+linelen,
                              margin_y + offsetY,
                              cWidth,
                              type.count*cHeight + (type.count-1)*cuVeMargin]];
        //主屏名称
        [svgStr appendString:DrawText(margin_x+cWidth+linelen + 10,
                                      margin_y + offsetY + (type.count*cHeight + (type.count-1)*cuVeMargin)/2,14,
                                      @"black",
                                      @"italic",
                                      self.cubicleData[@"name"])];
        
        //连接类型
        [svgStr appendString:DrawText(margin_x,
                                      margin_y + offsetY - 15,18,
                                      @"navy",
                                      @"italic",
                                      _type.allKeys[0])];
        
        int vPostion = 0;
        for(NSArray* connection in type){

            int hPosition = 0;
            for(int i = 0;i < connection.count;i++){
                id cubicle = connection[i];
                
                if (i==0) {
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                        hPosition++;
                    } else {
                        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x  + hPosition*(cWidth+linelen),
                                              margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                              cWidth,
                                              cHeight]];
                        
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,14,
                                                      @"black",
                                                      @"italic",
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                        
                    
                }else{
                    //画线缆
                    [svgStr appendString:DrawLine(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY,
                                                  margin_x+hPosition*(cWidth+linelen),
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY)];
                    
                    //线缆名称
                    [svgStr appendString:DrawText(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY - linetext_y_origin,14,
                                                  @"gray",
                                                  @"italic",
                                                  [cubicle valueForKey:@"cable_name"])];
                    
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                    }else{
                        [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",margin_x + hPosition*(cWidth+linelen),
                                              margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                              cWidth,
                                              cHeight]];
                        
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,14,
                                                      @"black",
                                                      @"italic",
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                    
                } hPosition++; if(hPosition>hPostionMax){hPostionMax = hPosition;}
            } vPostion++;
        }
        
        //累加高度
        if (type.count) {
            offsetY += type.count*cHeight + (type.count-1)*cuVeMargin + margin_y;
        }
        
        
        [svgStr appendString:[NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\"stroke-dasharray: 9, 5;stroke: gray; stroke-width: 2;\"/>",margin_x,
                              offsetY + margin_y,
                              margin_x + 1000,
                             offsetY + margin_y]];
        offsetY+= margin_y;
    }
    
    
    //跳纤连接
    types = [data valueForKey:@"type2"];
    
    if (types) {
        [svgStr appendString:DrawText(margin_x,
                                      margin_y + offsetY - 15,18,
                                      @"navy",
                                      @"italic",
                                      @"跳纤连接")];
        //画两个屏
        for(int i = 0; i<2; i++){
            [svgStr appendString:[NSString stringWithFormat:@"<rect x=\"%f\" y=\"%f\" width=\"%f\" height=\"%f\"/>",
                                  i*(linelen + cWidth) + margin_x,
                                  margin_y + offsetY,
                                  cWidth,
                                  types.count*cHeight]];
            
            [svgStr appendString:DrawText(i*(linelen + cWidth) + margin_x + 10,
                                          margin_y + offsetY + (types.count*cHeight + (types.count-1)*cuVeMargin)*0.5,14,
                                          @"black",
                                          @"italic",
                                          self.cubicleData[@"name"])];
        }
        //画线缆
        for(int i = 0; i < types.count; i++){
            id cubicle = types[i];
            //draw line
            [svgStr appendString:DrawLine(margin_x + cWidth,
                                          margin_y + offsetY + (0.5+i)*cHeight,
                                          linelen + margin_x + cWidth,
                                          margin_y + offsetY + (0.5+i)*cHeight)];
            
            [svgStr appendString:DrawText(margin_x + cWidth + 20,
                                          margin_y + offsetY + (0.5+i)*cHeight - linetext_y_origin,14,
                                          @"gray",
                                          @"italic",
                                          [cubicle valueForKey:@"cable_name"])];
   
        }
        if (types.count) {
            offsetY += (types.count*cHeight + 2*margin_y) ;
        }
    }
    [svgStr appendString:@"</svg>"];
    NSString* result = [NSString stringWithString:svgStr];
    
    //计算出总高总宽并填回
    result = [result stringByReplacingOccurrencesOfString:@"++@@@++" withString:[NSString stringWithFormat:@"%f",offsetY]];
    result = [result stringByReplacingOccurrencesOfString:@"##@@@##" withString:[NSString stringWithFormat:@"%f",2*margin_x+hPostionMax*cWidth+(hPostionMax-1)*linelen]];
    
    NSData *svgData = [result dataUsingEncoding:NSUTF8StringEncoding];
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
