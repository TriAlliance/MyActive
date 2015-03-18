//
//  MyDashMyBodyVC.m
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashMyBodyVC.h"

@interface MyDashMyBodyVC ()

@end

@implementation MyDashMyBodyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
   //Picker & ToolBar
    arrActivity = [[NSMutableArray alloc]init];
   
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[HKManager sharedManager] GraphDashWithInfo:^(NSMutableDictionary *dictDashData, NSError *error) {
        
        if (error) {
            NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
        }
        
        // Update the UI with all of the fetched values.
        dispatch_async(dispatch_get_main_queue(), ^{
            if(dictDashData){
                // Update the user interface based on the current user's health information.
               txtFld_Weight.text= [dictDashData valueForKey: @"HK_Weight"];
               txtFld_bodyFat.text=[dictDashData valueForKey:@"HK_bodyFats"];
                txtFld_BMI.text=[dictDashData valueForKey:@"HK_BMI"];
            }
        });
    }];
   
}

-(void)doneWithToolBar
{
  
    toolBar.hidden = YES;
}

#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
 
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
   
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


- (IBAction)btnPressed_Save:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    [self callSaveMyBodyAPI];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)callSaveMyBodyAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
         NSLog(@"response :%@", errorMessage);
        
    }
     else{
        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_bodyFat.text) forKey:@"bodyFat"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_Weight.text) forKey:@"weight"];
                [userInfo setValue:encodeToPercentEscapeString(txtFld_BMI.text) forKey:@"BMI"];
       
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API saveMyBodyWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"MyBody Data Save Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    if (!(txtFld_bodyFat.text.length >= 1) || !(txtFld_BMI.text.length >= 1)){
        errorMessage = @"Please Enter Data in Health app";
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


@end
