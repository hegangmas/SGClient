//
//  SGRoomCell.m
//  SGClient
//
//  Created by JY on 14-6-16.
//  Copyright (c) 2014年 XLDZ. All rights reserved.
//

#import "SGRoomCell.h"

@implementation SGRoomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SGRoomCell" owner:self options: nil];

        if(arrayOfViews.count < 1)
        {
            return nil;
        }

        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.deviceListView.dataSource = self;
        self.deviceListView.delegate = self;
    }
    return self;
}



-(void)setData:(NSDictionary *)data{
    _data = data;
    self.roomInfo.text = [data objectForKey:@"name"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* ary = (NSArray*)[self.data objectForKey:@"device"];
    if(ary)
        return ary.count;
    else
    {
        NSDictionary* dict = (NSDictionary*)[self.data objectForKey:@"device"];
        if(dict)
            return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.font = [UIFont fontWithName:@"System" size:5];
    
    id deviceobj = [self.data objectForKey:@"device"];
    if ([deviceobj isKindOfClass:[NSArray class]]) {
        id text =[[[deviceobj objectAtIndex:indexPath.row] objectForKey:@"devicename"] objectForKey:@"text"];
        if(text == nil)
            text = @"";
        cell.textLabel.text = text;
        
    }
    else if ([deviceobj isKindOfClass:[NSDictionary class]]) {
        id text =[[deviceobj objectForKey:@"devicename"] objectForKey:@"text"];
        if(text == nil)
            text = @"";
        cell.textLabel.text = text;
    }
    else
        cell.textLabel.text = @"";
    return cell;
}

+(CGSize) cellsize
{
    return CGSizeMake(180, 250);
}

@end
