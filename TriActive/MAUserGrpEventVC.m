//
//  MAUserGrpEventViewController.m
//  MyActive
//
//  Created by Preeti Malhotra on 28/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAUserGrpEventVC.h"
#import "Constant.h"

@interface MAUserGrpEventVC ()

@end

@implementation MAUserGrpEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_switchVal);
    NSLog(@"_arraySelectedPeople%@",_arraySelectedPeople);
  
    
    NSString *title;
    if ([_listType isEqualToString:@"add_group"])
         title=@"Add Group";
    else
    {
        NSLog(@"_arraySelectedPeople%@",_arraySelectedPeople);
        title=@"Add People";
         NSLog(@"arraySuggestPeople%@",arraySuggestPeople);
    }
    //Initialize the dataArray

    arrayAddPeople = [[NSMutableArray alloc] init];
    arraySuggestPeople=[[NSMutableArray alloc] init];
    NSLog(@"%@",_listType);
  if ([_listType isEqualToString:@"add_group"])
      [self callGroupAPI];
  
  else if([_listType isEqualToString:@"add_people"])
    [self callSuggestionAPI];
    self.navigationItem.titleView = [Utility lblTitleNavBar:title];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(saveUser)];
    self.navigationController.navigationBar.translucent = NO;

}
-(void)callSuggestionAPI
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"]};
    [ApplicationDelegate show_LoadingIndicator];
    [API suggestionsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [arrayAddPeople addObject:[responseDict valueForKey:@"data"]];
            MALog(@"arrSugestion--%lu",(unsigned long)[[arrayAddPeople objectAtIndex:0] count] );
            [tblGrpEvnt reloadData];
        }else
        {
            [ApplicationDelegate showAlert:@"No Suggestions found"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
-(void)callGroupAPI
{
    NSDictionary* userInfo = @{@"userid":[UserDefaults valueForKey:@"user_id"]};
    
    [ApplicationDelegate show_LoadingIndicator];
    [API groupWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
       
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
             NSLog(@"responseDict--%@",responseDict);
            [arrayAddPeople addObject:[responseDict valueForKey:@"data"]];
            [tblGrpEvnt reloadData];
        }else
        {
            [ApplicationDelegate showAlert:@"No groups found"];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}

#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)saveUser
{
    [self.view endEditing:YES];
    if([arraySuggestPeople count]){
       id<userListDelegate> strongDelegate = self.delegate;
       if ([strongDelegate respondsToSelector:@selector(userData:)]) {
        [strongDelegate userData:arraySuggestPeople];
       }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Table View DataSource/Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    if([arrayAddPeople count]>0)
     return [[arrayAddPeople objectAtIndex:0] count];
    else
        return 0;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellGrpEvent";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *cellValue;
    NSDictionary *dictionary =[[arrayAddPeople objectAtIndex:0 ] objectAtIndex:indexPath.row ] ;
    if([arrayAddPeople count]>0){
        
        if ([_arraySelectedPeople containsObject: [[[arrayAddPeople objectAtIndex:0 ] objectAtIndex:indexPath.row ] valueForKey:@"id"]]) {
            
            UIButton *btnSelect=(UIButton *)[cell viewWithTag:604];
            [btnSelect setSelected:YES];
            [btnSelect setBackgroundImage:[UIImage imageNamed:@"box_checked.png"] forState:UIControlStateSelected];
        }
        
     
       if( [_listType isEqualToString:@"add_people"]){
          cellValue = [dictionary objectForKey:@"profile_image"];
        }
        else{
            if ([_arraySelectedGrp containsObject: [[[arrayAddPeople objectAtIndex:0 ] objectAtIndex:indexPath.row ] valueForKey:@"id"]]) {
                UIButton *btnSelect=(UIButton *)[cell viewWithTag:604];
                [btnSelect setSelected:YES];
                [btnSelect setBackgroundImage:[UIImage imageNamed:@"box_checked.png"] forState:UIControlStateSelected];
            }
            

            cellValue = [dictionary objectForKey:@"image"];
        }
    
    UIImageView *ImageView = (UIImageView *)[cell viewWithTag:601];
        ImageView.layer.cornerRadius =  20;//half of the width and height
    ImageView.layer.masksToBounds = YES;
  
    [ImageView sd_setImageWithURL:[NSURL URLWithString:cellValue] placeholderImage:[UIImage imageNamed:@"PicPlaceholderqw.png"] options:SDWebImageRetryFailed];
    
    UILabel *NameLabel = (UILabel *)[cell viewWithTag:602];
        if( [_listType isEqualToString:@"add_people"]){
             NameLabel.text = [NSString stringWithFormat:@"%@ %@",[dictionary objectForKey:@"first_name"],[dictionary objectForKey:@"last_name"]];
        }
        else{
           NameLabel.text = [dictionary objectForKey:@"name"];
            
        }
   
    NameLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
    NameLabel.font = ROBOTO_MEDIUM(14.0);
    UILabel *countryNameLabel = (UILabel *)[cell viewWithTag:603];
        if( [_listType isEqualToString:@"add_people"]){
            countryNameLabel.text = [dictionary objectForKey:@"city"];
        }
        else{
           countryNameLabel.text = [dictionary objectForKey:@"location"];
            
        }
   
    countryNameLabel.textColor = [UIColor colorWithRed:164.0/255.0 green:165.0/255.0 blue:167.0/255.0 alpha:1.0f];
    countryNameLabel.font = ROBOTO_MEDIUM(11.0);
        if ([_switchVal isEqualToString:@"true"]){
            UIButton *btnSelect=(UIButton *)[cell viewWithTag:604];
            [btnSelect setSelected:YES];
            [btnSelect setBackgroundImage:[UIImage imageNamed:@"box_checked.png"] forState:UIControlStateSelected];
             NSMutableDictionary *arrAdd = [[NSMutableDictionary alloc] init];
            [arrAdd setValue:[[[arrayAddPeople objectAtIndex:0 ]  objectAtIndex:indexPath.row] valueForKey:@"first_name"] forKey:@"name"];
            [arrAdd setValue:[[[arrayAddPeople objectAtIndex:0 ]  objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
            [arrAdd setValue:@"add_people" forKey:@"type"];
            [arraySuggestPeople addObject:arrAdd];

        }
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (IBAction)btnPressed_add:(id)sender {
     UIButton *btn = (UIButton *)sender;
     NSMutableDictionary *arrAdd = [[NSMutableDictionary alloc] init];
     CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblGrpEvnt];
     NSIndexPath *indexPath = [tblGrpEvnt indexPathForRowAtPoint:buttonPosition];
    MALog(@"follow-indexPath--%ld",(long)indexPath.row);
    if( [_listType isEqualToString:@"add_people"]){
         [arrAdd setValue:[[[arrayAddPeople objectAtIndex:0 ]  objectAtIndex:indexPath.row] valueForKey:@"first_name"] forKey:@"name"];
        [arrAdd setValue:@"add_people" forKey:@"type"];
    }
    else{
         [arrAdd setValue:[[[arrayAddPeople objectAtIndex:0 ]  objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"name"];
        [arrAdd setValue:@"add_group" forKey:@"type"];
        
    }
   
    [arrAdd setValue:[[[arrayAddPeople objectAtIndex:0 ]  objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
    if(btn.isSelected){
        [btn setBackgroundImage:[UIImage imageNamed:@"box_uncheck.png"] forState:UIControlStateNormal];
        [btn setSelected:NO];
        [arraySuggestPeople removeObject:arrAdd];
    }
    else{
        [btn setBackgroundImage:[UIImage imageNamed:@"box_checked.png"] forState:UIControlStateSelected];
        [btn setSelected:YES];
        [arraySuggestPeople addObject:arrAdd];
    }
    MALog(@"arraySuggestPeople--%@",arraySuggestPeople);
}
@end
