//
//  MAPostVC.m
//  MyActive
//
//  Created by Jimcy Goyal on 22/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "MAPostVC.h"
#import "MAPostMusicVC.h"
#import "MAStarvaActivityListVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FRDStravaClientImports.h"
#import <Parse/Parse.h>
#define ACCESS_TOKEN_KEY @"1c719cfffaa851ec8bb4365f9b4da7b6838f464e"
@interface MAPostVC ()
{
    
}
@end

@implementation MAPostVC{
    NSString *name;
    NSString *email;

}- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    if(_PostID){
     [self CallDetailPostAPI ];
    }
     //
    NSString *clientSecret = [UserDefaults objectForKey:@"ClientSecret"];
    NSInteger clientID = [[UserDefaults objectForKey:@"ClientID"] integerValue];
    NSString *domain = [UserDefaults objectForKey:@"CallbackDomain"];
   
    // hard-code ID and secret here:
    clientID =4399;
    clientSecret = @"9541ea540ba721be8ba2c821735bc764ee3108e9";
    domain = @"myactive.co";
    if (clientSecret.length == 0 || clientID == 0 || domain.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
                                                            message:@"Configure the Strava client secret, ID and domain in the Settings or hard-code them in AuthViewController viewDidLoad, and restart the demo app."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [[FRDStravaClient sharedInstance] initializeWithClientId:clientID
                                                clientSecret:clientSecret
     ];
    
  

    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Utility lblTitleNavBar:@"Post"];
    self.navigationController.navigationBar.translucent = NO;
    
    //self.navigationItem.leftBarButtonItem=[Utility leftbar:nil :self];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(rightBtn)];
    smiles=[[NSArray alloc]init];
    smilesTxt=[[NSArray alloc]init];
    
    if (IS_IPHONE_4) {
        _collectionViewSmiles.frame = CGRectMake(8, 200, 312, 177);
        _pagePost.frame = CGRectMake(144, 340, 39, 37);
    }else
    {
        _collectionViewSmiles.frame = CGRectMake(8, 270, 312, 177);
        _pagePost.frame = CGRectMake(144, 417, 39, 37);
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"smileys" ofType:@"plist"];
    NSDictionary *dict =  [NSDictionary dictionaryWithContentsOfFile:path];
    smiles = [dict objectForKey:@"SmileyIcon"];
    NSLog(@"get array%@", [dict objectForKey:@"SmileyIcon"]);
    
    float a = (float)smiles.count/8;
    float b = (float)ceilf(a);
    
    NSInteger numberOfViews = b;
    _pagePost.numberOfPages = numberOfViews;
    
}
-(void)CallDetailPostAPI{
NSDictionary* userInfo = @{
                           @"post_id":_PostID,
                           };

[ApplicationDelegate show_LoadingIndicator];
[API detailPostWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
    NSLog(@"responseDict--%@",responseDict);
    
    if([[responseDict valueForKey:@"result"] intValue] == 1)
    {
        txtMsg.text=[[responseDict valueForKey:@"data"]valueForKey:@"message"];
        self.navigationItem.titleView = [Utility lblTitleNavBar:[[responseDict valueForKey:@"data"]valueForKey:@"activity_name"]];
    }
    else
    {
        [ApplicationDelegate showAlert:ErrorStr];
    }
    if ([ApplicationDelegate isHudShown]) {
        [ApplicationDelegate hide_LoadingIndicator];
    }
   }];

}

- (void)viewWillAppear:(BOOL)animated {
    if([_NoStrava isEqualToString:@"home"]){
      [UserDefaults removeObjectForKey:@"StravaPostData"];
    }
    else if([_NoStrava isEqualToString:@"Strava"]){
    
    if ([txtMsg.text isEqualToString:@"Add Message"]) {
        txtMsg.text = @"";
        txtMsg.textColor = [UIColor blackColor];
    }
        if([[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"distance"]){
       txtMsg.text =[txtMsg.text stringByAppendingString:[NSString stringWithFormat:@" - at %@",[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"distance"]]];
        }
         
    }
    else{}
}
-(void)checktoken
{
    
    
    
    //  NSString *previousToken = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    NSString *previousToken = _tokenfromparse;
    
    NSLog(@"[  %@  ]",previousToken);
    
    if ([previousToken length] > 0) {
        // check the user token is still ok by fetching user data
        self.authorizeButton.hidden = YES;
        self.statusLabel.text = @"Connecting to Strava...";
        
        [[FRDStravaClient sharedInstance] setAccessToken:previousToken];
        [[FRDStravaClient sharedInstance] fetchCurrentAthleteWithSuccess:^(StravaAthlete *athlete) {
            self.statusLabel.text = @"ok.";
            
            
            
            [UserDefaults setObject:[NSString stringWithFormat:@"%ld", athlete.id] forKey:@"AthleteDetail"];
            [UserDefaults setObject:previousToken forKey:@"AccessToken"];
            
            NSLog(@"%@ AthleteDetail", [UserDefaults objectForKey:@"AthleteDetail"]);
            NSLog(@"%@ AccessToken", [UserDefaults objectForKey:@"AccessToken"]);
            
            
            
            
            
            [self performSegueWithIdentifier:@"authorizeSuccessfulSegue" sender:athlete];
        }
                                                                 failure:^(NSError *error) {
                                                                     self.statusLabel.text = @"Access token invalid, you need to reauthorize.";
                                                                     self.authorizeButton.hidden = NO;
                                                                     [[FRDStravaClient sharedInstance] setAccessToken:nil];
                                                                 }];
    } else {
        self.authorizeButton.hidden = NO;
        
        // do nothing, this will show the access button.
    }
    
    
    
}

//eshan
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    if(ApplicationDelegate.window.frame.size.height==568)
    {
        self.tabBarController.tabBar.frame=CGRectMake( self.tabBarController.tabBar.frame.origin.x,519, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
        NSLog(@"after size of window%f",ApplicationDelegate.window.frame.size.height);
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Nav Button Method
#pragma mark
-(void)rightBtn
{
    [self.view endEditing:YES];
    [self  callSavePostAPI];
    
}
-(void)callSavePostAPI
{
    NSString *errorMessage = [self validateForm];
    if (errorMessage != nil) {
        [[[UIAlertView alloc] initWithTitle:AppName message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        NSLog(@"response :%@", errorMessage);
        
    }
    else
    {
       NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
        [userInfo setValue:encodeToPercentEscapeString(txtSmile) forKey:@"smiley"];
        [userInfo setValue:encodeToPercentEscapeString(txtLocation) forKey:@"location"];
        [userInfo setValue:encodeToPercentEscapeString(txtMusic) forKey:@"music"];
        [userInfo setValue:encodeToPercentEscapeString(txtActivity) forKey:@"activity"];
        [userInfo setValue:encodeToPercentEscapeString(txtMsg.text) forKey:@"message"];
        
        if([bit isEqualToString:@"Video"])
        {
            [userInfo setValue:base64 forKey:@"video"];
            [userInfo setValue:encodeToPercentEscapeString(@"video") forKey:@"type"];
        }
        
        else if([bit isEqualToString:@"camera"])
        {
            [userInfo setValue:base64 forKey:@"image"];
            [userInfo setValue:encodeToPercentEscapeString(@"image") forKey:@"type"];
        }
        
        else
        {
            [userInfo setValue:encodeToPercentEscapeString(@"text") forKey:@"type"];
        }
        
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"imageMap"] forKey:@"strava_image"];
        [userInfo setValue:@"image" forKey:@"strava_type"];
        
        [userInfo setValue:@"post" forKey:@"post_type"];
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"distance"] forKey:@"strava"];
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"strava_id"] forKey:@"strava_id"];
         [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"distance"] forKey:@"strava_distance"];
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"distance"] forKey:@"strava_distance"];
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"calories"] forKey:@"strava_calories"];
        [userInfo setValue:[[UserDefaults objectForKey:@"StravaPostData"] valueForKey:@"duration"] forKey:@"strava_duration"];
        [userInfo setValue:[UserDefaults valueForKey:@"user_id"] forKey:@"user_id"];
        [ApplicationDelegate show_LoadingIndicator];
        [API savePostWithInfo:[userInfo mutableCopy] completionHandler:^(NSDictionary *responseDict) {
            NSLog(@"responseDict--%@",responseDict);
            if([[responseDict valueForKey:@"result"] intValue] == 1)          {
                txtMsg.text=@"";
                txtActivity=@"";
                self.navigationItem.titleView =[Utility lblTitleNavBar:@"Post"];
                [btn_ImgPrvw setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                if(_openHome){
                    self.tabBarController.selectedIndex=0;
                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            if ([ApplicationDelegate isHudShown]) {
                [ApplicationDelegate hide_LoadingIndicator];
                
            }
        }];
        
    }
}
- (NSString *)validateForm {
    NSString *errorMessage;
    if(!(txtMsg.text.length >= 1) || ([txtMsg.text isEqualToString:@"Add Message"])){
        errorMessage = @"Please Post Some Data";
    }
    else if ([txtActivity isEqualToString:@""] || txtActivity == nil){
        errorMessage = @"Please Select Activity";
    }
    
    return errorMessage;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark
#pragma mark TextView Methods
#pragma mark

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if(iOSVersion==8.0)
    {
        [Utility slideVwUp:-40 :self];
    }
    
    if(!IS_IPHONE_5)
    {
        [Utility slideVwUp:-20 :self];
    }
    if ([textView.text isEqualToString:@"Add Message"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
    if(iOSVersion==8.0)
    {
        [Utility slideVwUp:40 :self];
    }
    if(!IS_IPHONE_5)
    {
        [Utility slideVwUp:20 :self];
    }
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add Message";
        textView.textColor = [UIColor darkGrayColor];
    }
    [textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
   
    
        
        //[txtMsgselectTextForInput:textField atRange:NSMakeRange(idx, 0)];
   // }
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    else{
        UITextRange *selRange = textView.selectedTextRange;
        UITextPosition *selStartPos = selRange.start;
        NSInteger idx = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selStartPos];
        MALog(@"%ld",(long)idx);
        
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

#pragma mark
#pragma mark UIButton Methods
#pragma mark

- (IBAction)smileBtnPressed:(id)sender {
    [_collectionViewSmiles setHidden:NO];
}

#pragma mark
#pragma mark scrollView Methods
#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = (_collectionViewSmiles.contentOffset.x+234)/ (_collectionViewSmiles.frame.size.width);
    _pagePost.currentPage=currentIndex;
}
- (IBAction)locationBtnPressed:(id)sender
{
    _NoStrava=@"";
    MAAddLocationVC* objLocationVC=VCWithIdentifier(@"MAAddLocationVC");
    objLocationVC.delegate=self;
    [self.navigationController pushViewController:objLocationVC animated:YES];
}

- (IBAction)cameraBtnPressed:(id)sender {
    
      _NoStrava=@"";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:AppName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet addButtonWithTitle:@"Choose Image"];
    [actionSheet addButtonWithTitle:@"Choose Video"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showInView:self.view];
    
}

- (IBAction)musicBtnPressed:(id)sender
{
     _NoStrava=@"";
    MAPostMusicVC *objPostMusic=VCWithIdentifier(@"MAPostMusicVC");
    objPostMusic.delegate = self;
    [self.navigationController pushViewController:objPostMusic animated:YES];
}

#pragma mark
#pragma mark UIActionSheet Methods
#pragma mark
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            picker = [[GKImagePicker alloc] init];
            picker.delegate = self;
            picker.cropper.cropSize = CGSizeMake(320.0,320.0);
            picker.cropper.rescaleImage = YES;
            picker.cropper.rescaleFactor = 2.0;
            [picker presentPicker];
            
        }
            break;
        case 1:
        {
            cusmagePickerController= [[CustomPickerController alloc]init];
            cusmagePickerController.allowsEditing = NO;
            cusmagePickerController.delegate = self;
            cusmagePickerController.isVideo = YES;
            ;
            
            
            
            NSArray * media = [UIImagePickerController availableMediaTypesForSourceType:
                               UIImagePickerControllerSourceTypeCamera];
            if([media containsObject:@"public.movie"])
            {
                cusmagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                cusmagePickerController.showsCameraControls = YES;
                cusmagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                cusmagePickerController.mediaTypes = [NSArray
                                                      arrayWithObjects:@"public.movie",nil];
                cusmagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
               
                cusmagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
                 cusmagePickerController.videoMaximumDuration = 10;
                [self presentViewController:cusmagePickerController animated:YES completion:nil];
            }
            else
            {
                UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Support Error"
                                                               message:@"Video not supported"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"OK", nil];
                
                [alert show];
                
            }
        }
            break;
        default:
            self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:0];
            break;
    }
}


#pragma -mark
#pragma -mark<UIImagePickerController Delegate>
#pragma -mark

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    NSData *data = [NSData dataWithContentsOfFile:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"myMove.mp4"];
    
    [data writeToFile:path atomically:YES];
    NSURL *moveUrl = [NSURL fileURLWithPath:path];
    NSLog(@"movie path %@",moveUrl);
    
    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",moveUrl]];
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [btn_ImgPrvw setBackgroundImage:thumbnail forState:UIControlStateNormal];
    player = nil;
    
    base64 = [[NSString alloc] initWithString:[Base64 encode:data]];
    NSLog(@"%@base64",base64);
    //        postCommentVCObj.base64 = base64;
    //        postCommentVCObj.videoFilePath=moveUrl; //[info objectForKey:@"UIImagePickerControllerMediaURL"];
    //        NSLog(@"%@",base64);
    //    [self.navigationController pushViewController:postCommentVCObj animated:NO];
    bit = @"Video";
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    //  ApplicationDelegate.SelectOption= YES;
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:0];
     }];
}

#pragma -mark
#pragma -mark<CropAnImage>
#pragma -mark

-(UIImage*)imageWithImage:(UIImage*)image andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    UIGraphicsBeginImageContext( CGSizeMake(width, height));
    
    [image drawInRect:CGRectMake(0,0,width,height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)openvideoview
{
    [self presentViewController:cusmagePickerController animated:YES completion:nil];
    
}
#pragma mark
#pragma mark MyDelegate Methods
#pragma mark
-(void)musicData:(NSString *)value
{
    txtMusic=value;
    MALog(@"value--%@",value);
    if ([txtMsg.text isEqualToString:@"Add Message"]) {
        txtMsg.text = @"";
        txtMsg.textColor = [UIColor blackColor];
    }
    txtMsg.text =[txtMsg.text stringByAppendingString:[NSString stringWithFormat:@" - listening to %@",value]];
    
}
-(void)activityData:(NSString *)value
{
    txtActivity=value;
    self.navigationItem.titleView = [Utility lblTitleNavBar:value];
}


-(void)locationData:(NSString *)value
{
    txtLocation=[value valueForKey:@"location"];
    MALog(@"value--%@",value);
    if ([txtMsg.text isEqualToString:@"Add Message"]) {
        txtMsg.text = @"";
        txtMsg.textColor = [UIColor blackColor];
    }
    txtMsg.text =[txtMsg.text stringByAppendingString:[NSString stringWithFormat:@" - at %@",[value valueForKey:@"location"]]];
}
- (IBAction)starBtnPressed:(id)sender {

        
        NSString *previousToken = [UserDefaults objectForKey:@"Strava_token"];
        _NoStrava=@"Strava";
        if ([UserDefaults objectForKey:@"Strava_token"]) {
            // check the user token is still ok by fetching user data
            self.authorizeButton.hidden = YES;
                       [[FRDStravaClient sharedInstance] setAccessToken:previousToken];
          
                self.statusLabel.text = @"ok.";
                MAStarvaActivityListVC *objStrava=VCWithIdentifier(@"MAStarvaActivityListVC");
                objStrava.athleteId=[[UserDefaults objectForKey:@"AthleteId"] intValue];
                objStrava.token=[UserDefaults objectForKey:@"Strava_token"];
                [self.navigationController pushViewController:objStrava animated:YES];
            
        }
        else{
            NSString *strURL = [NSString stringWithFormat:@"http://%@", @"myactive.co"];
            NSLog(@"%@strURL",strURL);
            [[FRDStravaClient sharedInstance] authorizeWithCallbackURL:[NSURL URLWithString:strURL]
                                                             stateInfo:nil];
           
            NSString *previousToken = [UserDefaults objectForKey:@"Strava_token"];
            ;
            if ([previousToken length] > 0) {
                MAStarvaActivityListVC *objStrava=VCWithIdentifier(@"MAStarvaActivityListVC");
                objStrava.athleteId=[[UserDefaults objectForKey:@"AthleteId"] intValue];
                objStrava.token=[UserDefaults objectForKey:@"Strava_token"];
                [self.navigationController pushViewController:objStrava animated:YES];
            }
        }
    
       

  
}

- (IBAction)btnPressed_addActivity:(id)sender {
    [self.view endEditing:YES];
    _NoStrava=@"";
    MAActivityVC *objActivity=VCWithIdentifier(@"MAActivityVC");
    objActivity.delegate = self;
    [self.navigationController pushViewController:objActivity animated:YES];
}
#pragma mark - GKImagePicker delegate methods


- (void)imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
    NSLog(@"imageSize--%f--%f",image.size.width,image.size.height);
    CGFloat compression =0.9f;
    imageData = UIImageJPEGRepresentation(image, compression);
    base64 = [[NSString alloc] initWithString:[Base64 encode:imageData]];
    [btn_ImgPrvw setBackgroundImage:image forState:UIControlStateNormal];
    bit = @"camera";
    //    [btn_ProfilePic setBackgroundImage:image  forState:UIControlStateNormal];
    //    btn_ProfilePic.layer.cornerRadius = 39; // this value vary as per your desire
    //    btn_ProfilePic.clipsToBounds = YES;
}

-(void)removeImage
{
    MALog(@"RemoveImg");
    imageData = nil;
    [btn_ImgPrvw setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

#pragma mark Collection View Datasource/Delegates


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return smiles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellSmile" forIndexPath:indexPath];
    UIImageView *smileyImageView = (UIImageView *)[cell viewWithTag:9000];
    
    smileyImageView.image = [UIImage imageNamed:[[smiles objectAtIndex:indexPath.row ] valueForKey:@"icon"]];
    UILabel* lblsmile=(UILabel*)[cell
                                 viewWithTag:9001];
    lblsmile.text=[[smiles objectAtIndex:indexPath.row ] valueForKey:@"txt"];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *custLabel = (UILabel*)[cell viewWithTag:9001];
    txtSmile=custLabel.text;
    NSString *getText=txtMsg.text;
    NSLog(@"%@",getText);
    if ([txtMsg.text isEqualToString:@"Add Message"]) {
        txtMsg.text = @"";
        txtMsg.textColor = [UIColor blackColor];
    }
    
    NSRange range = [getText rangeOfString:@"- feeling "];
    
    if (range.location != NSNotFound) {
       
        NSString *newString = [txtMsg.text substringToIndex:range.location];
        NSLog(@"newString%lu",(unsigned long)range.location);
        
        txtMsg.text=  [newString stringByAppendingString:[NSString stringWithFormat:@"- feeling %@",custLabel.text]];
        NSLog(@"newString1%@",txtMsg.text);
        NSLog(@"txtSmile%@",txtSmile);
       
    }
    else{
        txtMsg.text =[txtMsg.text stringByAppendingString:[NSString stringWithFormat:@"- feeling %@",custLabel.text]];
    }
}
#pragma mark
#pragma mark UITouch Methods
#pragma mark
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
@end
