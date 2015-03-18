//
//  MAPostCommentsVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 20/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAPostCommentsVC.h"
#import "MAHashVC.h"
#import "MAProfileVC.h"
@interface MAPostCommentsVC ()

@end

@implementation MAPostCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    txtFld_comments.delegate = self;
    Results =[[NSMutableArray alloc]init];
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Comments"];
    if([_type isEqualToString:@""]){
        [self callPostCommentsAPI];
    }
    else
     {
         [self callTrendingCommentsAPI];
     }
//    self.tabBarController.tabBar.hidden = YES;
  }

-(void)viewWillAppear:(BOOL)animated{
    viewPost.frame  = CGRectMake(0,self.view.frame.size.height-114, 320,44);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callPostCommentsAPI{
    if([Results count] > 0){
      [Results removeAllObjects];
    }
    NSDictionary* userInfo = @{@"post_id":_post_id};
    [ApplicationDelegate show_LoadingIndicator];
    [API ListCommentsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [Results addObject:[responseDict valueForKey:@"data"]];
           
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
         [tblPostComments reloadData];
    }];
}
-(void)callTrendingCommentsAPI{
   
    if([Results count] > 0){
        [Results removeAllObjects];
    }
    NSDictionary* userInfo = @{@"node_id":_post_id,
                               @"type":_type};
    [ApplicationDelegate show_LoadingIndicator];
    [API ListTrendingCommentsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            [Results addObject:[responseDict valueForKey:@"data"]];
            
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
    [tblPostComments reloadData];
}

#pragma mark Table View DataSource/Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:244.0/255.0 alpha:1.0f];
    if ([Results count]>0 ) {
        return [[Results objectAtIndex:0]count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellShareComment";
    cellShareComments = (MAShareCommentsCell*)[tblPostComments dequeueReusableCellWithIdentifier:CellIdentifier];
    for(STTweetLabel *tweetLabel1 in [cellShareComments subviews])
    {
        if(tweetLabel1.tag == 99999)
        {
            [tweetLabel1 removeFromSuperview];
        }
        
    }
    if (cellShareComments == nil) {
        
        [[NSBundle mainBundle]loadNibNamed:@"MAShareCommentsCell" owner:self options:nil];
    }
        STTweetLabel *tweetLabel1 = [[STTweetLabel alloc] initWithFrame:CGRectMake(74.0, 35.0, 238.0, 35.0)];
         tweetLabel1.tag=99999;
        [tweetLabel1 setText:[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"comment"]];
        tweetLabel1.textAlignment = NSTextAlignmentLeft;
        [cellShareComments addSubview:tweetLabel1];
        [tweetLabel1 setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
            //[self dismissViewControllerAnimated:YES completion:nil];
            MAHashVC * new = VCWithIdentifier(@"MAHashVC");
            new.hashTitle=[NSString stringWithFormat:@"%@", string];
            [self.navigationController pushViewController:new animated:YES];
        }];
     
    if([Results count]>0){
        UIImageView* locImgVws=(UIImageView*)[cellShareComments
                                              viewWithTag:301];
        UILabel* locNameLbls=(UILabel*)[cellShareComments viewWithTag:302];
        UILabel* lblComments=(UILabel*)[cellShareComments viewWithTag:303];
        UILabel* lblDate=(UILabel*)[cellShareComments viewWithTag:304];
        if(locImgVws)
        {
            
            [locImgVws sd_setImageWithURL:[NSURL URLWithString:[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@"placeholderImage.png"] options:SDWebImageRetryFailed];
            locImgVws.layer.cornerRadius =  20;//half of the width and height
            locImgVws.layer.masksToBounds = YES;
            
        }
        if(locNameLbls)
        {
            locNameLbls.text=[NSString stringWithFormat:@"%@ %@",[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"first_name"],[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"last_name"]];
        }
        if(lblComments)
        {
            //lblComments.text=[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"comment"];
          }
        if(lblDate)
        {
            lblDate.text=[[[Results objectAtIndex:0] objectAtIndex:indexPath.row ] valueForKey:@"date"];
        }
    }
    return cellShareComments;
}
/**
 *  Little helper for generating plain white image used as a placeholder
 *  in UITableViewCell's while loading icon images
 */
- (UIImage *)placeholderImage
{
    static UIImage *PlaceholderImage;
    
    if (!PlaceholderImage)
    {
        CGRect rect = CGRectMake(0, 0, 50.0f, 50.0f);
        UIGraphicsBeginImageContext(rect.size);
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithRect:rect] fill];
        PlaceholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return PlaceholderImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        
        NSString *str = [NSString stringWithFormat:@"%@",[UserDefaults valueForKey:@"user_id"]];
        NSString *tmp_str_id =[NSString stringWithFormat:@"%@",[[[Results objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"user_id"]];
        if([tmp_str_id isEqualToString:str]){
            MAProfileVC *obj_MAprofileVC = VCWithIdentifier(@"MAProfileVC");
            obj_MAprofileVC.check_push_or_tab=@"push";
            [self.navigationController pushViewController:obj_MAprofileVC animated:YES];
            
        }
        else{
            OtherUserProfileVC *obj_OtherUser = VCWithIdentifier(@"OtherUserProfileVC");
            obj_OtherUser.other_user_ID =[[[Results objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"user_id"];
            [self.navigationController pushViewController:obj_OtherUser animated:YES];
        }
   
}

- (IBAction)btnPressed_sendPost:(id)sender {
    [self.view endEditing:YES];
         NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        if([_type isEqualToString:@""]){
            NSDictionary* userInfo = @{@"post_id":_post_id,
                                       @"comment" :encodeToPercentEscapeString(txtFld_comments.text),
                                       @"user_id":[UserDefaults valueForKey:@"user_id"]};
            
            [ApplicationDelegate show_LoadingIndicator];
            [API PostCommentsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                if([[responseDict valueForKey:@"result"] intValue] == 1)
                {
                    txtFld_comments.text=@"";
                   
                    [self callPostCommentsAPI];
                    //          [self dismissViewControllerAnimated:YES completion:nil];
                    
                }
                else
                {
                    //            [ApplicationDelegate showAlert:@"Add Comments here"];
                }
                
                if ([ApplicationDelegate isHudShown]) {
                    [ApplicationDelegate hide_LoadingIndicator];
                    
                }
            }];
            [tblPostComments reloadData];
        }
        else{
             NSDictionary* userInfo = @{@"node_id":_post_id,
                                           @"comment" :encodeToPercentEscapeString(txtFld_comments.text),
                                           @"user_id":[UserDefaults valueForKey:@"user_id"],
                                           @"type":_type};
                
                [ApplicationDelegate show_LoadingIndicator];
                [API PostTrendingCommentsWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                    NSLog(@"responseDict--%@",responseDict);
                    if([[responseDict valueForKey:@"result"] intValue] == 1)
                    {
                        txtFld_comments.text=@"";
                        [Results removeAllObjects];
                        [self callTrendingCommentsAPI];
                        //          [self dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    else
                    {
                        //            [ApplicationDelegate showAlert:@"Add Comments here"];
                    }
                    
                    if ([ApplicationDelegate isHudShown]) {
                        [ApplicationDelegate hide_LoadingIndicator];
                        
                    }
                }];
                
            }
    
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    
    
    if (!(txtFld_comments.text.length >= 1) || ([txtFld_comments.text isEqualToString:@"Write Comment here....."])){
        errorMessage = @"Please write comment to post ";
    }
    return errorMessage;
}
#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(IS_IPHONE_6 || IS_IPHONE_6_PLUS){
    viewPost.frame  = CGRectMake(0,self.view.frame.size.height-300, 320,44);
    }
        else{
             viewPost.frame  = CGRectMake(0,self.view.frame.size.height-290, 320,44);
            
        }


}

-(void)textFieldDidEndEditing:(UITextField *)textField{
     if(IS_IPHONE_6 || IS_IPHONE_6_PLUS){
          viewPost.frame  = CGRectMake(0,self.view.frame.size.height-124, 320,44);
     }
     else{
    viewPost.frame  = CGRectMake(0,self.view.frame.size.height-114, 320,44);
     }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
  
    return NO;
}
#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (IBAction)btnPressed_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
