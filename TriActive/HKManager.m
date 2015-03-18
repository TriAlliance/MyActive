
#import "HKManager.h"


static NSString *kHKManagerErrorDomain = @"HKManagerErrorDomain";
static NSString *kHKManagerErrorMessageKey = @"HKManagerErrorMessageKey";
NSMutableDictionary * dictDashData;

#pragma mark - Custom unit

@interface HKUnit (HKManager)
+ (HKUnit *)heartBeatsPerMinuteUnit;

@end

@implementation HKUnit (HKManager)

+ (HKUnit *)heartBeatsPerMinuteUnit {
    return [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
}

@end
#pragma mark - Custom error

@implementation NSError (HKManager)

- (NSString *)hkManagerErrorMessage {
    return self.userInfo[kHKManagerErrorMessageKey];
}
+ (NSError *)hkManagerErrorWithMessage:(NSString *)errorMessage {
    return
    [NSError errorWithDomain:kHKManagerErrorDomain code:0 userInfo:@{kHKManagerErrorMessageKey: errorMessage}];
}
@end


#pragma mark - HKManager singleton functinality

@implementation HKManager

+ (instancetype)sharedManager {
    static HKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [HKManager new];
    });
    return manager;
}

#pragma mark - Authorizations
- (void)authorizeWithCompletion:(void (^)(NSError *error))completion {
    if(![HKHealthStore isHealthDataAvailable]) {
        if(completion) {
            completion([NSError hkManagerErrorWithMessage:@"This device has not support HealthKit"]);
        }
        return;
    }
    
    if(!store) {
        store = [HKHealthStore new];
    }
    dictDashData  = [[NSMutableDictionary alloc]init];
    [store requestAuthorizationToShareTypes:[self shareTypes]
                                  readTypes:[self readTypes] completion:^(BOOL success, NSError *error) {
                                      if(error && completion) {
                                          completion([NSError hkManagerErrorWithMessage:error.localizedDescription]);
                                      }
                                      else{
                                          [self updatedietaryCalorie];
                                          [self updateWeight];
                                          [self updateBMR];
                                          [self updateUsersBMI];
                                          [self updateUsersCalories ];
                                          [self updateUserBodyFats];
                                         // [self getSleepCompletion:^(double heartRate, NSError *error) {
                                              
                                          //}];
                                          MALog(@"sucess in request healthkit==%@",dictDashData);
                                      }
                                  }];
}
#pragma mark - HealthKit Permissions

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)shareTypes {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, nil];
    
}

- (NSSet *)readTypes {
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *BasalEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    
    HKQuantityType *BMI=[HKObjectType quantityTypeForIdentifier:
                         HKQuantityTypeIdentifierBodyMassIndex];
    HKQuantityType *BodyFats=[HKObjectType quantityTypeForIdentifier:
                              HKQuantityTypeIdentifierBodyFatPercentage];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
   HKCategoryType *sleepAnalysisType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, BasalEnergyBurnType,heightType, weightType, birthdayType, biologicalSexType,BMI,BodyFats,sleepAnalysisType, nil];
}

#pragma mark - Beats tracker

- (void)storeHeartBeatsAtMinute:(double)beats
                      startDate:(NSDate *)startDate endDate:(NSDate *)endDate
                     completion:(void (^)(NSError *error))compeltion
{
    HKQuantityType *rateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKQuantity *rateQuantity = [HKQuantity quantityWithUnit:[HKUnit heartBeatsPerMinuteUnit]
                                                doubleValue:(double)beats];
    HKQuantitySample *rateSample = [HKQuantitySample quantitySampleWithType:rateType
                                                                   quantity:rateQuantity
                                                                  startDate:startDate
                                                                    endDate:endDate];
    
    [store saveObject:rateSample withCompletion:^(BOOL success, NSError *error) {
        if(compeltion) {
            compeltion(error);
        }
    }];
    MALog(@"%@healtdata",store);
}
#pragma mark - Get Heart Rate

- (void)getSleepCompletion:(void (^)(double heartRate, NSError *error))compeltion {
    // Fetch user's default height unit in inches.
    
    HKCategoryType *heartRateType= [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    // Query to get the user's latest height, if it exists.
    [self fetchMostRecentDataOfQuantityTypes:heartRateType withCompletion:^(HKCategoryType *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"Either an error occured fetching the user's height information or none has been stored yet. In your app, try to handle this gracefully.");
            compeltion(0,error);
        }
        else {
            // Determine the height in the required unit.
            //            HKUnit *heartRateUnit = [HKUnit heartBeatsPerMinuteUnit];
            //            double usersHeartRate = [mostRecentQuantity doubleValueForUnit:heartRateUnit];
            //            compeltion(usersHeartRate,nil);
            
        }
    }];
}
// Get the single most recent quantity sample from health store.
- (void)fetchMostRecentDataOfQuantityTypes:(HKCategoryType *)quantityType withCompletion:(void (^)(HKCategoryType *mostRecentQuantity, NSError *error))completion {
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    //    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:nil options:HKStatisticsOptionDiscreteAverage completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
    //        if (!result) {
    //            if (completion) {
    //                completion(nil, error);
    //            }
    //            return;
    //        }
    //
    //        if (completion) {
    //            // If quantity isn't in the database, return nil in the completion block.
    //            // HKQuantitySample *quantitySample = results.firstObject;
    //            HKQuantity *quantity = result.averageQuantity;
    //            completion(quantity, error);
    //        }
    //    }];
    HKCategorySample *sample;
    id VALUE=  [sample valueForKey:HKCategoryTypeIdentifierSleepAnalysis];
    NSLog(@"%@",VALUE);
}
- (void)saveWeightIntoHealthStore:(NSString *)weight
                       completion:(void (^)(NSError *error))compeltion{
    
    if (weight) {
        // Save the user's weight into HealthKit.
        HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
        
        HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:[HKUnit poundUnit] doubleValue:[weight doubleValue] ];
        HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:[NSDate date] endDate:[NSDate date]];
        MALog(@"weightSample===%@",weightSample);
        [store saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"An error occured saving the weight sample %@. In your app, try to handle this gracefully. The error was: %@.", weightSample, error);
                abort();
            }
        }];
    }
    
}

#pragma mark - Using HealthKit API

- (void)updateUsersCalories {
    
    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
    // Query to get the user's latest height, if it exists.
    [self fetchMostRecentDataOfQuantityType:dietaryCalorieEnergyType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"No calorie available %@.", error);
            //abort();
        }
        // Determine the height in the required unit.
        double userscalories = 0.0;
        if (mostRecentQuantity) {
            HKUnit *caloriesUnit = [HKUnit kilocalorieUnit];
            userscalories = [mostRecentQuantity doubleValueForUnit:caloriesUnit];
            // Update the user interface.
            dispatch_async(dispatch_get_main_queue(), ^{
                [dictDashData setValue:[NSString stringWithFormat:@"%.2f",userscalories] forKey:@"HK_dietaryCalories"];
                
            });
        }
    }];
}
- (void)updateUsersBMI{
    [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    
    HKQuantityType *BMI=[HKObjectType quantityTypeForIdentifier:
                         HKQuantityTypeIdentifierBodyMassIndex];
    
    // Query to get the user's latest height, if it exists.
    [self fetchMostRecentDataOfQuantityType:BMI withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"No calorie available %@.", error);
            //abort();
        }
        // Determine the height in the required unit.
        
        if (mostRecentQuantity) {
            NSLog(@"BMI %@.", mostRecentQuantity);
           [dictDashData setValue:[NSString stringWithFormat:@"%@",mostRecentQuantity] forKey:@"HK_BMI"];        }
    }];
}

- (void)updateUsersActiveEnergyBurn{
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    // Query to get the user's latest height, if it exists.
    [self fetchMostRecentDataOfQuantityType:activeEnergyBurnType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"No ActiveEnergyBurn available %@.", error);
            //abort();
        }
        // Determine the height in the required unit.
        
        if (mostRecentQuantity) {
            NSLog(@"ActiveEnergyBurn %@.", mostRecentQuantity);
            //
        }
    }];
}
-(void) updateUserBodyFats{
HKQuantityType *BodyFats=[HKObjectType quantityTypeForIdentifier:
                          HKQuantityTypeIdentifierBodyFatPercentage];
// Query to get the user's latest height, if it exists.
[self fetchMostRecentDataOfQuantityType:BodyFats withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
    if (error) {
        NSLog(@"No calorie available %@.", error);
        
    }
    // Determine the height in the required unit.
    
    if (mostRecentQuantity) {
       
        if (mostRecentQuantity) {
          dispatch_async(dispatch_get_main_queue(), ^{
               [dictDashData setValue:[NSString stringWithFormat:@"%@",mostRecentQuantity] forKey:@"HK_bodyFats"];
              
            });
        }
   }
  }];
}
- (void)updateUsersRestEnergyBurn {
    HKQuantityType *BasalEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    // Query to get the user's latest height, if it exists.
    [self fetchMostRecentDataOfQuantityType:BasalEnergyBurnType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (error) {
            NSLog(@"Body fats not  available %@.", error);
            //abort();
        }
        // Determine the height in the required unit.
        if (mostRecentQuantity) {
            NSLog(@"BodyFats %@.", mostRecentQuantity);
           [dictDashData setValue:[NSString stringWithFormat:@"%@",mostRecentQuantity] forKey:@"HK_Basal"];
            
        }
        
    }];
}
- (void)updatedietaryCalorie{
HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
// Query to get the user's latest height, if it exists.
[self fetchMostRecentDataOfQuantityType:dietaryCalorieEnergyType withCompletion:^(HKQuantity *mostRecentQuantity, NSError *error) {
    if (error) {
        NSLog(@"No calorie available %@.", error);
        [dictDashData setValue:@"" forKey:@"HK_dietaryCalories"];
    }
    // Determine the height in the required unit.
    double userscalories = 0.0;
    if (mostRecentQuantity) {
        HKUnit *caloriesUnit = [HKUnit kilocalorieUnit];
        userscalories = [mostRecentQuantity doubleValueForUnit:caloriesUnit];
        // Update the user interface.
        dispatch_async(dispatch_get_main_queue(), ^{
            if(userscalories){
                [dictDashData setValue:[NSString stringWithFormat:@"%.2f",userscalories] forKey:@"HK_dietaryCalories"];
            }
        });
    }
}];
}
- (void)updateBMR{
    // Last, calculate the user's basal energy burn so far today.
    [self fetchTotalBasalBurn:^(HKQuantity *basalEnergyBurn, NSError *error) {
        
        if (error) {
            NSLog(@"An error occurred trying to compute the basal energy burn. In your app, handle this gracefully. Error: %@", error);
        }
        // Update the UI with all of the fetched values.
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"dictDashData  ===%@",dictDashData);
            NSLog(@"restingEnergyBurned: %@", basalEnergyBurn);
        });
    }];
}
// Get the single most recent quantity sample from health store.
- (void)fetchMostRecentDataOfQuantityType:(HKQuantityType *)quantityType withCompletion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion {
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (completion && error) {
            completion(nil, error);
            return;
        }
        // If quantity isn't in the database, return nil in the completion block.
        HKQuantitySample *quantitySample = results.firstObject;
        HKQuantity *quantity = quantitySample.quantity;
        if (completion) completion(quantity, error);
    }];
    [store executeQuery:query];
}

/// Returns BMR value in kilocalories per day. Note that there are different ways of calculating the

/// BMR. In this example we chose an arbitrary function to calculate //BMR based on weight, height, age,and biological sex.

- (double)calculateBMRFromWeight:(double)weightInKilograms height:(double)heightInCentimeters age:(NSUInteger)ageInYears biologicalSex:(HKBiologicalSex)biologicalSex {
    
    double BMR;
    
    // The BMR equation is different between males and females.
    
    if (biologicalSex == HKBiologicalSexMale) {
        
        BMR = 66.0 + (13.8 * weightInKilograms) + (5 * heightInCentimeters) - (6.8 * ageInYears);
    }
    else {
        
        BMR = 655 + (9.6 * weightInKilograms) + (1.8 * heightInCentimeters) - (4.7 * ageInYears);
    }
    return BMR;
    
}

- (HKQuantity *)calculateBasalBurnTodayFromWeight:(HKQuantity *)weight height:(HKQuantity *)height ActiveCalories:(HKQuantity *)ActiveCalories  RestingCalories:(HKQuantity *)RestingCalories dateOfBirth:(NSDate *)dateOfBirth biologicalSex:(HKBiologicalSexObject *)biologicalSex {
    // Only calculate Basal Metabolic Rate (BMR) if we have enough information about the user
    if (!weight || !height || !dateOfBirth || !biologicalSex) {
        return nil;
    }
    
    // Note the difference between calling +unitFromString: vs creating a unit from a string with
    // a given prefix. Both of these are equally valid, however one may be more convenient for a given
    // use case.
    double heightInCentimeters = [height doubleValueForUnit:[HKUnit unitFromString:@"cm"]];
    double weightInKilograms = [weight doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
    HKUnit *caloriesUnit = [HKUnit kilocalorieUnit];
    double ActiveCal = [ActiveCalories doubleValueForUnit:caloriesUnit];
    double RestingCal = [RestingCalories doubleValueForUnit:caloriesUnit];
    
    
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
    NSUInteger ageInYears = ageComponents.year;
    // BMR is calculated in kilocalories per day.
    double BMR = [self calculateBMRFromWeight:weightInKilograms height:heightInCentimeters age:ageInYears biologicalSex:[biologicalSex biologicalSex]];
    
    // Figure out how much of today has completed so we know how many kilocalories the user has burned.
    NSDate *startOfToday = [[NSCalendar currentCalendar] startOfDayForDate:now];
    NSDate *endOfToday = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startOfToday options:0];
    NSTimeInterval secondsInDay = [endOfToday timeIntervalSinceDate:startOfToday];
    double percentOfDayComplete = [now timeIntervalSinceDate:startOfToday] / secondsInDay;
    double kilocaloriesBurned = BMR * percentOfDayComplete;
    
   
    NSUInteger usersAge = [ageComponents year];
    NSString *ageHeightValueString = [NSNumberFormatter localizedStringFromNumber:@(usersAge) numberStyle:NSNumberFormatterNoStyle];
    
    if (biologicalSex) {
        NSString* gender = @"unknown";
        if (biologicalSex.biologicalSex == HKBiologicalSexMale) {
            gender = @"Male";
        } else if (biologicalSex.biologicalSex == HKBiologicalSexFemale) {
            gender = @"Female";
        }
        if(gender){
            [dictDashData setValue:gender forKey:@"HK_biologicalSex"];
        }
        
    }
   if(dateOfBirth){
        [dictDashData setValue:dateOfBirth forKey:@"HK_dateOfBirth"];
    }
    if(ActiveCal){
        [dictDashData setValue:[NSString stringWithFormat:@"%.2f",ActiveCal] forKey:@"HK_ActiveCal"];
    }
    if(ageHeightValueString){
        [dictDashData setValue:ageHeightValueString forKey:@"HK_Age"];
    }
    if(RestingCal){
        [dictDashData setValue:[NSString stringWithFormat:@"%.2f",RestingCal] forKey:@"HK_RestingCal"];
    }
    
    if(heightInCentimeters){
        [dictDashData setValue:[NSString stringWithFormat:@"%.2f", heightInCentimeters]forKey:@"HK_Height"];
    }
    if(kilocaloriesBurned){
        [dictDashData setValue:[NSString stringWithFormat:@"%.2f",kilocaloriesBurned] forKey:@"HK_BMRBurn"];
    }
    if(BMR){
        [dictDashData setValue:[NSString stringWithFormat:@"%.2f",BMR] forKey:@"HK_BMR"];
    }
    NSLog(@"BMR Burn ===%@",[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:kilocaloriesBurned]);
   
    NSLog(@"dictDashData  ===%@",dictDashData);
    [self GraphDashWithInfo:^(NSMutableDictionary *dictDashData, NSError *error){
        
    }];
    return [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:kilocaloriesBurned];
    
}
// Calculates the user's total basal (resting) energy burn based off of their height, weight, age,
// and biological sex. If there is not enough information, return an error.
- (void)fetchTotalBasalBurn:(void(^)(HKQuantity *basalEnergyBurn, NSError *error))completion {
    
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *BasalEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    //HKCategoryType *sleepAnalysisType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    [store aapl_mostRecentQuantitySampleOfType:heightType predicate:nil completion:^(HKQuantity *height, NSError *error) {
        if (!height) {
            completion(nil, error);
            
            return;
        }
        [store aapl_mostRecentQuantitySampleOfType:BasalEnergyBurnType predicate:nil completion:^(HKQuantity *RestingCalories, NSError *error) {
            if (!RestingCalories) {
                completion(nil, error);
                
                return;
            }
            
            [store aapl_mostRecentQuantitySampleOfType:activeEnergyBurnType predicate:nil completion:^(HKQuantity *ActiveCalories, NSError *error) {
                if (!ActiveCalories) {
                    completion(nil, error);
                    
                    return;
                }
                
                [store aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *weight, NSError *error) {
                    if (!weight) {
                        completion(nil, error);
                        
                        return;
                    }
                    NSDate *dateOfBirth = [store dateOfBirthWithError:&error];
                    if (!dateOfBirth) {
                        completion(nil, error);
                        
                        return;
                    }
                    HKBiologicalSexObject *biologicalSexObject = [store biologicalSexWithError:&error];
                    if (!biologicalSexObject) {
                        completion(nil, error);
                        
                        return;
                    }
                 
                    if (!biologicalSexObject) {
                        completion(nil, error);
                        
                        return;
                    }
                    // Once we have pulled all of the information without errors, calculate the user's total basal energy burn
                    HKQuantity *basalEnergyBurn = [self calculateBasalBurnTodayFromWeight:weight height:height ActiveCalories:ActiveCalories RestingCalories:RestingCalories dateOfBirth:dateOfBirth biologicalSex:biologicalSexObject];
                    completion(basalEnergyBurn, nil);
                }];
            }];
        }];
    }];
}
-(void)updateWeight{
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    [store aapl_mostRecentQuantitySampleOfType:weightType predicate:nil completion:^(HKQuantity *weight, NSError *error) {
        if (weight) {
          double weightInKilograms = [weight doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]];
            if(weightInKilograms){
                [dictDashData setValue:[NSString stringWithFormat:@"%.2f", weightInKilograms] forKey:@"HK_Weight"];
            }
        }
    }];
}
-(void)GraphDashWithInfo:(void(^)(NSMutableDictionary* dictDashData,
                                  NSError *error))completion
{
    completion(dictDashData, nil);
}
@end
