//
//  APIMaster.h
//  Tapp
//
//  Created by Trigma on 18/02/14.
//  Copyright (c) 2014 Trigma. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APICompletionHandler)(NSDictionary* responseDict);

@interface APIMaster : NSObject
{
    
}

+(APIMaster*)singleton;

-(void)registerUserWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)LoginUserWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)userProfileWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)logoutWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler;
-(void)suggestionsWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)groupWithInfo:(NSMutableDictionary*)userInfo
   completionHandler:(APICompletionHandler)handler;
-(void)followUsersWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)editUserProfileWithInfo:(NSMutableDictionary*)userInfo
             completionHandler:(APICompletionHandler)handler;
-(void)changePasswordWithInfo:(NSMutableDictionary*)userInfo
            completionHandler:(APICompletionHandler)handler;
-(void)listUsersWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)listUsersGrpAndEventWithInfo:(NSMutableDictionary*)userInfo
                  completionHandler:(APICompletionHandler)handler;
-(void)savePostWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;
-(void)saveGroupWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)editGroupWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)createEventWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)editEventWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)GrpDetailWithInfo:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)EventDetailWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)suggestionsFollowWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler;
-(void)userHomeWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;
-(void)HomeLikeWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;
-(void)DeletePostWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler;
-(void)SaveDashWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;
-(void)EventsWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler;
-(void)GroupsWithInfo:(NSMutableDictionary*)userInfo
    completionHandler:(APICompletionHandler)handler;
-(void)SearchEventsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)SearchGroupsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)ListCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)PostCommentsWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)saveActivityWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)saveNutritionWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler;
-(void)saveRecoveryWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)saveWellBeingWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler;
-(void)saveMyBodyWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler;
-(void)saveMyGoalWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler;
-(void)segmentMyDashDataWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler;
-(void)followEventWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)followGroupWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)DayMyDashDataWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler;
-(void)EventListForIUserWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler;
-(void)groupListForIUserWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)userQuestionWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)userTrendingDetailWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)userTrendingEvntGrpWithInfo:(NSMutableDictionary*)userInfo
                 completionHandler:(APICompletionHandler)handler;
-(void)userTrendingActivityPostWithInfo:(NSMutableDictionary*)userInfo completionHandler:(APICompletionHandler)handler;
-(void)EventGroupFollowWithInfo:(NSMutableDictionary*)userInfo
            completionHandler:(APICompletionHandler)handler;
-(void)userTrendingHashTagWithInfo:(NSMutableDictionary*)userInfo
                 completionHandler:(APICompletionHandler)handler;
-(void)PostTrendingCommentsWithInfo:(NSMutableDictionary*)userInfo
              completionHandler:(APICompletionHandler)handler;
-(void)ListTrendingCommentsWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)LoginUserWithTwitterInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)LoginUserWithFacebookInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler;
-(void)NotificationWithInfo:(NSMutableDictionary*)userInfo
completionHandler:(APICompletionHandler)handler;
-(void)DeleteEventWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)DeleteGroupWithInfo:(NSMutableDictionary*)userInfo
         completionHandler:(APICompletionHandler)handler;
-(void)userHashWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;

//**********ELIZA**********//
-(void)editPushNotificatio:(APICompletionHandler)handler;
-(void)editEmailNotificatio:(APICompletionHandler)handler;
-(void)updatePushNotificatio:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler;
-(void)emailPushNotificatio:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;

-(void)block_This_user:(NSMutableDictionary*)userInfo
     completionHandler:(APICompletionHandler)handler;

-(void)unBlock_This_user:(NSMutableDictionary*)userInfo
       completionHandler:(APICompletionHandler)handler;
-(void)HomeListForUserWithInfo:(NSMutableDictionary*)userInfo
             completionHandler:(APICompletionHandler)handler;
-(void)all_blocked_userList:(APICompletionHandler)handler;
-(void)TendingListForAllWithInfo:(NSMutableDictionary*)userInfo
               completionHandler:(APICompletionHandler)handler;

-(void)EditPostWithInfo:(NSMutableDictionary*)userInfo
      completionHandler:(APICompletionHandler)handler;
-(void)detailPostWithInfo:(NSMutableDictionary*)userInfo
        completionHandler:(APICompletionHandler)handler;
-(void)otherProfileWithInfo:(NSMutableDictionary*)userInfo
          completionHandler:(APICompletionHandler)handler;
-(void)UnfollowUsersWithInfo:(NSMutableDictionary*)userInfo
           completionHandler:(APICompletionHandler)handler;
@end
