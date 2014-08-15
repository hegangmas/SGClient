//
//  SGDrawViewController.m
//  SGClient
//
//  Created by yangboshan on 14-6-23.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGDrawViewController.h"

@interface SGDrawViewController ()

@end

@implementation SGDrawViewController

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
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           MainScreenWidth(self.interfaceOrientation),
                                                           MainScreenHeight(self.interfaceOrientation))];
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.userInteractionEnabled = YES;
    [_webView setDelegate:self];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [self drawSvgFileOnWebview];
    
}

-(void)drawSvgFileOnWebview{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _webView.frame = CGRectMake(0,
                                0,
                                MainScreenWidth(toInterfaceOrientation),
                                MainScreenHeight(toInterfaceOrientation));
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _webView.frame = CGRectMake(0,
                                0,
                                MainScreenWidth(self.interfaceOrientation),
                                MainScreenHeight(self.interfaceOrientation));
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
