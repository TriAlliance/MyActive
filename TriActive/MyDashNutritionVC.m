//
//  MyDashNutritionVC.m
//  MyActive
//
//  Created by Ketan on 03/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MyDashNutritionVC.h"

@interface MyDashNutritionVC ()

@end

@implementation MyDashNutritionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgVw_Graph.image = [self.dict_MyDashData valueForKey:@"imgGraph"];
    
    
    //Picker & ToolBar
    arrActivity = [[NSMutableArray alloc]init];
    
    // Load Array
    NSDictionary *dictRootMyData = LoadPlist(@"MyDash_pList");
    arrActivity = LoadArrayData(@"Gender");
    [[HKManager sharedManager] GraphDashWithInfo:^(NSMutableDictionary *dictDashData, NSError *error) {
        
        if (error) {
            NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
        }
        
        // Update the UI with all of the fetched values.
        dispatch_async(dispatch_get_main_queue(), ^{
            if(dictDashData){
                // Update the user interface based on the current user's health information.
                
                txtFld_Weight.text= [dictDashData valueForKey: @"HK_Weight"];
                txtFld_DietaryCal.text=[dictDashData valueForKey:@"HK_dietaryCalories"];
                 txtFld_BMR.text=[dictDashData valueForKey:@"HK_BMR"];
            }
        });
    }];
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Update the user interface based on the current user's health
}


#pragma mark
#pragma mark Textfield delegate
#pragma mark
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        if (textField == txtFld_Weight)
        {
            [Utility slideVwUp:-160 :self];
        }
        
    }
    if (IS_IPHONE_4) {
        
        if (textField == txtFld_Weight) {
            [Utility slideVwUp:-115 :self];
        }
        
    }

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(IS_IPHONE_5 ||IS_IPHONE_6 || IS_IPHONE_6_PLUS)
    {
        if (textField == txtFld_Weight)
        {
            [Utility slideVwUp:160 :self];
        }
        
    }
    if (IS_IPHONE_4) {
        
        if (textField == txtFld_Weight) {
            [Utility slideVwUp:115 :self];
        }
        
    }
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
    
    [self callSaveNutritionAPI];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)callSaveNutritionAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    
    else{

        NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_DietaryCal.text) forKey:@"dietary_calories"];
        [userInfo setValue:encodeToPercentEscapeString(txtFld_Weight.text) forKey:@"weight"];
          [userInfo setValue:txtFld_BMR.text forKey:@"BMR"];
       [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API saveNutritionWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                [[[UIAlertView alloc] initWithTitle:AppName message:@"MyFood  Save Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
            if ([ApplicationDelegate isHudShown]) {
                
                [ApplicationDelegate hide_LoadingIndicator];
            }
        }];
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
     if (!(txtFld_DietaryCal.text.length >= 1) || !(txtFld_Weight.text .length >= 1) ){
        errorMessage = @"Please Enter Data in Health APP";
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
