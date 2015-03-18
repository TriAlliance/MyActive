//
//  MACommentsVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 19/11/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MACommentsVC.h"
//#import "MAHomeVC.h"
@interface MACommentsVC ()

@end

@implementation MACommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    lblDashType.text=_type;
//    if([_type isEqualToString:@"Pie Chart"]){
//      imgViewDash.frame = CGRectMake(20, 52, 160,160);
//    }
//    else
//    {
//        imgViewDash.frame = CGRectMake(0, 0, 320,155);
//    }
     self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Comments"];
    txtViewcomments.layer.borderColor = [UIColor blackColor].CGColor;
    txtViewcomments.layer.borderWidth = 1.0f;
    imgViewDash.image= [UIImage imageWithData:_dataImg];
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

- (IBAction)btnPressed_postComments:(id)sender {
    [self.view endEditing:YES];
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else{
    
    NSDictionary* userInfo = @{
                               @"user_id":[UserDefaults valueForKey:@"user_id"],
                               @"type":@"image",
                               @"post_type":@"dashboard",
                               @"text":encodeToPercentEscapeString(_type),
                               //@"text":@"MyDash",
                               @"image":_baseData,
                               @"share_text":encodeToPercentEscapeString(txtViewcomments.text)
                               };
    txtViewcomments.text=@"";
    [ApplicationDelegate show_LoadingIndicator];
    [API SaveDashWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        
        if([[responseDict valueForKey:@"result"] intValue] == 1)
        {
          
             [ApplicationDelegate showAlert:@"Post Save Sucessfully"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [ApplicationDelegate showAlert:ErrorStr];
        }
        if ([ApplicationDelegate isHudShown]) {
            [ApplicationDelegate hide_LoadingIndicator];
            
        }
    }];
    }

  }
#pragma mark
#pragma mark TextView Methods
#pragma mark

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    viewPostCmt.frame  = CGRectMake(0, -64, 320,329);
   if ([textView.text isEqualToString:@"Add Post here......"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
   
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    viewPostCmt.frame  = CGRectMake(0, 64, 320,329);
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add Post here......";
        textView.textColor = [UIColor darkGrayColor];
    }
   
    
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



#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (NSString *)validateForm {
    NSString *errorMessage;
    if (!(txtViewcomments.text.length >= 1) || ([txtViewcomments.text isEqualToString:@"Add Post here......"])){
        errorMessage = @"Please write  post ";
    }
    
    return errorMessage;
}

- (IBAction)btnPressed_cancel:(id)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}
@end
