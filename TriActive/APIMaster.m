//
//  APIMaster.m
//  Tapp
//
//  Created by Trigma on 18/02/14.
//  Copyright (c) 2014 Trigma. All rights reserved.
//
#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"


#import "APIMaster.h"

@implementation APIMaster

static APIMaster* singleton = nil;

+(APIMaster*)singleton
{
    if(singleton == nil)
        singleton = [[self alloc] init];
    
    return singleton;
}

-(id)init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}



# pragma mark - Register user API

-(void)registerUserWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    //Parameters: username, email, password, first_name, last_name
    
    
    NSString* infoStr = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email=%@&username=%@&password=%@&device_token=%@&profile_image=%@&lat=%@&lng=%@",userInfo[@"first_name"],userInfo[@"last_name"],userInfo[@"email"],userInfo[@"username"],userInfo[@"password"],userInfo[@"device_token"],userInfo[@"profile_image"],userInfo[@"lat"],userInfo[@"lng"]];
    // Encode the parameters
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"register"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}


# pragma mark - Login user API

-(void)LoginUserWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Parameters: username, password
    NSString* infoStr = [NSString stringWithFormat:@"username=%@&password=%@&device_token=%@&lat=%@&lng=%@",userInfo[@"username"],userInfo[@"password"],userInfo[@"device_token"],userInfo[@"lat"],userInfo[@"lng"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"login"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}

# pragma mark - User Home API
-(void)LoginUserWithTwitterInfo:(NSMutableDictionary*)userInfo
              completionHandler:(APICompletionHandler)handler{
  
 NSString* infoStr = [NSString stringWithFormat:@"username=%@&full_name=%@&twitter_id=%@&device_token=%@&lat=%@&lng=%@profile_image=%@&login_type=%@",userInfo[@"username"],userInfo[@"full_name"],userInfo[@"twitter_id"],userInfo[@"device_token"],userInfo[@"lat"],userInfo[@"lng"],userInfo[@"profile_image"],userInfo[@"login_type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"login_with_twitter"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
# pragma mark - User Facebook API
-(void)LoginUserWithFacebookInfo:(NSMutableDictionary*)userInfo
              completionHandler:(APICompletionHandler)handler{
   
    NSString* infoStr = [NSString stringWithFormat:@"username=%@&email=%@&device_token=%@&lat=%@&lng=%@&first_name=%@&last_name=%@&facebook_id=%@&profile_image=%@",userInfo[@"username"],userInfo[@"email"],userInfo[@"device_token"],userInfo[@"lat"],userInfo[@"lng"],userInfo[@"first_name"],userInfo[@"last_name"],userInfo[@"facebook_id"],userInfo[@"profile_image"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"login_with_facebook"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Home API
-(void)userHomeWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&page_number=%d&no_of_post=%d",[userInfo[@"user_id"] intValue],[userInfo[@"page_number"] intValue],[userInfo[@"no_of_post"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"news_feedss"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Home profile API
-(void)userQuestionWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&page_number=%d&no_of_post=%d",[userInfo[@"user_id"] intValue],[userInfo[@"page_number"] intValue],[userInfo[@"no_of_post"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"questions"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Home profile API
-(void)userHashWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"keyword=%@&page_number=%d&no_of_post=%d",userInfo[@"keyword"],[userInfo[@"page_number"] intValue],[userInfo[@"no_of_post"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"search_hash_tags"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Profile API
-(void)otherProfileWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler
{
   
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&login_user_id=%d&page_number=%d&no_of_post=%d",[userInfo[@"user_id"] intValue],[userInfo[@"login_user_id"] intValue],[userInfo[@"page_number"] intValue],[userInfo[@"no_of_post"] intValue]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"other_profile"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Profile API
-(void)userProfileWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
     NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&page_number=%d&no_of_post=%d",[userInfo[@"user_id"] intValue],[userInfo[@"page_number"] intValue],[userInfo[@"no_of_post"] intValue]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"profile"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Trending Activity API
-(void)userTrendingActivityWithInfo:(NSMutableDictionary*)userInfo
                  completionHandler:(APICompletionHandler)handler{
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"user_id"] intValue]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"profile"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Trending Activity API

-(void)userTrendingDetailWithInfo:(NSMutableDictionary*)userInfo
                  completionHandler:(APICompletionHandler)handler{
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"keyword=%@&page_number=%@&no_of_post=%@",userInfo[@"keyword"],userInfo[@"page_number"],userInfo[@"no_of_post"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"select_post_by_keywords"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Trending Activity API

-(void)userTrendingHashTagWithInfo:(NSMutableDictionary*)userInfo
                completionHandler:(APICompletionHandler)handler{
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"keyword=%@&page_number=%@&no_of_post=%@",userInfo[@"keyword"],userInfo[@"page_number"],userInfo[@"no_of_post"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"select_post_by_keywords"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Trending Event/Group API
-(void)userTrendingEvntGrpWithInfo:(NSMutableDictionary*)userInfo
                 completionHandler:(APICompletionHandler)handler{
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"keyword=%@&page_number=%@&no_of_post=%@",userInfo[@"keyword"],userInfo[@"page_number"],userInfo[@"no_of_post"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"select_post_by_keywords"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - User Trending Activity Post API
-(void)userTrendingActivityPostWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler{
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"keyword=%@&activity_name=%@&page_number=%@&no_of_post=%@",userInfo[@"keyword"],userInfo[@"activity_name"],userInfo[@"page_number"],userInfo[@"no_of_post"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"select_post_by_keywords"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Logout API
-(void)logoutWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Parameters: userid
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"userid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"logout"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Edit Profile API
-(void)editUserProfileWithInfo:(NSMutableDictionary*)userInfo
             completionHandler:(APICompletionHandler)handler{
   NSString* infoStr = [NSString stringWithFormat:@"first_name=%@&last_name=%@&city=%@&marital_status=%@&description=%@&device_token=%@&profile_image=%@&cover_image=%@&user_id=%@",userInfo[@"first_name"],userInfo[@"last_name"],userInfo[@"city"],userInfo[@"marital_status"],userInfo[@"description"],userInfo[@"device_token"],userInfo[@"profile_image"],userInfo[@"cover_image"],userInfo[@"userid"]];
    NSLog(@"infoStr--%@",infoStr);
    // Encode the parameter
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"update_profile"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Update Password API
-(void)changePasswordWithInfo:(NSMutableDictionary*)userInfo
            completionHandler:(APICompletionHandler)handler{
    // Parameters: userid,old_password,new_password
    NSLog(@"userInfo--%@",userInfo);
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&old_password=%@&new_password=%@",userInfo[@"user_id"],userInfo[@"old_password"],userInfo[@"new_password"]];
    // Encode the parameters
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"change_password"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}

# pragma mark - Add People API
-(void)suggestionsWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Parameters: userid
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"userid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"users"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Friend Suggestion  API
-(void)suggestionsFollowWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Parameters: userid
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"userid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"user_suggestion"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - List group API
-(void)groupWithInfo:(NSMutableDictionary*)userInfo
   completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"userid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"all_groups"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Follow Users API
-(void)followUsersWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
   
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&follower_id=%d",[userInfo[@"userid"] intValue],[userInfo[@"followerid"] intValue]];
        NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"add_follower"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - UnFollow Users API
-(void)UnfollowUsersWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&follower_id=%d",[userInfo[@"userid"] intValue],[userInfo[@"followerid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"delete_follower"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Events,Followers,Following API for Profile screen
-(void)listUsersWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    
    //Parameters: user_id,follower_id
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&users_friend_id=%@&type=%@",[UserDefaults valueForKey:@"user_id"],userInfo[@"users_friend_id"],userInfo[@"type"]];
    NSLog(@"userInfo--%@",infoStr);
    
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"user_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
# pragma mark - Followers,Following API for event and  group screen
-(void)listUsersGrpAndEventWithInfo:(NSMutableDictionary*)userInfo
                  completionHandler:(APICompletionHandler)handler{
    
    //Parameters: user_id,follower_id
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d",[userInfo[@"userid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"follow_followers"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Save Post API
#pragma mark
-(void)savePostWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    //Parameters: user_id,message,smiley,location,music_name,strava,activity_name,post_image
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&strava_id=%d&smiley=%@&location=%@&post_image=%@&music_name=%@&strava=%@&message=%@&activity_name=%@&type=%@&post_type=%@&video=%@&strava_type=%@&strava_image=%@&strava_duration=%@&strava_distance=%@&strava_calories=%@",[userInfo[@"user_id"] intValue],[userInfo[@"strava_id"] intValue],userInfo[@"smiley"],userInfo[@"location"],userInfo[@"image"],userInfo[@"music"],userInfo[@"strava"],userInfo[@"message"],userInfo[@"activity"],userInfo[@"type"],userInfo[@"post_type"],userInfo[@"video"],userInfo[@"strava_type"],userInfo[@"strava_image"],userInfo[@"strava_duration"],userInfo[@"strava_distance"],userInfo[@"strava_calories"]];
    NSLog(@"userInfo--%@",infoStr);
    
   NSMutableURLRequest* request = RequestForURL(URLForAPI(@"save_post"));

    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Save Group API
#pragma mark
-(void)saveGroupWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    //Parameters: user_id,name,image,location,peoples,description,type
    NSString* infoStr = [NSString stringWithFormat:@"grp_creator_id=%d&name=%@&location=%@&image=%@&peoples=%@&description=%@&type=%@&lat=%@&lng=%@",[userInfo[@"user_id"] intValue],userInfo[@"name"],userInfo[@"location"],userInfo[@"image"],userInfo[@"peoples"],userInfo[@"description"],userInfo[@"type"],userInfo[@"lat"],userInfo[@"lng"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"create_group"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Save Group API
#pragma mark
-(void)editGroupWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    //Parameters: user_id,name,image,location,peoples,description,type
    
    NSString* infoStr = [NSString stringWithFormat:@"group_id=%d&grp_creator_id=%d&name=%@&location=%@&image=%@&peoples=%@&description=%@&type=%@&lat=%@&lng=%@",[userInfo[@"id"] intValue],[userInfo[@"user_id"] intValue],userInfo[@"name"],userInfo[@"location"],userInfo[@"image"],userInfo[@"peoples"],userInfo[@"description"],userInfo[@"type"],userInfo[@"lat"],userInfo[@"lng"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"edit_group"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Group detail API
#pragma mark
-(void)GrpDetailWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"group_id=%d",[userInfo[@"grpid"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"group_details"));
    NSLog(@"userInfo--%@",infoStr);
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Save Event API
#pragma mark
-(void)createEventWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler{
    
    NSString* infoStr = [NSString stringWithFormat:@"evnt_creator_id=%d&name=%@&activity_type=%@&cover_photo=%@&group_id=%@&add_people=%@&type=%@&lat=%@&lng=%@&location=%@&description=%@&date=%@",[userInfo[@"user_id"] intValue],userInfo[@"name"],userInfo[@"activity_type"],userInfo[@"cover_photo"],userInfo[@"group"],userInfo[@"people"],userInfo[@"type"],userInfo[@"lat"],userInfo[@"lng"],userInfo[@"location"],userInfo[@"description"],userInfo[@"date"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"create_event"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Edit Event API
#pragma mark
-(void)editEventWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    
    NSString* infoStr = [NSString stringWithFormat:@"event_id=%d&evnt_creator_id=%d&name=%@&activity_type=%@&cover_photo=%@&group_id=%@&add_people=%@&type=%@&lat=%@&lng=%@&location=%@&description=%@&date=%@",[userInfo[@"id"] intValue],[userInfo[@"user_id"] intValue],userInfo[@"name"],userInfo[@"activity_type"],userInfo[@"cover_photo"],userInfo[@"group"],userInfo[@"people"],userInfo[@"type"],userInfo[@"lat"],userInfo[@"lng"],userInfo[@"location"],userInfo[@"description"],userInfo[@"date"]];
    
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"edit_event"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Event detail API
#pragma mark
//PARMS: event_id

-(void)EventDetailWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"event_id=%d",[userInfo[@"eventId"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"event_details"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
#pragma mark Home Like API
#pragma mark
-(void)HomeLikeWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    //PARAMETER:user_id,post_id,type
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&post_id=%d&type=%@",[userInfo[@"user_id"] intValue],[userInfo[@"post_id"] intValue],userInfo[@"type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"post_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Home Like API
#pragma mark
-(void)HomeListForUserWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    //PARAMETER:user_id,post_id,type
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&post_id=%d&type=%@",[userInfo[@"user_id"] intValue],[userInfo[@"post_id"] intValue],userInfo[@"type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"post_users_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Home Like API
#pragma mark
-(void)TendingListForAllWithInfo:(NSMutableDictionary*)userInfo
             completionHandler:(APICompletionHandler)handler{
    //PARAMETER:user_id,post_id,type
    NSString* infoStr = [NSString stringWithFormat:@"id=%d&type=%@&info_type=%@",[userInfo[@"id"] intValue],userInfo[@"type"],userInfo[@"info_type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"event_users_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Event/Group Like API
#pragma mark

-(void)EventGroupFollowWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    //PARAMETER:user_id,post_id,type
    NSString* infoStr = [NSString stringWithFormat:@"id=%d&follower_id=%d&type=%@&post_type=%@",[userInfo[@"id"] intValue],[userInfo[@"follower_id"] intValue],userInfo[@"type"],userInfo[@"post_type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"add_grp_event_follow"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Home POST Delete API
#pragma mark

-(void)DeletePostWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"post_id=%d",[userInfo[@"post_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"delete_post"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Home POST Delete API
#pragma mark

-(void)EditPostWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&smiley=%@&location=%@&post_image=%@&music_name=%@&strava=%@&message=%@&activity_name=%@&type=%@&post_type=%@&video=%@&strava_type=%@&strava_image=%@",[userInfo[@"user_id"] intValue],userInfo[@"smiley"],userInfo[@"location"],userInfo[@"image"],userInfo[@"music"],userInfo[@"strava"],userInfo[@"message"],userInfo[@"activity"],userInfo[@"type"],userInfo[@"post_type"],userInfo[@"video"],userInfo[@"strava_type"],userInfo[@"strava_image"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"edit_post"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Home POST Delete API
#pragma mark

-(void)detailPostWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"post_id=%d",[userInfo[@"post_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_post_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Event Delete API
#pragma mark


-(void)DeleteEventWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"event_id=%d",[userInfo[@"event_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"delete_event"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Group Delete API
#pragma mark


-(void)DeleteGroupWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler{
      NSString* infoStr = [NSString stringWithFormat:@"group_id=%d",[userInfo[@"group_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"delete_group"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Save Dash API
#pragma mark
-(void)SaveDashWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&text=%@&type=%@&post_type=%@&image=%@&share_text=%@",[userInfo[@"user_id"] intValue],userInfo[@"text"],userInfo[@"type"],userInfo[@"post_type"],userInfo[@"image"],userInfo[@"share_text"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"create_dashboard"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Events List On Map API
#pragma mark
-(void)EventsWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&lat=%f&lng=%f",[userInfo[@"user_id"] intValue],[userInfo[@"lat"] floatValue],[userInfo[@"lng"] floatValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"search_events_by_location"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Groups List On Map API
#pragma mark
-(void)GroupsWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&lat=%f&lng=%f",[userInfo[@"user_id"] intValue],[userInfo[@"lat"] floatValue],[userInfo[@"lng"] floatValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"search_groups_by_location"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Search Event API
#pragma mark
-(void)SearchEventsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&keyword=%@",[userInfo[@"user_id"] intValue],userInfo[@"keyword"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"search_event"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Search Groups  API
#pragma mark
-(void)SearchGroupsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%d&keyword=%@",[userInfo[@"user_id"] intValue],userInfo[@"keyword"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"search_group"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
# pragma mark - Comments List API
#pragma mark
-(void)ListCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"post_id=%d",[userInfo[@"post_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"comment_listing"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
# pragma mark - Trending Comments List API
#pragma mark
-(void)ListTrendingCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler
{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr = [NSString stringWithFormat:@"node_id=%d&type=%@",[userInfo[@"node_id"] intValue],userInfo[@"type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_comments_listing"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark - Save Activity Data API
#pragma mark
-(void)saveActivityWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: active_calories,resting_calories,total_calories,weight,activity_level,user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&active_calories=%@&weight=%@&resting_calories=%@&total_calories=%@&PercentageActivity=%@&activity_level=%@",[userInfo[@"user_id"] intValue],userInfo[@"active_calories"],userInfo[@"weight"],userInfo[@"resting_calories"],userInfo[@"total_calories"],userInfo[@"PercentageActivity"],userInfo[@"activity_level"]];
     NSLog(@"userInfo--%@",userInfo);
     NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_activity"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    }
#pragma mark
# pragma mark - Save Activity Data API
#pragma mark
-(void)saveNutritionWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: // ACCEPTED PARMS: weight,dietary_calories,user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&dietary_calories=%@&weight=%@&bmr=%@",[userInfo[@"user_id"] intValue],userInfo[@"dietary_calories"],userInfo[@"weight"],userInfo[@"BMR"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_nutrition"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
    
}
#pragma mark
#pragma mark - Save Activity Data API
#pragma mark

-(void)saveRecoveryWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&start_time=%@&end_time=%@&total_sleep_time=%@&quality_of_sleep=%@&recovery_percentage=%@",[userInfo[@"user_id"] intValue],userInfo[@"start_time"],userInfo[@"end_time"],userInfo[@"total_sleep_time"],userInfo[@"quality_of_sleep"],userInfo[@"recovery_percentage"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_recovery"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
# pragma mark - Save Activity Data API
#pragma mark
-(void)saveMyBodyWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d@&weight=%@&BMI=%@&body_fat=%@",[userInfo[@"user_id"] intValue],userInfo[@"weight"],userInfo[@"BMI"],userInfo[@"bodyFat"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_mybody"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
# pragma mark - Save Activity Data API
#pragma mark

-(void)saveMyGoalWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&start_date=%@&end_date=%@&goal_name=%@&event=%@&before_image=%@&after_image=%@&activity_level=%@",[userInfo[@"user_id"] intValue],userInfo[@"start_date"],userInfo[@"end_date"],userInfo[@"goal_name"],userInfo[@"event"],userInfo[@"before_image"],userInfo[@"after_image"],userInfo[@"activity_level"]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_mygoal"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
# pragma mark - Save Activity Data API
#pragma mark

-(void)saveWellBeingWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&mood_level=%@&energy_level=%@&wellBeing_percentage%d",[userInfo[@"user_id"] intValue],userInfo[@"mood_level"],userInfo[@"energy_level"],[userInfo[@"wellBeing_percentage"] intValue]];
    NSLog(@"userInfo--%@",userInfo);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"dash_wellbeing"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
#pragma mark - Post Comments API
#pragma mark

-(void)PostCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler{
    
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&post_id=%d&comment=%@",[userInfo[@"user_id"] intValue],[userInfo[@"post_id"] intValue],userInfo[@"comment"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"post_comment"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
# pragma mark - Post Comments API
#pragma mark

-(void)PostTrendingCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler{
  
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&node_id=%d&comment=%@&type=%@",[userInfo[@"user_id"] intValue],[userInfo[@"node_id"] intValue],userInfo[@"comment"],userInfo[@"type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"save_comments"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
#pragma mark
# pragma mark - MyDash Segments API
#pragma mark
-(void)segmentMyDashDataWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d&segment=%@",[userInfo[@"user_id"] intValue],userInfo[@"segment"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"average_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
    
}
#pragma mark
#pragma mark - MyDash Day Segments API
#pragma mark
-(void)DayMyDashDataWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d",[userInfo[@"user_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"day_data"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
    
}
#pragma mark
#pragma mark - Event Follow Description API
#pragma mark
-(void)followEventWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: event_id,follower_id,type
    NSString* infoStr = [NSString stringWithFormat:@"id=%d&follower_id=%d&type=%@&post_type=%@",[userInfo[@"id"] intValue],[userInfo[@"follower_id"] intValue],userInfo[@"type"],userInfo[@"post_type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"add_grp_event_follow"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark - Group Follow Description API
#pragma mark
-(void)followGroupWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
   
     NSString* infoStr = [NSString stringWithFormat:@"id=%d&follower_id=%d&type=%@&post_type=%@",[userInfo[@"id"] intValue],[userInfo[@"follower_id"] intValue],userInfo[@"type"],userInfo[@"post_type"]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"add_grp_event_follow"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark - Event List Users in MyGoal API
#pragma mark

-(void)EventListForIUserWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d",[userInfo[@"user_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_user_events"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark - Group List Users in MyGoal API
#pragma mark

-(void)groupListForIUserWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler{
    NSLog(@"userInfo--%@",userInfo);
    //Profile API Parameter: user_id
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d",[userInfo[@"user_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_user_groups"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark Notification for last one day API
#pragma mark
-(void)NotificationWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler{
    NSString* infoStr =
    [NSString stringWithFormat:@"user_id=%d",[userInfo[@"user_id"] intValue]];
    NSLog(@"userInfo--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_user_notifications"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
#pragma mark
#pragma mark<Dispatch Request To Server>
#pragma mark
-(void)forwardRequest:(NSMutableURLRequest*)request
         showActivity:(BOOL)showActivity
    completionHandler:(APICompletionHandler)handler
    {
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         if(connectionError != nil)
         {
             [[[UIAlertView alloc] initWithTitle:@"Connection Error !" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
             if ([ApplicationDelegate isHudShown]) {
                 [ApplicationDelegate hide_LoadingIndicator];
             }
             return;
         }
         if(handler != nil && data !=nil)
             handler(JSONObjectFromData(data));
     }];}
//**********ELIZA**********//

-(void)editPushNotificatio:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@",[UserDefaults valueForKey:@"user_id"]];
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_notifctn_settings"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}

-(void)editEmailNotificatio:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@",[UserDefaults valueForKey:@"user_id"]];
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"get_email_notifctn_settings"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}


-(void)updatePushNotificatio:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&post_back_slap=%@&post_bump_slap=%@&post_like=%@&event_back_slap=%@&event_bump_slap=%@&event_follow=%@&group_back_slap=%@&group_bump_slap=%@&group_follow=%@&user_follow=%@&user_back_slap=%@&user_bump_slap=%@&post_comment=%@&group_comment=%@&event_comment=%@&user_comment=%@&group_add=%@&event_add=%@",
                         [UserDefaults valueForKey:@"user_id"],userInfo[@"post_back_slap"],userInfo[@"post_bump_slap"],userInfo[@"post_like"],userInfo[@"event_back_slap"],userInfo[@"event_bump_slap"],userInfo[@"event_follow"],userInfo[@"group_back_slap"],userInfo[@"group_bump_slap"],userInfo[@"group_follow"],userInfo[@"user_follow"],userInfo[@"user_back_slap"],userInfo[@"user_bump_slap"],userInfo[@"post_comment"],userInfo[@"group_comment"],userInfo[@"event_comment"],userInfo[@"user_comment"],userInfo[@"group_add"],userInfo[@"event_add"]];
    
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"update_settings"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
-(void)emailPushNotificatio:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&user_follow=%@",
                         [UserDefaults valueForKey:@"user_id"],userInfo[@"user_follow"]];
    
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"update_email_settings"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}

-(void)unBlock_This_user:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&block_user_id=%@",
                         userInfo[@"userid"],userInfo[@"block_user_id"]];
    
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"unblock_user"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}

-(void)block_This_user:(NSMutableDictionary*)userInfo
     completionHandler:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@&block_user_id=%@",
                         userInfo[@"userid"],userInfo[@"block_user_id"]];
    
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"block_user"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
}
-(void)all_blocked_userList:(APICompletionHandler)handler{
    NSString* infoStr = [NSString stringWithFormat:@"user_id=%@",[UserDefaults valueForKey:@"user_id"]];
    NSLog(@"infoStr--%@",infoStr);
    NSMutableURLRequest* request = RequestForURL(URLForAPI(@"blocked_user"));
    [request setHTTPBody:[infoStr dataUsingEncoding:NSUTF8StringEncoding]];
    [self forwardRequest:request showActivity:YES completionHandler:handler];
    
}
@end

