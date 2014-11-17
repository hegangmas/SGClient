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
@property (nonatomic,strong) UIView* headerView;
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.listView];
    // Do any additional setup after loading the view.
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = [dataSource valueForKeyPath:@"@distinctUnionOfObjects.self"];
//    _dataSource = dataSource;
}

#pragma mark - getter
-(UIView*)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, self.view.bounds.size.width, 30)];
        [label setText:@"请选择一个设备进行加载"];
        [label setTextColor:[UIColor grayColor]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [_headerView addSubview:label];
    }
    return _headerView;
}


-(UITableView*)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, (self.dataSource.count+1)*44) style:UITableViewStylePlain];
        _listView.tableHeaderView = self.headerView;
        [_listView setDelegate:self];
        [_listView setDataSource:self];
    }
    return _listView;
}

#pragma mark - tableView delegate&datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray* ret = [self.dataSource[indexPath.row] componentsSeparatedByString:@"****"];
    cell.textLabel.text = ret[1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate userDidSelectItem:indexPath.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
