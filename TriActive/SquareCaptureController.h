//
//  SquareCaptureController.h
//  Vape_Boss
//

#import <UIKit/UIKit.h>

@protocol CaptureControllerDelegate;

@interface SquareCaptureController : UIViewController{
    
    __weak IBOutlet UIButton *btn_record;
}
@property (weak, nonatomic) id<CaptureControllerDelegate> delegate;

@end

@protocol CaptureControllerDelegate <NSObject>
- (void)captureController:(SquareCaptureController *)controller didFinishPickingVideoAtURL:(NSURL *)url withError:(NSError *)error;
@end
