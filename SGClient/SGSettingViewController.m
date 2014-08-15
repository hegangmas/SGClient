//
//  SGSettingViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGSettingViewController.h"
#import "SGPortPageBussiness.h"
#import "SGDBViewController.h"

@interface SGSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *listView;
@property (nonatomic,strong) NSArray* dataList;

@end

@implementation SGSettingViewController

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
    self.navigationItem.rightBarButtonItem = nil;
    [self.view addSubview:self.listView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listView.frame = CGRectMake(0,
                                     10,
                                     MainScreenWidth(self.interfaceOrientation),
                                     MainScreenHeight(self.interfaceOrientation));
}

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.dataList[indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id controller;
    
    switch (indexPath.section) {
            
        case 0:
            
            switch (indexPath.row) {
                case 0:
                    controller = [SGDBViewController new];
                    [controller setMain:self.main];
                    break;
                default:
                    break;
            }

            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    
    self.listView.frame = CGRectMake(0,
                                     10,
                                     MainScreenWidth(toInterfaceOrientation),
                                     MainScreenHeight(toInterfaceOrientation));
}

#pragma mark - getter

-(UITableView*)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                  10,
                                                                  MainScreenWidth(self.interfaceOrientation),
                                                                  MainScreenHeight(self.interfaceOrientation))
                                                 style:UITableViewStyleGrouped];
        [_listView setDelegate:self];
        [_listView setDataSource:self];
    }
    return _listView;
}

-(NSArray*)dataList{
    if (!_dataList) {
        _dataList = @[@[@"数据库配置",@"绘图配置"],@[@"其他配置"]];
    }
    return _dataList;
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
