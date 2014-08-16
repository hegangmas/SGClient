//
//  SGSelectViewController.m
//  SGClient
//
//  Created by yangboshan on 14-8-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGSelectViewController.h"

@interface SGSelectViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView* listView;
@end

@implementation SGSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma getter

-(UITableView*)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_listView setDelegate:self];
        [_listView setDataSource:self];
    }
    return _listView;
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