//
//  MAAddGroupsVC.m
//  MyActive
//
//  Created by Preeti Malhotra on 16/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAAddGroupsVC.h"
#import "MAGroupDescVC.h"
#import "MAUserGrpEventVC.h"
@interface MAAddGroupsVC ()
@end

@implementation MAAddGroupsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"arrEditData==========%@",_arrEditData);
    if([_arrEditData count]>0){
        imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [[_arrEditData  objectAtIndex:0] valueForKey:@"image"]]];
        //MALog(@"%@",imageData);
        self.tabBarController.tabBar.hidden = YES;
        self.navigationItem.titleView = [Utility lblTitleNavBar:@"Edit Group"];
        txtDescView.text=[[_arrEditData objectAtIndex:0]valueForKey:@"description"];
        txtGrpName.text=[[_arrEditData objectAtIndex:0]valueForKey:@"name"];
        txtFld_Type.text=[[_arrEditData objectAtIndex:0]valueForKey:@"type"];
        [txtBtn_addPeople setTitle:[[_arrEditData objectAtIndex:0]valueForKey:@"location"] forState:UIControlStateNormal];
        [imgGrpPhoto sd_setImageWithURL:[NSURL URLWithString:[[_arrEditData objectAtIndex:0] valueForKey:@"image"]] placeholderImage:CoverPlaceholder options:SDWebImageRetryFailed];
       
             [btnAddGrp setTitle:@"Edit Group" forState:UIControlStateNormal ];
        [btnEditcover setTitle:@"Edit Cover" forState:UIControlStateNormal ];
        if([[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"]count]>0){
            if([[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"]count]>1){
                lblAddPeople.text =[lblAddPeople.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"] objectAtIndex:0] valueForKey:@"first_name"]]];
            }
            else {
                lblAddPeople.text =[[[[_arrEditData objectAtIndex:0] valueForKey:@"peoples"] objectAtIndex:0] valueForKey:@"first_name"];
            }
        }
       
    }
    else{
        self.navigationItem.titleView = [Utility lblTitleNavBar:@"Add Group/Team"];
        self.navigationItem.leftBarButtonItem = [Utility leftbar:[UIImage imageNamed:@"sideMenu.png"] :self];
          [btnAddGrp setTitle:@"Add Group" forState:UIControlStateNormal ];
    }
    [Utility swipeSideMenu:self];
    scrollVw_Container.contentSize = CGSizeMake(320, 700);
    txtDescView.layer.borderColor = [UIColor blackColor].CGColor;
    txtDescView.layer.borderWidth = 1.0f;
    arrType = @[@"Private",@"Public"];
    picker_Type.hidden = YES;
    picker_Type.backgroundColor = [UIColor whiteColor];
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = ToolBarItem(@"Done");
    toolBar.hidden=YES;
   
}
- (void)viewDidUnload
{
     self.tabBarController.tabBar.hidden = NO;
}

-(void)doneWithToolBar
{
    picker_Type.hidden = YES;
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

#pragma mark
#pragma mark TextView Methods
#pragma mark

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    [Utility slideVwUp:-240 :self];
    
    
    if ([textView.text isEqualToString:@"Add description here......"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    
    [Utility slideVwUp:240 :self];
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


#pragma mark
#pragma mark MyDelegate Methods
#pragma mark
-(void)userData:(NSArray *)value
{
    NSLog(@"%@",value);
    strPeople=@"";
    lblAddPeople.text=@"";
    for (int i = 0; i < [value count]; i++)
    {
       
        strPeople=[strPeople stringByAppendingString:[NSString stringWithFormat:@"%@,",[[value objectAtIndex:i] valueForKey:@"id"]]];
          NSLog(@"string obtained========%@", strPeople);
    }
    if ([value count]>1){
              lblAddPeople.text =[lblAddPeople.text stringByAppendingString:[NSString stringWithFormat:@"%@ ....",[[value objectAtIndex:0] valueForKey:@"name"]]];
    }
    else
         lblAddPeople.text=[[value objectAtIndex:0] valueForKey:@"name"];
}

- (IBAction)btnAddGrp:(id)sender {
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
            [userInfo setValue:encodeToPercentEscapeString(txtDescView.text) forKey:@"description"];
            [userInfo setValue:encodeToPercentEscapeString(txtGrpName.text) forKey:@"name"];
            [userInfo setValue:strLocLat forKey:@"lat"];
            [userInfo setValue:strLocLong forKey:@"lng"];
            [userInfo setValue:encodeToPercentEscapeString(strLoc) forKey:@"location"];
            
            if(strPeople==nil){
                [userInfo setValue:@"no change" forKey:@"peoples"];
            }
            else{
                [userInfo setValue:strPeople forKey:@"peoples"];
            }
            [userInfo setValue:txtFld_Type.text forKey:@"type"];
            [userInfo setValue:base64 forKey:@"image"];
            [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id" ];
            [ApplicationDelegate show_LoadingIndicator];
            [API editGroupWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
                NSLog(@"responseDict--%@",responseDict);
                if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                    [[[UIAlertView alloc] initWithTitle:AppName message:@"Group details edited successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
                    txtDescView.text=@"";
                    txtFld_Type.text=@"";
                    txtDescView.text=@"";
                    txtGrpName.text=@"";
                    txtFld_Type.text=@"";
                    [imgGrpPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
                    lblAddPeople.text=@"";
                    [txtBtn_addPeople setTitle:@"" forState:UIControlStateNormal];
                   
                   
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
    [userInfo setValue:encodeToPercentEscapeString(txtDescView.text) forKey:@"description"];
    [userInfo setValue:encodeToPercentEscapeString(txtGrpName.text) forKey:@"name"];
    [userInfo setValue:strPeople forKey:@"peoples"];
    [userInfo setValue:encodeToPercentEscapeString(strLoc) forKey:@"location"];
    [userInfo setValue:strLocLat forKey:@"lat"];
    [userInfo setValue:strLocLong forKey:@"lng"];
    [userInfo setValue:txtFld_Type.text forKey:@"type"];
     [userInfo setValue:base64 forKey:@"image"];
    [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id" ];
    [ApplicationDelegate show_LoadingIndicator];
    [API saveGroupWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
        NSLog(@"responseDict--%@",responseDict);
        if([[responseDict valueForKey:@"result"] intValue] == 1)          {
            [[[UIAlertView alloc] initWithTitle:AppName message:@"Group Created Sucessfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            txtDescView.text=@"";
            txtFld_Type.text=@"";
            txtDescView.text=@"";
            txtGrpName.text=@"";
            txtFld_Type.text=@"";
            [imgGrpPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
            lblAddPeople.text=@"";
           [txtBtn_addPeople setTitle:@"" forState:UIControlStateNormal];
            [_arrEditData removeAllObjects];
            MAGroupDescVC * objgrpDescVC=VCWithIdentifier(@"MAGroupDescVC");
            objgrpDescVC.groupId=[[responseDict valueForKey:@"data"]valueForKey:@"id"];
            [self.navigationController pushViewController:objgrpDescVC animated:YES];
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
    else if (!(txtGrpName.text.length >= 1)){
        errorMessage = @"Please enter Group name";
    }
    else if([strLoc isEqualToString:@""]){
        errorMessage = @"Please enter location";
    }
    else if(!(lblAddPeople.text.length >= 1)){
        errorMessage = @"Please add people";
    }
    else if(!(txtFld_Type.text.length >= 1))
    {
        errorMessage = @"Please select Group type";
    }
    else if(!(txtDescView.text.length >= 1) ||([txtDescView.text isEqualToString:@"Add description here......"]))
    {
        errorMessage = @"Please add Description";
    }
    return errorMessage;
}

- (IBAction)btnSelectLoc:(id)sender {
    MAAddLocationVC* objLocationVC=VCWithIdentifier(@"MAAddLocationVC");
    objLocationVC.delegate=self;
    [self.navigationController pushViewController:objLocationVC animated:YES];
}
#pragma mark
#pragma mark MyDelegate Methods
#pragma mark
-(void)locationData:(NSDictionary *)value
{
    NSLog(@"%@",value);
    strLoc=[value  valueForKey:@"location"];
    strLocLat=[value  valueForKey:@"lat"];
    strLocLong=[value  valueForKey:@"lng"];
    [txtBtn_addPeople setTitle:strLoc forState:UIControlStateNormal];
}
- (IBAction)btnPressed_AddCoverPic:(id)sender {
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
   picker.cropper.cropSize = CGSizeMake(320.0,150.0);
    picker.cropper.rescaleFactor = 2.0;
    [picker presentPicker];
}
#pragma mark - GKImagePicker delegate methods

- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
     imageData = UIImageJPEGRepresentation(image, 0.1);
     base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
     [imgGrpPhoto setImage:image];
}

-(void)removeImage
{
    MALog(@"RemoveImg");
    imageData = nil;
    [imgGrpPhoto setImage:[UIImage imageNamed:@"add_cover.png"]];
}

- (IBAction)btnPressed_addPeople:(id)sender {
    [self.view endEditing:YES];
    MAUserGrpEventVC *objList=VCWithIdentifier(@"MAUserGrpEventViewController");
    objList.delegate = self;
    objList.listType=@"add_people";
    if([_arrEditData count]>0){
      objList.arraySelectedPeople=
        [[[_arrEditData objectAtIndex:0]valueForKey:@"peoples"]valueForKey:@"id"];
    }  
    [self.navigationController pushViewController:objList animated:YES];
}
- (IBAction)btnPressed_Type:(id)sender
{
    [self.view endEditing:YES];
    picker_Type.hidden = NO;
    toolBar.hidden = NO;
    
}
@end
