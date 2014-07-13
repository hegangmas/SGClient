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

@property (nonatomic,strong) NSArray *fiberList;
@property (nonatomic,strong) NSArray *offsetList;
@property (nonatomic,strong) NSArray *propertyList;
@property (nonatomic,strong) NSArray *headList;

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
    self.title = [NSString stringWithFormat:@"%@线缆信息",_cableName];
    [self.webView setScalesPageToFit:YES];
}


float margin_x = 5;
float margin_y = 50;
float cWidth   = 240;
float cHeight  = 60;
float linelen  = 100;
float linetext_y_origin = 10;

float linelen2 = 40;
float rOffset = 10;


-(void)drawSvgFileOnWebview{
    
    NSMutableString* svgStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" standalone=\"no\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"];
    
    [svgStr appendString:@"<svg width=\"##@@@##\" height=\"++@@@++\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">"];
    
    
    
    [svgStr appendString:@"<defs><style type=\"text/css\"><![CDATA[ rect {fill:white;stroke:black;stroke-width:2;opacity:0.1;}]]></style></defs>"];
    
    //连接类型
    [svgStr appendString:DrawText(margin_x,
                                  margin_y  - 15,18,
                                  @"navy",
                                  @"italic",
                                  @"连接路径")];
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
    
    //连接类型
    [svgStr appendString:DrawText(margin_x,
                                  margin_y + cHeight + 55,18,
                                  @"navy",
                                  @"italic",
                                  @"纤芯信息")];
    
    _fiberList = [[SGFiberPageBussiness sharedSGFiberPageBussiness] queryFiberInfoWithCableId:[_cableId integerValue] withCubicleId:[_cubicleId integerValue]];
    
    [svgStr appendString:[self retriveFiberSvg]];
    
    [svgStr appendString:[NSString stringWithFormat:@"<line x1=\"%f\" y1=\"%f\" x2=\"%f\" y2=\"%f\" style=\"stroke-dasharray: 9, 5;stroke: gray; stroke-width: 2;\"/>",margin_x,
                          margin_y + cHeight + 30,
                          [self getTotalLengthForArray:_offsetList withBegin:0 withEnd:_offsetList.count-1] + 2*(rOffset + linelen2) + rOffset,
                          margin_y + cHeight + 30]];
    
    [svgStr appendString:@"</svg>"];
    
    NSString* result = [NSString stringWithString:svgStr];
    
    float _height = (200 + (_fiberList.count+1)*60.0);
    _height = (_height < MainScreenHeight(self.interfaceOrientation)) ? MainScreenHeight(self.interfaceOrientation) : _height ;
    float _width = [self getTotalLengthForArray:_offsetList withBegin:0 withEnd:_offsetList.count-1] + 2*(rOffset + linelen2) + rOffset;
    _width = (_width < MainScreenWidth(self.interfaceOrientation)) ? MainScreenWidth(self.interfaceOrientation) : _width;
    
    
    result = [result stringByReplacingOccurrencesOfString:@"++@@@++" withString:[NSString stringWithFormat:@"%f",_height + 200]];
    result = [result stringByReplacingOccurrencesOfString:@"##@@@##" withString:[NSString stringWithFormat:@"%f",_width]];
    
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

-(NSString*)retriveFiberSvg{


    switch (_cableType) {
            
            //光缆类型
        case 0:
            _offsetList = @[[NSNumber numberWithFloat:[self getMaxLengthForField:@"device1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"port1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"tx1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"odf1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"middle"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"odf2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"tx2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"port2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"device2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"type2"]]];
            
            _propertyList = @[@"device1",@"port1",@"tx1",@"odf1",@"middle",@"odf2",@"tx2",@"port2",@"device2",@"type2"];
            
            _headList = @[@"设备",@"端口",@"TX",@"ODF",@"",@"ODF",@"TX",@"端口",@"设备",@"数据类型"];
            
            break;
            
            //尾缆 跳纤 不显示TX ODF
        case 1:
        case 2:
            _offsetList = @[[NSNumber numberWithFloat:[self getMaxLengthForField:@"device1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"port1"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"middle"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"port2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"device2"]],
                            [NSNumber numberWithFloat:[self getMaxLengthForField:@"type2"]]];
            
            _propertyList = @[@"device1",@"port1",@"middle",@"port2",@"device2",@"type2"];
            
            _headList = @[@"设备",@"端口",@"",@"端口",@"设备",@"数据类型"];
            
            break;
        default:
            break;
    }
    
    NSMutableString* svgStr = [NSMutableString new];
    [svgStr appendString:@"<g id='rowGroup' transform='translate(0, 100)'>"];
   
    
    float vOffset = 30;
    float hOffset = margin_x;
    
    NSInteger beginIndex = 0;
    NSInteger endIndex = 0;
    
    for (int s = 0; s < 3; s++) {
        
        switch (s) {
            case 0:
                
                switch (_cableType) {
                    case 0:
                        beginIndex = 0;
                        endIndex = 3;
                        break;
                    case 1:
                    case 2:
                        beginIndex = 0;
                        endIndex = 1;
                        break;
                }

                break;
            case 1:
                
                hOffset += [self getTotalLengthForArray:_offsetList
                                              withBegin:beginIndex
                                                withEnd:endIndex];
                hOffset += linelen2;
                
                switch (_cableType) {
                    case 0:
                        beginIndex = 4;
                        endIndex = 4;
                        break;
                    case 1:
                    case 2:
                        beginIndex = 2;
                        endIndex = 2;
                        break;
                }
                
                break;
            case 2:
                
                hOffset += [self getTotalLengthForArray:_offsetList
                                              withBegin:beginIndex
                                                withEnd:endIndex];
                hOffset += linelen2;
                
                switch (_cableType) {
                    case 0:
                        beginIndex = 5;
                        endIndex = 9;
                        break;
                    case 1:
                    case 2:
                        beginIndex = 3;
                        endIndex = 5;
                        break;
                }

                break;
            default:
                break;
        }
        
        [svgStr appendString:DrawRectW(hOffset,
                                       margin_y + 30,
                                       [self getTotalLengthForArray:_offsetList withBegin:beginIndex withEnd:endIndex] + rOffset,
                                       60.0)];
        
        [svgStr appendString:[NSString stringWithFormat:@"<text x='%f' y='%f' font-size='17' text-anchor='start'>",hOffset, 40.0]];
        for(NSInteger j = beginIndex; j <= endIndex; j++){
            
            if (j == beginIndex) {
                
                [svgStr appendString:DrawSpanStart(hOffset + rOffset,
                                                   75.0,
                                                   _headList[j])];
            }else{
                
                [svgStr appendString:DrawSpan(hOffset + [self getTotalLengthForArray:_offsetList
                                                                           withBegin:beginIndex
                                                                             withEnd:j-1] + rOffset,
                                              _headList[j])];
            }
        }
        
        [svgStr appendString:@"</text>"];
        
        vOffset = 0;
        for (int i = 0; i < _fiberList.count; i++) {
            vOffset += 60;
            
            [svgStr appendString:DrawRectW(hOffset,
                                           margin_y + 30 + vOffset,
                                           [self getTotalLengthForArray:_offsetList withBegin:beginIndex withEnd:endIndex] + rOffset,
                                           60.0)];
            
            [svgStr appendString:[NSString stringWithFormat:@"<text x='%f' y='%f' font-size='17' text-anchor='start'>",hOffset, 40.0]];
            
            for(NSInteger j = beginIndex; j <= endIndex; j++){
                if (j == beginIndex) {
                    
                    [svgStr appendString:DrawSpanStart(hOffset + rOffset,
                                                       margin_y + 30 + vOffset,
                                                       [_fiberList[i] valueForKey:_propertyList[j]])];
                }else{
                    
                    [svgStr appendString:DrawSpan(hOffset + [self getTotalLengthForArray:_offsetList
                                                                               withBegin:beginIndex
                                                                                 withEnd:j-1] + rOffset,
                                                  [_fiberList[i] valueForKey:_propertyList[j]])];
                }
            }
            [svgStr appendString:@"</text>"];
            
            if (s) {
                [svgStr appendString:DrawLineT(hOffset - linelen2 + rOffset,
                                              margin_y + 30 + vOffset + 30,
                                              hOffset,
                                              margin_y + 30 + vOffset + 30,@"")];
            }
        }
    }
    
    
    [svgStr appendString:@"</g>"];
    
    return svgStr;
}

-(float)getMaxLengthForField:(NSString*)field{
    
    float maxLength = 0;
    
    for(id fiberItem in _fiberList){
        
        float len = [[fiberItem valueForKey:field] sizeWithFont:[UIFont systemFontOfSize:15.0]].width;
        
        if (len > maxLength) {
            maxLength = len;
        }
    }
    return maxLength + 50;
}

-(float)getTotalLengthForArray:(NSArray*)array withBegin:(NSInteger)begin withEnd:(NSInteger)end{
    
    float total = 0;
    
    for(NSInteger i = begin ;i<= end;i++){
        total += [array[i] floatValue];
    }
    return total;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
