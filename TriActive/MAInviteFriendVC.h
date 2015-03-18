//
//  MAInviteFriendVC.h
//  MyActive
//
//  Created by Preeti Malhotra on 06/01/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Base64.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface MAInviteFriendVC : UIViewController<MFMessageComposeViewControllerDelegate>
{
    
    __weak IBOutlet UITableView *tblVW_invitations;
     NSMutableArray* arrInvite;
     NSMutableArray *arraySuggestPeople;
     NSMutableArray *phoneNum;
     NSMutableArray *arrTwitter;
     NSString * base64;
}
@property (weak, nonatomic) IBOutlet NSString *keyword;
@property (weak, nonatomic) IBOutlet NSString *facebookID;
- (IBAction)btnPressed_invite:(id)sender;
@end
