//
//  SGDBViewController.m
//  SGClient
//
//  Created by yangboshan on 14-7-24.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGDBViewController.h"
#import "SGAPPConfig.h"
#import "SGUtility.h"

@interface SGDBViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* listView;
@property (nonatomic,strong) NSMutableArray* dataList;
@property (nonatomic,strong) UIView* headerView;
@property (nonatomic,strong) NSString* currentDBString;
@end

@implementation SGDBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    }
    return self;
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
        //        _listView.tableHeaderView = self.headerView;
    }
    return _listView;
}

-(NSArray*)dataList{
    
    if (!_dataList) {
        
        _dataList = [NSMutableArray array];
        NSFileManager *fileManager =  [NSFileManager defaultManager];
        NSArray* files = [fileManager subpathsAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                     objectAtIndex:0]];
        
        for(NSString* file in files){
            if ([[file pathExtension] isEqualToString:@"sqlite"]) {
                NSArray* a = [file componentsSeparatedByString:@"."];
                [_dataList addObject:a[0]];
            }
        }
    }
    return _dataList;
}

-(UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth(self.interfaceOrientation), 30)];
        UILabel* tip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
        [tip setText:@"请选择一个数据库进行加载"];
        tip.font = [UIFont fontWithName:@"Helvetica" size:16.0];
        [_headerView addSubview:tip];
    }
    return _headerView;
}

-(NSString*)currentDB{
    NSArray* a = [[SGUtility getCurrentDB] componentsSeparatedByString:@"."];
    return a[0];
}
#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return self.headerView;
    }
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"identifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if ([self.dataList[indexPath.row] isEqualToString:[self currentDB]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    for(int i = 0; i<self.dataList.count;i++){
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.currentDBString = cell.textLabel.text;
}

-(void)save{
    
    [self.main popToRootViewControllerAnimated:NO];
    NSLog(@"%@",self.currentDBString);
    [SGUtility setCurrentDB:[NSString stringWithFormat:@"%@.sqlite",self.currentDBString]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    _currentDBString = [self currentDB];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listView.frame = CGRectMake(0,
                                     10,
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
