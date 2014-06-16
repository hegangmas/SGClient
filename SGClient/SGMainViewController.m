//
//  SGMainViewController.m
//  SGClient
//
//  Created by JY on 14-6-15.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGMainViewController.h"
#import "SGMainPageBussiness.h"
#import "XMLReader.h"
#import "SGRoomCell.h"
#import "SGSectionHeaderView.h"


@interface SGMainViewController ()

@property (nonatomic,strong) NSArray* roomList;
@property (nonatomic,strong) UICollectionView* roomView;

@end

#define kCellIdentifier @"identifier"

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
    [self.view setBackgroundColor: RGB(220, 220, 220)];
    [self loadRoomData];
}

-(void)loadRoomData{
    NSString* strXml = [[SGMainPageBussiness sharedSGMainPageBussiness] queryDevicelistForAllInnerRoom];
    NSError* error;
    NSDictionary* dict = [XMLReader dictionaryForXMLString:strXml error:&error];
    
    self.roomList = [ [dict objectForKey:@"root"] objectForKey:@"room"];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    float width =((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)) - self.dockWidth;
    
    float height = ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height));
    self.roomView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      width,
                                                                      height)
                                      collectionViewLayout:flowLayout];
    
    [self.roomView setBackgroundColor:RGB(220, 220, 220)];
    
    [self.roomView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionIdentier"];
     [self.roomView registerClass:[SGRoomCell class] forCellWithReuseIdentifier:kCellIdentifier];
    self.roomView.delegate = self;
    self.roomView.dataSource = self;
    [self.view addSubview:self.roomView];
    [self.roomView reloadData];
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
    
    return cell;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [SGRoomCell cellsize];
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(15, 15, 15, 15);
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	SGRoomCell * cell = (SGRoomCell *)[collectionView cellForItemAtIndexPath:indexPath];

 
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        SGSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionIdentier" forIndexPath:indexPath];
        if (headerView == nil) {
            headerView = [[SGSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(self.view), 30)];
        }
        headerView.roomLabel.text = [[self.roomList objectAtIndex:indexPath.section] objectForKey:@"name"];
        reusableview = headerView;
    }
    return reusableview;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    float width = ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?self.view.frame.size.width:self.view.frame.size.height)) - self.dockWidth;
    float height = ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)?self.view.frame.size.height:self.view.frame.size.width));
    self.roomView.frame = CGRectMake(0,0, width,height);
    [self.roomView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
