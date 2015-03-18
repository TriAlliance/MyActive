#import <Foundation/Foundation.h>
@import HealthKit;
#import "HKHealthStore+AAPLExtensions.h"

typedef void (^MyDashData)(NSMutableDictionary* responseDict);

@interface HKManager : NSObject {
    HKHealthStore *store;
    
}

+ (HKManager *)sharedManager;


-(void)GraphDashWithInfo:(void(^)(NSMutableDictionary* dictDashData,
                                  NSError *error))completion;
- (void)authorizeWithCompletion:(void (^)(NSError *error))compeltion;
- (void)storeHeartBeatsAtMinute:(double)beats
                     startDate:(NSDate *)startDate endDate:(NSDate *)endDate
                    completion:(void (^)(NSError *error))compeltion;
- (void)saveWeightIntoHealthStore:(NSString *)weight
                       completion:(void (^)(NSError *error))compeltion;

- (void)fetchMostRecentDataOfQuantityType:(HKQuantityType *)quantityType withCompletion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion ;

- (void)fetchTotalBasalBurn:(void(^)(HKQuantity *basalEnergyBurn, NSError *error))completion ;
@end


@interface NSError (HKManager)
@property (readonly) NSString *hkManagerErrorMessage;
+ (NSError *)hkManagerErrorWithMessage:(NSString *)errorMessage;

@end
