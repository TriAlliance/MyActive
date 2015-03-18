//
//  MyDashWellBeingVC.m
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashWellBeingVC.h"

@interface MyDashWellBeingVC ()

@end

@implementation MyDashWellBeingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    scrollVw_Container.contentSize = CGSizeMake(320, 600);
    //Picker & ToolBar
    arrActivity = [[NSMutableArray alloc]init];
    picker_WellBeing.hidden = YES;
    picker_WellBeing.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
}

-(void)doneWithToolBar
{
    picker_WellBeing.hidden = YES;
    toolBar.hidden = YES;
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
    return arrActivity.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [[arrActivity objectAtIndex:row ] objectForKey:@"key"];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    if([pickerType isEqualToString:@"Energy"])
    {
        txtFld_Energy.text = [[arrActivity objectAtIndex:row ] objectForKey:@"key"];
        _energyPercentage=[[arrActivity objectAtIndex:row ] objectForKey:@"value"];
        
    }else if ([pickerType isEqualToString:@"Mood"])
    {
        txtFld_Mood.text = [[arrActivity objectAtIndex:row ] objectForKey:@"key"];
        _moodPercentage=[[arrActivity objectAtIndex:row ] objectForKey:@"value"];
        
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
    
    [pickerLabel setText:[[arrActivity objectAtIndex:row ] objectForKey:@"key"]];
    
    
    return pickerLabel;
}


#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    scrollVw_Container.contentOffset = CGPointMake(0, 250);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    scrollVw_Container.contentOffset = CGPointMake(0, 0);
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
    [self callSaveWellBeingAPI];
     NSString *errorMessage = [self validateForm];
    if (errorMessage == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    
}
-(void)callSaveWellBeingAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    
    else{
        int mood = [_moodPercentage intValue];
        int energy = [_energyPercentage intValue];
        int wellBeing= round((mood+energy)/2);
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Mood.text) forKey:@"mood_level"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Energy.text) forKey:@"energy_level"];
        [userInfo setValue:[NSString stringWithFormat:@"%i",wellBeing] forKey:@"wellBeing_percentage"];
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API saveWellBeingWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"WellBeing Save Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    
    
        if ([txtFld_Mood.text isEqualToString:@"Select Mood Level"] ||(!(txtFld_Mood.text.length >=1))){
            errorMessage = @"Please Select Mood Level";
        }
        else if ([txtFld_Energy.text isEqualToString:@" Select Energy Level"] || (!(txtFld_Energy.text.length >=1))){
            errorMessage = @"Please Select Energy Level";
        }
   
    return errorMessage;
}


- (IBAction)btnPressed_Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPressed_Mood:(id)sender {
    pickerType = @"Mood";
    [arrActivity removeAllObjects];
    NSDictionary *dictRootMyData = LoadPlist(@"MyDash_pList");
    arrActivity = LoadArrayData(@"Mood");
    picker_WellBeing.hidden = NO;
    toolBar.hidden = NO;
    [picker_WellBeing reloadAllComponents];
}

- (IBAction)btnPressed_Energy:(id)sender {
    
    pickerType = @"Energy";
    [arrActivity removeAllObjects];
    NSDictionary *dictRootMyData = LoadPlist(@"MyDash_pList");
    arrActivity = LoadArrayData(@"Energy");
    picker_WellBeing.hidden = NO;
    toolBar.hidden = NO;
    [picker_WellBeing reloadAllComponents];
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

@end
