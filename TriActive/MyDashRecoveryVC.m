//
//  MyDashRecoveryVC.m
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashRecoveryVC.h"

@interface MyDashRecoveryVC ()

@end

@implementation MyDashRecoveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    scrollVw_Container.contentSize = CGSizeMake(320, 650);
    
    //Picker & ToolBar
    arrActivity = [[NSMutableArray alloc]init];
    arrQualitySleep=[[NSMutableArray alloc]init];
    picker_Recovery.hidden = YES;
    picker_Recovery.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
    toolBarKeyboard.barStyle = UIBarStyleBlackTranslucent;
    toolBarKeyboard.items = ToolBarItemKeyboard(@"Done");
    toolBarKeyboard.hidden=YES;
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
     txtFld_SleepHr.text = [dateFormatter stringFromDate:datePicker.date];
    MALog(@"%@",txtFld_SleepHr.text);
}
- (void)datePickerChanged2:(UIDatePicker *)datePicker
{
    datePicker2.minimumDate = datePicker1.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    txtFld_SleepHrEnd.text = [dateFormatter stringFromDate:datePicker.date];
    MALog(@"%@",txtFld_SleepHr.text);
   

}
-(void)doneWithToolBar
{
    picker_Recovery.hidden = YES;
    toolBar.hidden = YES;
    datePicker1.hidden = YES;
    datePicker2.hidden = YES;
}
-(void)doneWithToolBarKeyboard
{
    toolBarKeyboard.hidden = YES;
    [self.view endEditing:YES];
}


#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    toolBarKeyboard.hidden = NO;
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
   {
//        if (textField == txtFld_dontSleep|| textField == txtFld_hardlySleep || textField == txtFld_restSleep || textField == txtFld_sleepEnough || textField == txtFld_okSleep || textField == txtFld_goodSleep) {
//            [Utility slideVwUp:-240 :self];
//        }
//        else if (textField == txtFld_greatSleep || textField == txtFld_didntSleepEnough || textField == txtFld_slepBaby) {
//            [Utility slideVwUp:-260 :self];
//        }
    //}
//    if (IS_IPHONE_4) {
//        
//        if (textField == txtFld_Uname || textField == txtFld_Password || textField == txtFld_ConfirmPass) {
//            [Utility slideVwUp:-215 :self];
//        }
//        else if (textField == txtFld_Lname || textField == txtFld_Email) {
//            [Utility slideVwUp:-115 :self];
//        }
    }

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
//         if (textField == txtFld_dontSleep|| textField == txtFld_hardlySleep || textField == txtFld_restSleep || textField == txtFld_sleepEnough || textField == txtFld_okSleep || textField == txtFld_goodSleep) {
//            [Utility slideVwUp:240 :self];
//        }
//        else if (textField == txtFld_greatSleep || textField == txtFld_didntSleepEnough || textField == txtFld_slepBaby) {
//            [Utility slideVwUp:260 :self];
//        }

//        else if (textField == txtFld_restSleep || textField == txtFld_dontSleep) {
//            [Utility slideVwUp:-115 :self];
//        }
        
    }

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
    MALog(@"arrActivity.count===%li", (unsigned long)arrActivity.count);
   
    if ([pickerType isEqualToString:@"SleepHour"])
    {
         return arrActivity.count;
        
    }
    else if([pickerType isEqualToString:@"SleepQuality"]){
        return   arrQualitySleep.count;
    }
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    MALog(@"arrActivity[row]%@",arrActivity[row]);
     if([pickerType isEqualToString:@"SleepQuality"]){
        return [[arrQualitySleep objectAtIndex:row ] objectForKey:@"key"];
           }
    else
        return 0;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
     if([pickerType isEqualToString:@"SleepQuality"]){
        txtFld_sleepQuality.text=[[arrQualitySleep objectAtIndex:row] valueForKey:@"key"];
         _sQuality=[[arrQualitySleep objectAtIndex:row] valueForKey:@"percentage"];
    }
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
    
     if([pickerType isEqualToString:@"SleepQuality"]){
        [pickerLabel setText:[[arrQualitySleep objectAtIndex:row ] valueForKey:@"key"]];
      
    }
    return pickerLabel;
}

#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (IBAction)btnPressed_Save:(id)sender {
    [self callSaveRecoveryAPI];
     NSString *errorMessage = [self validateForm];
    if (errorMessage == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)callSaveRecoveryAPI
{
    float timeSt;
    NSTimeInterval interval = [datePicker1.date timeIntervalSinceDate: datePicker2.date];
    int hour = interval / 3600;
    int minute = (int)interval % 3600 / 60;
    float min = ceil((fabs(interval / 60)));
     NSLog(@"%f total interval", interval);
     NSLog(@"%f total min", min);
         float timeSlot = round((double)min / 5);
    NSLog(@"slot obtained %f", timeSlot);
    if(((fabs(hour) >= 7) && (fabs(hour) < 15))){
      float  minobt = round(min - 450);
      int  slot= round((double)minobt / 5);
      float getSlot= 91 - slot;
      timeSt = round(getSlot*1.0989);
        NSLog(@"get slot====%f", timeSt);
    }
    else if(timeSlot <= 91){
         timeSt = round((timeSlot+1)*1.0989);
         NSLog(@"lesser====%f", timeSt);
    }
    else if(fabs(hour) >= 15){
        timeSt = 0.0;
        NSLog(@"hours====%f", timeSt);
    }
    else{
        
    }
    float number = [_sQuality floatValue];
    int Recovery= round((timeSt+number)/2);
    NSLog(@"%i Recovery", Recovery);
   NSLog(@"%@ %dh %dm", interval<0?@"-":@"+", ABS(hour), minute);
    NSString *totalTime=[NSString stringWithFormat:@" %dh %dm",  ABS(hour), ABS(minute)];
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_SleepHr.text) forKey:@"start_time"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_SleepHrEnd.text) forKey:@"end_time"];
        [userInfo setValue:totalTime forKey:@"total_sleep_time"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_sleepQuality.text) forKey:@"quality_of_sleep"];
        [userInfo setValue:[NSString stringWithFormat:@"%i",Recovery] forKey:@"recovery_percentage"];
        
       [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API saveRecoveryWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"Recovery Data Save Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    
    
        if (!(txtFld_SleepHr.text.length >=1) || ([txtFld_SleepHr.text isEqualToString:@"Select start hours of sleep"])){
            errorMessage = @"Please Select Start Time";
        }
       else if (!(txtFld_SleepHrEnd.text.length >= 1) || ([txtFld_SleepHrEnd.text isEqualToString:@"Select end hours of sleep"])){
         errorMessage = @"Please Select End Time";
       }
      else if (!(txtFld_sleepQuality.text.length >= 1) || ([txtFld_sleepQuality.text isEqualToString:@"Select sleep quality"])){
        errorMessage = @"Please Select Sleep Quality";
      }
    return errorMessage;
}

- (IBAction)btnPressed_Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPressed_SleepHrs:(id)sender {
     datePicker1.hidden = NO;
     toolBar.hidden=NO;
}

- (IBAction)btnPressed_SleepHrsEnd:(id)sender{
     datePicker2.hidden = NO;
     toolBar.hidden = NO;

}
- (IBAction)btnPressed_SleepQuality:(id)sender {
    
    pickerType = @"SleepQuality";
    NSDictionary *dictRootMyData = LoadPlist(@"MyDash_pList");
    arrQualitySleep= LoadArrayData(@"SleepQuality");
    picker_Recovery.hidden = NO;
    toolBar.hidden = NO;
    [picker_Recovery reloadAllComponents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*LoadXlsx
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
