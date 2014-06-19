//
//  SGHomeViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGHomeViewController.h"
#import "SGLeftDockItem.h"
#import "SGLeftDock.h"
#import "SGBaseViewController.h"

@interface SGHomeViewController ()

@property (nonatomic,strong) SGLeftDock* leftDock;
@property (nonatomic,strong) NSMutableDictionary *children;
@property (nonatomic,strong) UINavigationController *currentChild;

@end

@implementation SGHomeViewController

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
    
    SGHomeViewController * __weak weakSelf = self;
    _children = [NSMutableDictionary dictionary];
    
    _leftDock = [[SGLeftDock alloc] init];
    _leftDock.dockItemClickBlock = ^(SGLeftDockItem* dockItem){
        [weakSelf setSelectControllerWithItem:dockItem];
    };
    [_leftDock rotate:self.interfaceOrientation];
    
    [self.view addSubview:_leftDock];
    [self.view setBackgroundColor:RGB(46, 46, 46)];
    [_leftDock setDefaultSelected];
}

#pragma mark 切换控制器
- (void)setSelectControllerWithItem:(SGLeftDockItem*)dockItem
{
    UINavigationController *nav = _children[dockItem.controller];
    
    if (nav == nil) {
        
        Class class = NSClassFromString(dockItem.controller);
        SGBaseViewController *controller = [class new];
        [controller setTitle:dockItem.title];
        nav = [[UINavigationController alloc] initWithRootViewController:controller];
        nav.view.autoresizingMask = UIViewAutoresizingNone;

        if (dockItem.isModalShow) {
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:nav animated:YES completion:nil];
            nav.view.superview.frame = CGRectMake(0, 0, 600, 600);
            nav.view.superview.center = self.view.center;
            return;
        }
        [nav.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragNavView:)]];
        [self addChildViewController:nav];
        [_children setObject:nav forKey:dockItem.controller];
    }
    
    if (_currentChild == nav)
        return;
    [_currentChild.view removeFromSuperview];
    
    CGFloat width = kScreenWidth(self.interfaceOrientation) - _leftDock.frame.size.width;
    nav.view.frame = CGRectMake(_leftDock.frame.size.width, 0, width, _leftDock.frame.size.height);
    [self.view addSubview:nav.view];
    _currentChild = nav;
}

#pragma mark 即将旋转屏幕的时候自动调用
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{

        [_leftDock rotate:toInterfaceOrientation];
        
        CGFloat width = kScreenWidth(toInterfaceOrientation) - _leftDock.frame.size.width;
        _currentChild.view.frame = CGRectMake(_leftDock.frame.size.width, 0, width, _leftDock.frame.size.height);
    }];
}

- (void)dragNavView:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.2 animations:^{
            pan.view.transform = CGAffineTransformIdentity;
        }];
        
    } else {
        CGFloat tx = [pan translationInView:pan.view].x;
        pan.view.transform = CGAffineTransformMakeTranslation(tx * 0.5, 0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
