//
//  MAShareSettingVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 04/03/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAShareSettingVC.h"

@interface MAShareSettingVC ()

@end

@implementation MAShareSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Friends"];
    self.navigationItem.title = @"";
    
    [Utility swipeSideMenu:self];
     dataArray = [[NSMutableArray alloc] init];
    //Initialize the dataArray
    NSDictionary *tempDict1=@{@"name":[NSString stringWithFormat:@"Linked with%@",[UserDefaults objectForKey:@"fbname"]],
                              @"connect":@"Connect with Facebook",
                              @"imageFile":@"icon-facebook.png",
                            
                              };
    NSDictionary *tempDict2=@{@"name":[NSString stringWithFormat:@"Linked with%@",[UserDefaults objectForKey:@"twitterName"] ],
                              @"connect":@"Connect with Twitter",
                              @"imageFile":@"icon-twitter.png",
                              
                              };
    NSDictionary *tempDict3=@{@"name":[NSString stringWithFormat:@"Linked with%@",[UserDefaults objectForKey:@"stravaName"] ],
                              @"connect":@"Connect with Strava",
                             @"imageFile":@"starva.png",
                            
                             };
   
    [dataArray addObject:tempDict1];
    [dataArray addObject:tempDict2];
    [dataArray addObject:tempDict3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"shareSettingCell";
      NSDictionary *dictionary1;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *lbl_Name_User = (UILabel*)[cell.contentView viewWithTag:201];
    UIButton *btn_setting = (UIButton*)[cell.contentView viewWithTag:202];
    dictionary1=[dataArray objectAtIndex:indexPath.row];
    NSString *imgValue = [dictionary1 objectForKey:@"imageFile"];
    UIImageView *ImageView = (UIImageView *)[cell viewWithTag:200];
    ImageView.image = [UIImage imageNamed:imgValue];
    [btn_setting addTarget:self action:@selector(settingShare:event:) forControlEvents:UIControlEventTouchUpInside];
    MALog(@"%@dataArray",dataArray);
   
   
    ImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imageFile"]]];
    if([UserDefaults objectForKey:@"fbname"] && indexPath.row==0){
    lbl_Name_User.text =[NSString stringWithFormat:@"Linked: %@",[UserDefaults objectForKey:@"fbname"]];
        [btn_setting setHidden:NO];
    }
    else if([UserDefaults objectForKey:@"twitterName"] && indexPath.row==1){
        lbl_Name_User.text =[NSString stringWithFormat:@"Linked: %@",[UserDefaults objectForKey:@"twitterName"]];
         [btn_setting setHidden:NO];
    }
    else if([UserDefaults objectForKey:@"stravaName"] && indexPath.row==2){
        lbl_Name_User.text =[NSString stringWithFormat:@"Linked: %@",[UserDefaults objectForKey:@"stravaName"]];
         [btn_setting setHidden:NO];
    }
    else{
        lbl_Name_User.text = [NSString stringWithFormat:@"%@",[dictionary1 objectForKey:@"connect"]];
        [btn_setting setHidden:YES];
    }
    
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69.0f;
}

-(IBAction)settingShare:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:tbl_shareSetting];
    NSIndexPath *indexPath = [tbl_shareSetting indexPathForRowAtPoint: currentTouchPosition];
     NSLog(@"%ld",(long)indexPath.row);
    if(indexPath.row==0)
    {
      [UserDefaults removeObjectForKey:@"fbname"];
    }
    else if(indexPath.row==1)
    {
      [UserDefaults removeObjectForKey:@"twitterName"];
    }
    else if(indexPath.row==2)
    {
      [UserDefaults removeObjectForKey:@"stravaName"];
    }
    else{
   }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
}
@end
