//
//  MyDashMyGoalVC.m
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashMyGoalVC.h"
#import "MAActivityVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
@interface MyDashMyGoalVC ()

@end

@implementation MyDashMyGoalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrEventList=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    scrollVw_Container.contentSize = CGSizeMake(320, 600);
    [self callEventListForIUserAPI];
    [self callGroupListForUserAPI];
    //Picker & ToolBar
    arrEventList = [[NSMutableArray alloc]init];
    arrGroupList = [[NSMutableArray alloc]init];
    pickerEvent.hidden = YES;
    pickerEvent.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
    [datePicker1 addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker1.hidden = YES;
    datePicker1.backgroundColor = [UIColor whiteColor];
    datePicker2.hidden = YES;
    datePicker2.backgroundColor = [UIColor whiteColor];
    [datePicker2 addTarget:self action:@selector(datePickerChanged2:) forControlEvents:UIControlEventValueChanged];
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    
    datePicker.minimumDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@" yyyy-MM-dd hh:mm a"];
    txtFld_startDate.text = [dateFormatter stringFromDate:datePicker.date];
    MALog(@"%@",txtFld_startDate.text);
}
- (void)datePickerChanged2:(UIDatePicker *)datePicker
{
    datePicker2.minimumDate = datePicker1.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    txtFld_endTime.text = [dateFormatter stringFromDate:datePicker.date];
    MALog(@"%@",txtFld_endTime.text);
    
}


-(void)doneWithToolBar
{
    pickerEvent.hidden = YES;
    toolBar.hidden = YES;
    datePicker1.hidden = YES;
    datePicker2.hidden = YES;

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
    if([type isEqualToString:@"event"]){
     return arrEventList.count;
    }
    else
       return arrGroupList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if([type isEqualToString:@"event"]){
     return arrEventList[row];
    }
    else
        return arrGroupList[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
    {
        if([type isEqualToString:@"event"]){
        txtFld_Event.text = arrEventList[row];
        }
        else
            txtFld_goalName.text = arrGroupList[row];
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
        [pickerLabel setFont:ROBOTO_REGULAR(14)];
    }
    if([type isEqualToString:@"event"]){
      [pickerLabel setText:arrEventList[row]];
    }
    else{
        [pickerLabel setText:arrGroupList[row]];
    }
    return pickerLabel;
}


#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

//The following code will allow you to only input numbers as well as limit the amount of characters that can be used.
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (IBAction)btnPressed_Save:(id)sender {
    
   
    [self callSaveMyGoalAPI];
//    NSString *errorMessage = [self validateForm];
//    if (errorMessage == nil) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
-(void)callSaveMyGoalAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_startDate.text) forKey:@"start_date"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_endTime.text) forKey:@"end_date"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_Event.text) forKey:@"event"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_Activity.text) forKey:@"activity_level"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_goalName.text) forKey:@"goal_name"];
        
        if (base64 == nil) {
            [userInfo setValue:nil forKey:@"before_image"];
            NSLog(@"imageData--%@",base64);
        }else
        {
            [userInfo setValue:base64 forKey:@"before_image"];
        }
        if (base64_b == nil) {
            [userInfo setValue:nil forKey:@"after_image"];
            NSLog(@"imageData--%@",base64_b);
        }else
        {
            [userInfo setValue:base64_b forKey:@"after_image"];
        }

        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API saveMyGoalWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"MyGoal Save Successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    
    
        if (!(txtFld_goalName.text.length >= 1) || ([txtFld_goalName.text isEqualToString:@"Select Your Goal"])){
            errorMessage = @"Please select your goal name";
        }
        else if (!(txtFld_startDate.text.length >= 1) || ([txtFld_startDate.text isEqualToString:@"Select Start Time of  Goal"])){
            errorMessage = @"Please Select Start Time of  Goal";
        }
       else if (!(txtFld_endTime.text.length >= 1) || ([txtFld_endTime.text isEqualToString:@"Select end time of your goal"])){
            errorMessage = @"Please Select End Time of  Goal";
        }
        else if (!(txtFld_Event.text.length >= 1) || ([txtFld_Event.text isEqualToString:@"Add Message"])){
            errorMessage = @"Please Select Your Event";
        }
        else if (!(txtFld_Activity.text.length >= 1) || ([txtFld_Activity.text isEqualToString:@"Select Your Activity"])){
            errorMessage = @"Please Select Activity";
        }
    
    return errorMessage;
}

- (IBAction)btnPressed_Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPressed_goal:(id)sender {
     type=@"goal";
    [self.view endEditing:YES];
    pickerEvent.hidden = NO;
    toolBar.hidden=NO;
    [pickerEvent reloadAllComponents];

}

- (IBAction)btnPressed_Activity:(id)sender {
   
    [self.view endEditing:YES];
    
        MAActivityVC *objActivity=VCWithIdentifier(@"MAActivityVC");
        objActivity.delegate = self;
        objActivity.myGoal=@"yes";
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:objActivity animated:NO completion:nil];
}
-(void)activityData:(NSString *)value
{
    txtActivity=value;

    MALog(@"%@",value);
    txtFld_Activity.text=value;
    self.navigationItem.titleView = [Utility lblTitleNavBar:value];
}
-(void)callEventListForIUserAPI
{
   NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
    
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API EventListForIUserWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)
            {
                arrEventList=[[responseDict valueForKey:@"data"] valueForKey:@"name"];
                 NSLog(@"arrEventList--%@",arrEventList);
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
}
-(void)callGroupListForUserAPI
{
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
    
    [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
   // [ApplicationDelegate show_LoadingIndicator];
    [API groupListForIUserWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
            arrGroupList=[[responseDict valueForKey:@"data"] valueForKey:@"name"];
            NSLog(@"arrEventList--%@",arrGroupList);
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
        }
    }];
}
- (IBAction)btnPressed_event:(id)sender {
     type=@"event";
     pickerEvent.hidden = NO;
     toolBar.hidden=NO;
     [pickerEvent reloadAllComponents];
}

- (IBAction)btnPressed_endDate:(id)sender {
    datePicker2.hidden = NO;
    toolBar.hidden=NO;
}

- (IBAction)btnPressed_beforeAfterImage:(id)sender {
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 2; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}
#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    for (UIView *v in [_scrollView subviews]) {
//        [v removeFromSuperview];
//    }
    
//    CGRect workingFrame = _scrollView.frame;
//    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
     
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
               
               } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    self.chosenImages = images;
    [imgView_before setImage:[images objectAtIndex:0]];
    [imgView_after setImage:[images objectAtIndex:1]];
    imageData = UIImageJPEGRepresentation([images objectAtIndex:0], 0.1);
    base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
    imageData_b = UIImageJPEGRepresentation([images objectAtIndex:1], 0.1);
    base64_b = [[NSString alloc] initWithString:[Base64 encode:imageData]];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)btnPressed_startDate:(id)sender{
    datePicker1.hidden = NO;
    toolBar.hidden=NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
