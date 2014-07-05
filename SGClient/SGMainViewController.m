//
//  SGMainViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//


#import "SGMainViewController.h"
#import "SGMainPageBussiness.h"
#import "SGRoomCell.h"
#import "SGSectionHeaderView.h"
#import "SGSectionFooterView.h"
#import "SGCableViewController.h"


@interface SGMainViewController ()<SGRoomCellDelegate>

@property (nonatomic,strong) NSArray* roomList;
@property (nonatomic,strong) UICollectionView* roomView;

@end

#define kCellIdentifier @"identifier"
#define kSectionHeader  @"SectionHeaderIdentier"

@implementation SGMainViewController

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
    [self loadRoomData];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.roomView.frame = CGRectMake(0,
                                     10,
                                     MainScreenWidth(self.interfaceOrientation),
                                     MainScreenHeight(self.interfaceOrientation));
}


-(void)loadRoomData{
    
    NSError* error;
    NSString   *strXml = [[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForAllInnerRoom];
    NSDictionary *dict = [XMLReader dictionaryForXMLString:strXml error:&error];
    self.roomList = [ [dict objectForKey:@"root"] objectForKey:@"room"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(0.0, 50.0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset    = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);

     self.roomView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                      10,
                                                                      MainScreenWidth(self.interfaceOrientation),
                                                                      MainScreenHeight(self.interfaceOrientation))
                                      collectionViewLayout:flowLayout];
//    [self.roomView setBackgroundColor:RGB(220, 220, 220)];
    [self.roomView setBackgroundColor:[UIColor whiteColor]];
    //107 103 185
 
    [self.roomView registerClass:[SGSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeader];
    
    [self.roomView registerClass:[SGRoomCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.roomView setDelegate:self];
    [self.roomView setDataSource:self];
    [self.roomView setUserInteractionEnabled:YES];
    [self.view addSubview:self.roomView];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray* cubicles = (NSArray*)[[self.roomList objectAtIndex:section] objectForKey:@"cubicle"];
    return [cubicles count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return self.roomList.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SGRoomCell *cell = (SGRoomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSArray* cubicles = (NSArray*) [[self.roomList objectAtIndex:indexPath.section] objectForKey:@"cubicle"];
    
    [cell setData:[cubicles objectAtIndex:indexPath.row]];
    [cell setDelegate:self];
    return cell;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [SGRoomCell cellsize];
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(15, 15, 15, 15);
}

//返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return YES;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        SGSectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionHeader forIndexPath:indexPath];;
        header.roomLabel.text = [[self.roomList objectAtIndex:indexPath.section] objectForKey:@"name"];
        reusableview = header;
    }
    return reusableview;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{

    self.roomView.frame = CGRectMake(0,
                                     0,
                                     MainScreenWidth(toInterfaceOrientation),
                                     MainScreenHeight(toInterfaceOrientation));
    
    [self.roomView reloadData];
}

#pragma mark - 用户点击入口 加载下一级界面
-(void)cellDidSeletedWithCubicleId:(NSDictionary*)cubicleData{
    SGCableViewController* cableController = [[SGCableViewController alloc] init];
    [cableController setCubicleData:cubicleData];
    [self.navigationController pushViewController:cableController animated:YES];
}

#pragma mark - 扫码入口 加载下一级界面
-(void)scanModeWithCubicleId:(NSInteger)cubicleId withCableId:(NSInteger)cableId{

    for(NSDictionary* dic in self.roomList){
        for(NSDictionary* subDic in dic[@"cubicle"]){
            if ([subDic[@"id"] integerValue] == cubicleId) {
                SGCableViewController* cableController = [[SGCableViewController alloc] initWithCubicleData:subDic withCubicleId:cubicleId withCableId:cableId];
                [self.navigationController pushViewController:cableController animated:NO];
            }
        }
    }
}

////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	SGRoomCell * cell = (SGRoomCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    SGCableViewController* cableController = [SGCableViewController new];
//    [cableController setCubicleId:[cell.data valueForKey:@"id"]];
//
//    [self.navigationController pushViewController:cableController animated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
