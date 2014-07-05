//
//  SGCableViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGCableViewController.h"
#import "SGCablePageBussiness.h"
#import "SGFiberViewController.h"

@interface SGCableViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) NSDictionary* data;
@property (nonatomic,assign) BOOL isScanMode;
@end

@implementation SGCableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - 扫描初始化入口
-(instancetype)initWithCubicleData:(NSDictionary*)cubicleData withCubicleId:(NSInteger)cubicleId withCableId:(NSInteger)cableId{

    if (self = [super init]) {
        _scannedCubicleId = cubicleId;
        _scannedCableId = cableId;
        _cubicleData = cubicleData;
  
        _isScanMode = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //如果是扫码动作 直接跳过进入下一级界面
    if (_isScanMode) {
        _isScanMode = NO;
        SGCablePageBussiness* bussiness = [SGCablePageBussiness sharedSGCablePageBussiness];
        id cable = [bussiness queryCalbleInfoWithCableId:_scannedCableId];
        
        SGFiberViewController *fiber = [SGFiberViewController new];
        [fiber setCableId:[NSString stringWithFormat:@"%d",_scannedCableId]];
        [fiber setCubicleId:[NSString stringWithFormat:@"%d",_scannedCubicleId]];
        [fiber setCableName:[cable valueForKey:@"cable_name"]];
        [fiber setCableType:[[cable valueForKey:@"cable_type"] integerValue]];
        
        for(NSArray* array in [self.data valueForKey:@"type1"]){
            
            id item = array[1];
            if ([[item valueForKey:@"cable_name"] isEqualToString:[cable valueForKey:@"cable_name"]]) {
                [fiber setConnection:array];
            }
        }
        [self.navigationController pushViewController:fiber animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@连接图",self.cubicleData[@"name"]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* _url = [request URL].description;
    
    if ([_url rangeOfString:@"@@@@"].location != NSNotFound) {
        
        NSString *retValue = [[_url componentsSeparatedByString:@"@@@@"] objectAtIndex:1];
        NSArray* retList = [retValue componentsSeparatedByString:@"*"];
        
        NSString* cableName = retList[0];
        NSString* cableId   = retList[1];
        NSInteger connId    = [retList[2] integerValue];
        NSString* type      = retList[3];
        
        SGFiberViewController *fiber = [SGFiberViewController new];
        
        [fiber setCableId:cableId];
        [fiber setCableName:cableName];
        [fiber setCableType:[type integerValue]];
        [fiber setCubicleId:self.cubicleData[@"id"]];
        id conn;
        
        switch ([type integerValue]) {
            case 0:
                conn = [[self.data valueForKey:@"type0"] objectAtIndex:connId];
                break;
            case 1:
                conn = [[self.data valueForKey:@"type1"] objectAtIndex:connId];
                break;
            case 2:
                conn = [[self.data valueForKey:@"type2"] objectAtIndex:connId];
                [fiber setIsTX:YES];
                break;
            default:
                break;
        }
        [fiber setConnection:conn];

        [self.navigationController pushViewController:fiber animated:YES];
    }
    return YES;
}

//生成SVG文件
-(void)drawSvgFileOnWebview{
    self.data = [[SGCablePageBussiness sharedSGCablePageBussiness] queryCablelistWithCubicleId:[self.cubicleData[@"id"] integerValue]];
    
    NSArray *types = @[@{@"光缆连接":[self.data valueForKey:@"type0"]},
                       @{@"尾缆连接":[self.data valueForKey:@"type1"]}];
 
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
    BOOL drawFromLeft = NO;

    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    
    for(NSDictionary* _type in types){
        
        //没有数据不做处理
        if (!_type.allValues) {
            continue;
        }
        NSArray* type = _type.allValues[0];
        
        //连接类型
        [svgStr appendString:DrawText(margin_x,
                                      margin_y + offsetY - 15,18,
                                      @"navy",
                                      @"italic",
                                      _type.allKeys[0])];
        
        float offsetTmp = 0;
        drawFromLeft = [self shouldMainCubicleDrawFromLeftWithList:type];
        if (!drawFromLeft) {
            offsetTmp += (cWidth+linelen);
        }
        
        //画主屏
        [svgStr appendString:DrawRect(margin_x+offsetTmp,
                                      margin_y + offsetY,
                                      cWidth,
                                      type.count*cHeight + (type.count-1)*cuVeMargin)];
        
        //主屏名称
        [svgStr appendString:DrawText(margin_x+offsetTmp + 10,
                                      margin_y + offsetY + (type.count*cHeight + (type.count-1)*cuVeMargin)/2,14,
                                      @"white",
                                      @"italic",
                                      self.cubicleData[@"name"])];
        
        int vPostion = 0;
        for(NSArray* connection in type){

            int hPosition = 0;
            for(int i = 0;i < connection.count;i++){
                id cubicle = connection[i];
                
                if (i==0) {
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                        if (!drawFromLeft) {
                            hPosition++;
                        }
                    } else {
                        
                        [svgStr appendString:DrawRect(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                                      cWidth,
                                                      cHeight)];
    
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,14,
                                                      @"white",
                                                      @"italic",
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                        
                }else{
                    //画线缆

                    [svgStr appendString:DrawLine(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY,
                                                  margin_x+hPosition*(cWidth+linelen),
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY,LineInfo([cubicle valueForKey:@"cable_name"],[cubicle valueForKey:@"cable_id"], vPostion,[types indexOfObject:_type]))];
                    
                    NSLog(@"VVVVV  %d",vPostion);
                    //线缆名称
                    [svgStr appendString:DrawText(margin_x+hPosition*cWidth+(hPosition-1)*linelen,
                                                  margin_y + vPostion*cHeight+0.5*cHeight+vPostion*cuVeMargin+offsetY - linetext_y_origin,14,
                                                  @"gray",
                                                  @"italic",
                                                  [cubicle valueForKey:@"cable_name"])];
                    
                    if ([[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]){
                    }else{
                        
                        [svgStr appendString:DrawRect(margin_x + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY,
                                                      cWidth,
                                                      cHeight)];
                        
                        
                        [svgStr appendString:DrawText(margin_x  + hPosition*(cWidth+linelen),
                                                      margin_y + vPostion*(cuVeMargin+cHeight)+offsetY + cHeight/2,14,
                                                      @"white",
                                                      @"italic",
                                                      [cubicle valueForKey:@"cubicle_name"])];
                    }
                }
                hPosition++;
                if(hPosition>hPostionMax){
                    hPostionMax = hPosition;
                }
            }
            vPostion++;
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
    types = [self.data valueForKey:@"type2"];
    
    if (types) {
        [svgStr appendString:DrawText(margin_x,
                                      margin_y + offsetY - 15,18,
                                      @"navy",
                                      @"italic",
                                      @"跳纤连接")];
        //画两个屏
        for(int i = 0; i<2; i++){
            
            [svgStr appendString:DrawRect(i*(linelen + cWidth) + margin_x,
                                          margin_y + offsetY,
                                          cWidth,
                                          types.count*cHeight)];
            
            [svgStr appendString:DrawText(i*(linelen + cWidth) + margin_x + 10,
                                          margin_y + offsetY + (types.count*cHeight + (types.count-1)*cuVeMargin)*0.5,14,
                                          @"white",
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
                                          margin_y + offsetY + (0.5+i)*cHeight,LineInfo([cubicle valueForKey:@"cable_name"],[cubicle valueForKey:@"cable_id"], i,2))];
            
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
    dbPath = [dbPath stringByAppendingPathComponent:@"cable.svg"];
    [svgData writeToFile:dbPath atomically:YES];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSURL *baseURL = [[NSURL alloc] initFileURLWithPath:resourcePath isDirectory:YES];
    [self.webView   loadData:svgData
                    MIMEType:@"image/svg+xml"
            textEncodingName:@"UTF-8"
                     baseURL:baseURL];
}

//主屏是否从最左边画起
-(BOOL)shouldMainCubicleDrawFromLeftWithList:(NSArray*)list{
    
    for(NSArray* connection in list){
        id cubicle = connection[0];
        if (![[cubicle valueForKey:@"cubicle_id"] isEqualToString:self.cubicleData[@"id"]]) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
