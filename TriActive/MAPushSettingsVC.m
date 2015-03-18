//
//  MAPushSettingsVC.m
//  MyActive
//
//  Created by Eliza Dhamija on 30/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import "MAPushSettingsVC.h"

@interface MAPushSettingsVC (){
    UISwitch *switchView;
}

@end

@implementation MAPushSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.titleView = [Utility lblTitleNavBar:@"Notification Settings"];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleDone target:self action:@selector(updateMyNotification)];
  tmp_Value_For_Key_arr  = [[NSMutableArray alloc]init];
   tmp_Key_arr = [[self.dict_Notification_check allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    arr_notification_text = [[NSArray alloc]initWithObjects:@"I have event add",@"I got event back slap",@"I got event bump slap",@"I have event comment",@"I have event follow",@"I have group add",@"I got group back slap",@"I got group bump slap",@"I got group comment",@"I got group follow",@"I got post back slap",@"I got post bump slap",@"I have post comment",@"I got post like",@"I got user back slap",@"I have user bump slap",@"I have user comment",@"I have user follow",@"I have user_id", nil];
    arr_push_text = [[NSArray alloc]initWithObjects:@"I got user follow", nil];
    for(int i=0;i<[tmp_Key_arr count];i++){
        [tmp_Value_For_Key_arr addObject:[self.dict_Notification_check valueForKey:[NSString stringWithFormat:@"%@",[tmp_Key_arr objectAtIndex:i]]]];
    }
    

    
    // Do any additional setup after loading the view.
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
    return [self.dict_Notification_check count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NotificationCheckCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *lbl_text = (UILabel*)[cell.contentView viewWithTag:10];
    if([self.optionSelected isEqualToString:@"push"]){
        lbl_text.text = [arr_notification_text objectAtIndex:indexPath.row];
    }
    else{
        lbl_text.text = [arr_push_text objectAtIndex:indexPath.row];

    }
    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(100.0f, 5.0f, 75.0f, 30.0f)];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    switchView.tag=indexPath.row;
    cell.accessoryView = switchView;
    
    if([[tmp_Value_For_Key_arr objectAtIndex:indexPath.row] isEqualToString:@"1"]){
        [switchView setOn:YES];
    }
       else{
           [switchView setOn:NO];
       }
    
    return cell;
}

-(IBAction)switchChanged:(UISwitch*)sender {
    
    if(sender.isOn){
        [tmp_Value_For_Key_arr replaceObjectAtIndex:sender.tag withObject:@"1"];
    }
    else{
        [tmp_Value_For_Key_arr replaceObjectAtIndex:sender.tag withObject:@"0"];

    }
}

-(void)updateMyNotification{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for(int i=0;i<[tmp_Key_arr count];i++){
        [dict setValue:tmp_Value_For_Key_arr[i] forKey:tmp_Key_arr[i]];
    }
    
    [ApplicationDelegate show_LoadingIndicator];
    if([self.optionSelected isEqualToString:@"push"]){
        [API updatePushNotificatio:dict completionHandler:^(NSDictionary *responseDict) {
            [ApplicationDelegate hide_LoadingIndicator];
            NSLog(@"%@",responseDict);
            [ApplicationDelegate showAlert:[responseDict valueForKey:@"message"]];
        }];
    }
    else{
        [API emailPushNotificatio:dict completionHandler:^(NSDictionary *responseDict) {
            [ApplicationDelegate hide_LoadingIndicator];
            NSLog(@"%@",responseDict);
            [ApplicationDelegate showAlert:[responseDict valueForKey:@"message"]];
        }];
    }
}

@end
