//
//  Utility.m
//  TriActive
//
//  Created by Ketan on 04/09/14.
//  Copyright (c) 2014 My Company. All rights reserved.
//

#import "Utility.h"

@implementation Utility



#pragma mark
#pragma mark TxtFld Method
#pragma mark
+(void)slideVwUp :(int)size :(UIViewController*)viewController
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationBeginsFromCurrentState:YES];
    viewController.view.frame = CGRectMake(viewController.view.frame.origin.x, viewController.view.frame.origin.y+size,viewController.view.frame.size.width, viewController.view.frame.size.height);
    [UIView commitAnimations];
    [UIView commitAnimations];
}

#pragma mark
#pragma mark NavBar Title Method
#pragma mark
+(UILabel *)lblTitleNavBar:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = ROBOTO_MEDIUM(18);
    label.textAlignment = NSTextAlignmentCenter;
    label.text=title;
    label.textColor = [UIColor whiteColor] ; // change this color (yellow)
    [label sizeToFit];
    return label;
    
}
+(NSMutableArray *)fetchStravaData:(NSMutableArray *)Arr
{
    MALog(@"%@Arr",Arr);
    return Arr;
}
#pragma mark
#pragma mark BackGestureDisable
#pragma mark
+(void)backGestureDisable:(UIViewController*)viewController
{
    if ([viewController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        viewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark
#pragma mark NavigationBar LeftBarButton Method
#pragma mark
+(UIBarButtonItem *)leftbar:(UIImage *)image :(UIViewController*)viewController
{
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 16)];
    [btnLeft setImage:image forState:UIControlStateNormal];
    [btnLeft addTarget:viewController action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    return left;
}
-(void)leftBtn
{
    
}

#pragma mark
#pragma mark NavigationBar RightBarButton Method
#pragma mark
+(UIBarButtonItem *)rightbar:(UIImage *)image :(UIViewController*)viewController
{
    UIButton *btnRight = [[UIButton alloc]init];
    if (image == nil) {
        btnRight.frame=CGRectMake(0, 0, 40, 30);
        [btnRight setTitle:@"Save" forState:UIControlStateNormal];
        [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnRight.titleLabel.font = [UIFont fontWithName:@"Avenir Next Regular" size:20.0];
    }else
    {
    btnRight.frame=CGRectMake(0, 0, 24, 24);
    [btnRight setImage:image forState:UIControlStateNormal];
    }
    [btnRight addTarget:viewController action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    return right;
}

-(void)rightBtn
{
    
}

#pragma mark
#pragma mark Swipe SideMenu Method
#pragma mark
+(void)swipeSideMenu :(UIViewController*)viewController
{
    if ([viewController.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [viewController.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        
        UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:viewController.navigationController.parentViewController action:@selector(revealGesture:)];
        [viewController.view addGestureRecognizer:navigationBarPanGestureRecognizer];
        
	}
}
#pragma mark
#pragma mark Fetch Contacts
#pragma mark
+(NSMutableArray *)fetchContacts
{
    NSMutableArray * arrContacts = [[NSMutableArray alloc]init];
    
    CFErrorRef error=NULL;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            MALog(@"error--%@",error);
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        
        NSArray *contacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        for(int i=0;i<[contacts count];i++)
        {
            NSMutableDictionary * contactDict = [[NSMutableDictionary alloc]init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)contacts[i];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            if (firstName == nil) {
                [contactDict setValue:@"" forKey:@"firstName"];
            }else
            {
                [contactDict setValue:firstName forKey:@"firstName"];
            }
            
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            if (lastName == nil) {
                [contactDict setValue:@"" forKey:@"lastName"];
            }else
            {
                [contactDict setValue:lastName forKey:@"lastName"];
            }
            UIImage  *image;
            if (ABPersonHasImageData(contactPerson))
            {
                NSData  *imgData = (__bridge NSData *) ABPersonCopyImageDataWithFormat(contactPerson, kABPersonImageFormatThumbnail);
                [contactDict setValue:imgData forKey:@"profile_image"];
                
            }
            else
            {
                [contactDict setValue:@"" forKey:@"profile_image"];
                image = [UIImage imageNamed:@"default.png"];
            }
            //For Phone number
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSString *phoneNumber;
            NSString* mobileLabel;
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++)
            {
                //                CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
                mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
                if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]){
                    phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                    phoneNumber = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                }
            }
            if (phoneNumber != nil) {
                [contactDict setValue:[NSString stringWithFormat:@"%@",phoneNumber] forKey:@"phoneNumber"];
            }else
            {
                [contactDict setValue:@"" forKey:@"phoneNumber"];
            }
                      //For Email ids
            ABMutableMultiValueRef eMail  = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            if(ABMultiValueGetCount(eMail) > 0) {
                [contactDict setValue:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"Email"];
            }else
            {
                [contactDict setValue:@"" forKey:@"Email"];
            }
            [arrContacts addObject:contactDict];
        }
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        NSArray *sortedArray = [arrContacts sortedArrayUsingDescriptors:sortDescriptors];
        
        arrContacts =[NSMutableArray arrayWithArray:sortedArray];
        
        
    }else
    {
        [ApplicationDelegate showAlert:@"Unable to read contacts, Please go to Settings->Privacy->Contacts and enable app to use your contacts."];
    }
    MALog(@"%@arrContacts",arrContacts);
    return arrContacts;
}

//**********ELIZA**********//
#pragma mark
#pragma mark Open Mini Browser
#pragma mark
+(void)openMiniBrowser:(UIViewController*)selfView navController:(UINavigationController*)navController pageOption:(NSString*)urlToBeOpened{
    
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:[NSURL URLWithString:urlToBeOpened]];
    webBrowser.delegate = (id<TSMiniWebBrowserDelegate>)self;
    webBrowser.showURLStringOnActionSheetTitle = YES;
    webBrowser.showPageTitleOnTitleBar = YES;
    webBrowser.showActionButton = YES;
    webBrowser.showReloadButton = YES;
    webBrowser.mode = TSMiniWebBrowserModeNavigation;
    // webBrowser.barTintColor= k_ThemeColor;
    webBrowser.barStyle = UIBarStyleBlack;
    if (webBrowser.mode == TSMiniWebBrowserModeModal){
        webBrowser.modalDismissButtonTitle = @"Cancel";
        [selfView presentViewController:webBrowser animated:YES completion:nil];
    }
    else if(webBrowser.mode == TSMiniWebBrowserModeNavigation){
        [navController pushViewController:webBrowser animated:YES];
    }
    
}

@end
