//
//  MAActivityMenuVC.m
//  MyActive
//
//  Created by Ketan on 31/10/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashActivityVC.h"

@interface MyDashActivityVC ()

@end

@implementation MyDashActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    scrollVw_Container.contentSize = CGSizeMake(320, 600);
   
    //Picker & ToolBar
    arrActivity = [[NSMutableArray alloc]init];
    picker_Activity.hidden = YES;
    picker_Activity.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;

    [[HKManager sharedManager] GraphDashWithInfo:^(NSMutableDictionary *dictDashData, NSError *error) {
        
        if (error) {
            NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
        }
        
        // Update the UI with all of the fetched values.
        dispatch_async(dispatch_get_main_queue(), ^{
         if(dictDashData){
             // Update the user interface based on the current user's health information.
            MALog(@"responseDict--%@",dictDashData );
            txtFld_Weight.text= [dictDashData valueForKey: @"HK_Weight"];
             txtFld_ActiveCal.text= [dictDashData valueForKey: @"HK_ActiveCal"];
             txtFld_RestingCal.text= [dictDashData valueForKey: @"HK_RestingCal"];
             //Convert to double
             double Actdouble = [[dictDashData valueForKey: @"HK_ActiveCal"] doubleValue];
             double Restdouble = [[dictDashData valueForKey: @"HK_RestingCal"] doubleValue];
             double sum=Actdouble+Restdouble;
             txtFld_TotalCal.text= [NSString stringWithFormat:@"%.2f",sum];
          }
        });
    }];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    
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
    
   
   if (textField.tag == 666) {
        [self saveWeightIntoHealthStore];
    }
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
    return arrActivity[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if ([pickerType isEqualToString:@"ActLevel"])
    {
        txtFld_ActLevel.text = arrActivity[row];
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
    
    [pickerLabel setText:arrActivity[row]];

    
    return pickerLabel;
}

-(void)doneWithToolBar
{
    picker_Activity.hidden = YES;
    toolBar.hidden = YES;
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

- (IBAction)btnPressed_Save:(id)sender {
    
    [self callSaveActivityAPI ];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)callSaveActivityAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
        
        int total = [txtFld_TotalCal.text intValue];
        int PercentageActivity= round(total/100);
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_ActiveCal.text) forKey:@"active_calories"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Weight.text) forKey:@"weight"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_RestingCal.text) forKey:@"resting_calories"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_TotalCal.text) forKey:@"total_calories"];
        [userInfo setValue:[NSString stringWithFormat:@"%i",PercentageActivity] forKey:@"PercentageActivity"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_ActLevel.text) forKey:@"activity_level"];
                [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
      [ApplicationDelegate show_LoadingIndicator];
        [API saveActivityWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"Activity Save Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
              
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    if (!(txtFld_ActiveCal.text.length >= 1) || !(txtFld_RestingCal.text.length >= 1)|| !(txtFld_TotalCal.text.length >= 1)){
        errorMessage = @"Please Enter Data in Health app";
    }
  else if ([txtFld_ActLevel.text isEqualToString: @"Select Your Activity Level"]){
       errorMessage = @"Please Enter Acitivity Level";
   }
    
    return errorMessage;
}
- (IBAction)btnPressed_Cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnPressed_ActLevel:(id)sender {
    pickerType = @"ActLevel";
    [arrActivity removeAllObjects];
    NSDictionary *dictRootMyData = LoadPlist(@"MyDash_pList");
    arrActivity = LoadArrayData(@"ActivityLevel");
    picker_Activity.hidden = NO;
    toolBar.hidden = NO;
    [picker_Activity reloadAllComponents];
}



- (void)saveWeightIntoHealthStore {
//    NSNumberFormatter *formatter = [self numberFormatter];
//    NSNumber *weight = [formatter numberFromString:txtFld_Weight.text];
     double wt = [txtFld_Weight.text doubleValue] * 2.20462262 ;
   NSString *weight =[NSString stringWithFormat:@"%.2f",wt];
    if (!weight && [txtFld_Weight.text length]) {
        NSLog(@"The weight entered is not numeric. ");
        abort();
    }
    if (weight) {
        [[HKManager sharedManager] saveWeightIntoHealthStore:weight completion:^(NSError *error) {
            
            if (error) {
                NSLog(@"No ActiveEnergyBurn available %@.", error);
                //abort();
            }
        }];
    }
}
#pragma mark - Convenience
- (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
    });
    return numberFormatter;
}

@end
