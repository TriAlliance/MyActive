//
//  MAAddEventVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 16/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAAddEventVC.h"
#import "MAEventDescVC.h"
#import "MAProfileVC.h"
#import "MAActivityVC.h"
#import "MAUsersVC.h"
#define METERS_PER_MILE 1609.344
@interface MAAddEventVC ()

@end

@implementation MAAddEventVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatmion
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSLog(@"arrEditData==========%@",_arrEditData);
    NSLog(@"peopel==========%@",[[[_arrEditData  objectAtIndex:0]  valueForKey:@"peoples"] valueForKey:@"id"]);
    if([_arrEditData count]>0){

      imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[_arrEditData  objectAtIndex:0] valueForKey:@"image"]]];
         self.tabBarController.tabBar.hidden = YES;
        self.navigationItem.titleView = [Utility lblTitleNavBar:@"Edit Event"];
        txtFld_eventName.text=[[_arrEditData objectAtIndex:0]valueForKey:@"name"];
        txtFld_Type.text=[[_arrEditData objectAtIndex:0]valueForKey:@"type"];
        txtFld_activityName.text=[[_arrEditData objectAtIndex:0]valueForKey:@"activity_type"];
       [imgEventPhoto sd_setImageWithURL:[NSURL URLWithString:[[_arrEditData objectAtIndex:0] valueForKey:@"image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
        selectDate=[[_arrEditData objectAtIndex:0]valueForKey:@"date"];
        [btn_date setTitle:[[_arrEditData objectAtIndex:0]valueForKey:@"date"] forState:UIControlStateNormal ];
        [btnAddEvnt setTitle:@"Edit Event" forState:UIControlStateNormal ];
        txtView_addDesc.text=[[_arrEditData objectAtIndex:0]valueForKey:@"description"];
        [btnEditcover setTitle:@"Edit Cover" forState:UIControlStateNormal ];
        
        if([[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"]count]>0){
            if([[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"]count]>1){
            lblAddPeople.text =[lblAddPeople.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"] objectAtIndex:0] valueForKey:@"first_name"]]];
              strPeople=[[[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"] objectAtIndex:0] valueForKey:@"id"];

            }
            else {
             lblAddPeople.text =[[[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"] objectAtIndex:0] valueForKey:@"first_name"];
            }
        }
    if([[[_arrEditData objectAtIndex:0] valueForKey:@"group_id"]count]>0){
        if([[[_arrEditData objectAtIndex:0] valueForKey:@"group_id"]count]>1){
        lblAddGroup.text =[lblAddGroup.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[[[_arrEditData objectAtIndex:0] valueForKey:@"group_id"] objectAtIndex:0] valueForKey:@"name"]]];
        }
       else{
        lblAddGroup.text =[[[[_arrEditData objectAtIndex:0] valueForKey:@"group_id"] objectAtIndex:0] valueForKey:@"name"];
       }
      }
    }
    else {
        self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Event"];
        self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
        [btnAddEvnt setTitle:@"Add Event" forState:UIControlStateNormal ];
        [btnEditcover setTitle:@"Add Cover" forState:UIControlStateNormal ];
    }

    
   [Utility swipeSideMenu:self];
     [switchSelect addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    scrollVw_Container.contentSize = CGSizeMake(320, 700);
    arrType = @[@"Private",@"Public"];
    picker_Type.hidden = YES;
    txtView_addDesc.layer.borderColor = [UIColor blackColor].CGColor;
    txtView_addDesc.layer.borderWidth = 1.0f;
    picker_Type.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
    
    [datePicker1 addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker1.hidden = YES;
    datePicker1.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidUnload
{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    datePicker.minimumDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
      selectDate = [dateFormatter stringFromDate:datePicker.date];
     [btn_date setTitle:selectDate forState:UIControlStateNormal ];
}
-(void)doneWithToolBar
{
    picker_Type.hidden = YES;
    toolBar.hidden = YES;
    datePicker1.hidden = YES;
}

#pragma mark
#pragma mark PickerView DataSource
#pragma mark

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return arrType.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return arrType[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
        txtFld_Type.text = arrType[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 320, 32);
        pickerLabel = [[UILabel alloc] initWithFrame:frame] ;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:ROBOTO_MEDIUM(15)];
    }
    [pickerLabel setText:arrType[row]];
    return pickerLabel;
}

- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        switchOn=@"true";
        NSLog(@"Switch is ON");
    } else{
        switchOn=@"false";
        NSLog(@"Switch is OFF");
    }
}
#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)leftBtn
{
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        
        [self.navigationController.parentViewController performSelector:@selector(revealToggle:) withObject:nil afterDelay:0.0];
    
        
	}
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark TextField Methods
#pragma mark

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)btnPressed_Type:(id)sender {
   [self.view endEditing:YES];
    picker_Type.hidden = NO;
    toolBar.hidden = NO;
    datePicker1.hidden = YES;
}
- (IBAction)btnPressed_Date:(id)sender {
    [self.view endEditing:YES];
    datePicker1.hidden = NO;
    picker_Type.hidden = YES;
    toolBar.hidden = NO;
}

- (IBAction)btnPressed_activityList:(id)sender {
    [self.view endEditing:YES];
    MAActivityVC *objActivity=VCWithIdentifier(@"MAActivityVC");
    objActivity.delegate = self;
    [self.navigationController pushViewController:objActivity animated:YES];
}

- (IBAction)btnPressed_addPeople:(id)sender {
   [self.view endEditing:YES];
    picker_Type.hidden = YES;
    MAUserGrpEventVC *objList=VCWithIdentifier(@"MAUserGrpEventViewController");
     objList.delegate = self;
     objList.listType=@"add_people";
    if([_arrEditData count]>0){
        objList.arraySelectedPeople=
        [[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"]valueForKey:@"id"];
       
    }
     objList.switchVal=switchOn;
    [self.navigationController pushViewController:objList animated:YES];
}

#pragma mark
#pragma mark MyDelegate Methods
#pragma mark
-(void)userData:(NSArray *)value
{
   NSLog(@"%@",[[value objectAtIndex:0] valueForKey:@"type"]);
    
    
    if(strPeople == nil)
    {      strPeople=@"";
    }
    if(strGroup == nil)
    {
       strGroup=@"";
    }
    for (int i = 0; i < [value count]; i++)
    {
        if([[[value objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"add_people"]){
             lblAddPeople.text=@"";
        strPeople=[strPeople stringByAppendingString:[NSString stringWithFormat:@"%@,",[[value objectAtIndex:i] valueForKey:@"id"]]];
             NSLog(@"string obtained========%@", strPeople);
        }
        else{
            lblAddGroup.text=@"";
            strGroup=[strGroup stringByAppendingString:[NSString stringWithFormat:@"%@,",[[value objectAtIndex:i] valueForKey:@"id"]]];
        NSLog(@"string obtained========%@", strGroup);
        }
    }
    if ([value count]>1){
          if([[[value objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"add_people"]){
         lblAddPeople.text =[lblAddPeople.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[value objectAtIndex:0] valueForKey:@"name"]]];
          }
          else{
                 lblAddGroup.text =[lblAddGroup.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[value objectAtIndex:0] valueForKey:@"name"]]];
              
          }
      
    }
    else
        if([[[value objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"add_people"]){
        
        lblAddPeople.text=[[value objectAtIndex:0] valueForKey:@"name"];
        }
    else
        lblAddGroup.text=[[value objectAtIndex:0] valueForKey:@"name"];
}
- (IBAction)btnSelectLoc:(id)sender {
    MAAddLocationVC* objLocationVC=VCWithIdentifier(@"MAAddLocationVC");
    objLocationVC.delegate=self;
    [self.navigationController pushViewController:objLocationVC animated:YES];
}
#pragma mark
#pragma mark MyDelegateLocation Methods
#pragma mark
-(void)locationData:(NSDictionary *)value
{
    NSLog(@"%@",value);
    strLoc=[value  valueForKey:@"location"];
    strLocLat=[value  valueForKey:@"lat"];
    strLocLong=[value  valueForKey:@"lng"];
    [txtBtn_addLocation setTitle:strLoc forState:UIControlStateNormal];
}

- (IBAction)btnPressed_coverPic:(id)sender {
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(320.0,150.0);
    picker.cropper.rescaleFactor = 2.0;
    [picker presentPicker];
}
- (IBAction)btnPressed_addGroup:(id)sender {
    [self.view endEditing:YES];
     picker_Type.hidden = YES;
    MAUserGrpEventVC *objList=VCWithIdentifier(@"MAUserGrpEventViewController");
    objList.delegate = self;
    objList.listType=@"add_group";
    if([_arrEditData count]>0){
        objList.arraySelectedGrp=
        [[[_arrEditData objectAtIndex:0] valueForKey:@"group_id"]valueForKey:@"id"];
    }

    [self.navigationController pushViewController:objList animated:YES];
}

- (IBAction)btnPressed_addEvent:(id)sender {
    [self.view endEditing:YES];
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        if([_arrEditData count]>0){
           NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
            [userInfo setValue:[[_arrEditData objectAtIndex:0]valueForKey:@"id"] forKey:@"id"];
            [userInfo setValue:encodeToPercentEscapeString(txtFld_activityName.text) forKey:@"activity_type"];
            [userInfo setValue:encodeToPercentEscapeString(txtFld_eventName.text) forKey:@"name"];
            if(strPeople==nil){
              [userInfo setValue:@"no change" forKey:@"people"];
            }
            else{
              [userInfo setValue:strPeople forKey:@"people"];
            }
            [userInfo setValue:selectDate forKey:@"date"];
            [userInfo  setValue:encodeToPercentEscapeString(strLoc) forKey:@"location"];
             [userInfo setValue:encodeToPercentEscapeString(txtView_addDesc.text) forKey:@"description"];
            [userInfo setValue:strLocLat forKey:@"lat"];
            [userInfo setValue:strLocLong forKey:@"lng"];
            [userInfo setValue:txtFld_Type.text forKey:@"type"];
            if(strPeople==nil){
                [userInfo setValue:@"no change" forKey:@"group"];
            }
            else{
                 [userInfo setValue:strGroup forKey:@"group"];
            }
           
            [userInfo setValue:base64 forKey:@"cover_photo"];
            [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id" ];
            
            
            [ApplicationDelegate show_LoadingIndicator];
            [API editEventWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                    [[[UIAlertView alloc] initWithTitle:AppName message:@"Event Edited Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                    txtView_addDesc.text=@"";
                    txtFld_activityName.text=@"";
                    txtFld_Type.text=@"";
                    txtFld_eventName.text=@"";
                    lblAddGroup.text=@"";
                    lblAddPeople.text=@"";
                    [btn_date setTitle:@"" forState:UIControlStateNormal ];
                    [imgEventPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
                    [txtBtn_addLocation setTitle:@"" forState:UIControlStateNormal];
                    [switchSelect setOn:NO animated:YES];
                    
                   
                }
                if ([ApplicationDelegate isHudShown]) {
                    [ApplicationDelegate hide_LoadingIndicator];
                }
                 [_arrEditData removeAllObjects];
                 [self.navigationController popViewControllerAnimated:YES];
            }];
      }
        else{
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:encodeToPercentEscapeString(txtFld_activityName.text) forKey:@"activity_type"];
    [userInfo setValue:encodeToPercentEscapeString(txtFld_eventName.text) forKey:@"name"];
    [userInfo setValue:strPeople forKey:@"people"];
    [userInfo setValue:txtFld_Type.text forKey:@"type"];
    [userInfo setValue:encodeToPercentEscapeString(strLoc) forKey:@"location"];
    [userInfo setValue:selectDate forKey:@"date"];
    [userInfo setValue:encodeToPercentEscapeString(txtView_addDesc.text) forKey:@"description"];
    [userInfo setValue:strLocLat forKey:@"lat"];
    [userInfo setValue:strLocLong forKey:@"lng"];
    [userInfo setValue:strGroup forKey:@"group"];
    [userInfo setValue:base64 forKey:@"cover_photo"];
    [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id" ];
        
       
    [ApplicationDelegate show_LoadingIndicator];
    [API createEventWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)          {
             [[[UIAlertView alloc] initWithTitle:AppName message:@"Event Created Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            txtView_addDesc.text=@"";
            txtFld_activityName.text=@"";
            txtFld_Type.text=@"";
            txtFld_eventName.text=@"";
            lblAddGroup.text=@"";
            lblAddPeople.text=@"";
            [btn_date setTitle:@"" forState:UIControlStateNormal ];
           [imgEventPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
            [txtBtn_addLocation setTitle:@"" forState:UIControlStateNormal];
           [switchSelect setOn:NO animated:YES];
            [_arrEditData removeAllObjects];
            MAEventDescVC * objEventDescVC=VCWithIdentifier(@"MAEventDescVC");
            objEventDescVC.eventId=[[responseDict valueForKey:@"data"]valueForKey:@"id"];
            [self.navigationController pushViewController:objEventDescVC animated:YES];
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
    
    if (imageData == nil){
              errorMessage = @"Please add cover image";
    }

    else if (!(txtFld_eventName.text.length >= 1)){
        errorMessage = @"Please enter event name";
    }
    else if(!(txtFld_activityName.text.length >= 1)||([txtView_addDesc.text isEqualToString:@""]))
    {
        errorMessage = @"Please select activity";
        
    }
    else if(!(txtFld_Type.text.length >= 1))
    {
        errorMessage = @"Please select privacy";
        
    }
    else if(!(lblAddPeople.text.length >= 1)){
        errorMessage = @"Please add poeple";
    }
//    else if(!(lblAddGroup.text.length >= 1)){
//        errorMessage = @"Please add  group";
//    }
    else if([strLoc isEqualToString:@" "]){
        errorMessage = @"Please enter location";
    }
    else if(!(selectDate.length >= 1)){
        errorMessage = @"Please enter Date";
    }
    else if(!(txtView_addDesc.text.length >= 1) ||([txtView_addDesc.text isEqualToString:@"Add description here......"]))
    {
        errorMessage = @"Please add description";
        
    }
   return errorMessage;
}
#pragma mark - GKImagePicker delegate methods

- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
    imageData = UIImageJPEGRepresentation(image, 0.1);
    base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
    [imgEventPhoto setImage:image];
}
-(void)removeImage
{
    MALog(@"RemoveImg");
    imageData = nil;
    [imgEventPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
}
#pragma mark
#pragma mark activity data delagate
#pragma mark
-(void)activityData:(NSString *)value
{
    MALog(@"value--%@",value);
    txtFld_activityName.text = value;
}
#pragma mark
#pragma mark TextView Methods
#pragma mark

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    [Utility slideVwUp:-252 :self];
    if ([textView.text isEqualToString:@"Add description here......"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
   
    [textView resignFirstResponder];
    [Utility slideVwUp:252 :self];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add description here......";
        textView.textColor = [UIColor darkGrayColor];
    }
    [textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
@end
