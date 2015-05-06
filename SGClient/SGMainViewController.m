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
#import "SGAPPConfig.h"
#import "SGUtility.h"

#import "SGPortViewController.h"


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
    self.navigationItem.rightBarButtonItem = nil;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadRoomData];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = [[SGUtility getCurrentDB] componentsSeparatedByString:@"."][0];
    self.roomView.frame = CGRectMake(0,
                                     10,
                                     MainScreenWidth(self.interfaceOrientation),
                                     MainScreenHeight(self.interfaceOrientation)-64);
    
    
    if ([SGUtility getDBChangeFlag]) {
        NSError* error;
        NSString   *strXml = [[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForAllInnerRoom];
        NSDictionary *dict = [XMLReader dictionaryForXMLString:strXml error:&error];
        self.roomList = [ [dict objectForKey:@"root"] objectForKey:@"room"];
        [self.roomView reloadData];
    }
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
                                                                      0,
                                                                      MainScreenWidth(self.interfaceOrientation),
                                                                      MainScreenHeight(self.interfaceOrientation) - 64)
                                      collectionViewLayout:flowLayout];
    [self.roomView setBackgroundColor:[UIColor whiteColor]];
 
    [self.roomView registerClass:[SGSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeader];
    
    [self.roomView registerClass:[SGRoomCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.roomView setDelegate:self];
    [self.roomView setDataSource:self];
    [self.roomView setUserInteractionEnabled:YES];
    [self.view addSubview:self.roomView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id cubicle = [[self.roomList objectAtIndex:section] objectForKey:@"cubicle"];
    
    if ([cubicle isKindOfClass:[NSDictionary class]]) {
        return 1;
    } else {
        return [(NSArray*)cubicle count];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return self.roomList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SGRoomCell *cell = (SGRoomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    id cubicles = [[self.roomList objectAtIndex:indexPath.section] objectForKey:@"cubicle"];
    
    if ([cubicles isKindOfClass:[NSArray class]]) {
        [cell setData:[cubicles objectAtIndex:indexPath.row]];
        [cell setDelegate:self];
    }
    if ([cubicles isKindOfClass:[NSDictionary class]]) {
        [cell setData:cubicles];
        [cell setDelegate:self];
    }

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [SGRoomCell cellsize];
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(15, 15, 15, 15);
}

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
                                     MainScreenHeight(toInterfaceOrientation)-64);
    }

#pragma mark - 用户点击入口 加载下一级界面
-(void)cellDidSeletedWithCubicleId:(NSDictionary*)cubicleData{
    SGCableViewController* cableController = [[SGCableViewController alloc] init];
    [cableController setCubicleData:cubicleData];
    [self.navigationController pushViewController:cableController animated:YES];
}

#pragma mark - 扫码入口 加载下一级界面 跳转第三级
-(void)scanModeWithCubicleId:(NSInteger)cubicleId withCableId:(NSInteger)cableId{

    for(NSDictionary* dic in self.roomList){
        for(id subDic in dic[@"cubicle"]){
            if ([subDic isKindOfClass:[NSDictionary class]]) {
                if ([subDic[@"id"] integerValue] == cubicleId) {
                    SGCableViewController* cableController = [[SGCableViewController alloc] initWithCubicleData:subDic withCubicleId:cubicleId withCableId:cableId];
                    [self.navigationController pushViewController:cableController animated:NO];
                    break;
                }
            }else{
                
                if ([dic[@"cubicle"][@"id"] integerValue] == cubicleId) {
                    SGCableViewController* cableController = [[SGCableViewController alloc] initWithCubicleData:dic[@"cubicle"] withCubicleId:cubicleId withCableId:cableId];
                    [self.navigationController pushViewController:cableController animated:NO];
                    break;
                }
                
            }
        }
    }
}

#pragma mark - 扫码入口 加载下一级界面 跳转第四级
-(void)scanModeWithPortId:(NSString*)portId{
    
    SGPortViewController* portViewController = [SGPortViewController new];
    [portViewController setPortId:portId];
    [self.navigationController pushViewController:portViewController animated:YES];
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
