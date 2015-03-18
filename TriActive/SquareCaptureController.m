//

#import "SquareCaptureController.h"
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVFoundation.h>

@interface SquareCaptureController () <AVCaptureFileOutputRecordingDelegate> {
    AVCaptureSession *CaptureSession;
    AVCaptureMovieFileOutput *MovieFileOutput;
    AVCaptureDeviceInput *VideoInputDevice;
}
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) AVCaptureDevice *videoCapture;
@property (strong, nonatomic) IBOutlet UIView *recordingView;
- (IBAction)toogleRecording:(id)sender;
- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)toogleFlash:(id)sender;
- (IBAction)switchCamera:(id)sender;
- (IBAction)cancelCamera:(id)sender;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSUInteger secondsPassed;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation SquareCaptureController
- (void)viewDidLoad {
    [super viewDidLoad];
    [btn_record setFrame:CGRectMake(136,496,55,55)];
    self.isRecording = NO;
    
    self.secondsPassed = 0;
    self.timerLabel.text = @"";
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAndExposeTap:)];
    [self.recordingView addGestureRecognizer:tapRecognizer];

    CaptureSession = [[AVCaptureSession alloc] init];
    
    // video input
    self.videoCapture = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (self.videoCapture)
    {
        NSError *error;
        VideoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:self.videoCapture error:&error];
        if (!error)
        {
            if ([CaptureSession canAddInput:VideoInputDevice])
                [CaptureSession addInput:VideoInputDevice];
            else
                NSLog(@"Couldn't add video input");
        }
        else
        {
            NSLog(@"Couldn't create video input");
        }
    }
    else
    {
        NSLog(@"Couldn't create video capture device");
    }
    
    // audio input
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput)
    {
        [CaptureSession addInput:audioInput];
    } else {
        if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (!granted) {
                    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
                    NSError *error = nil;
                    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
                    if (audioInput)
                    {
                        [CaptureSession addInput:audioInput];
                    }
                }
            }];
        }
    }
    
    
    // previewlayer
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:CaptureSession]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect layerRect = [[[self view] layer] bounds];
    [self.previewLayer setBounds:layerRect];
    [self.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    
    [[self.recordingView layer] addSublayer:self.previewLayer];
       
    
    // output to file
    MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    if ([CaptureSession canAddOutput:MovieFileOutput])
        [CaptureSession addOutput:MovieFileOutput];
    
    [CaptureSession setSessionPreset:AVCaptureSessionPresetMedium];

    
    
    [CaptureSession startRunning];
}

- (void)timerTick:(NSTimer *)timer {
    self.secondsPassed += 1;
    NSUInteger hoursPassed = self.secondsPassed / 3600;
    NSUInteger minsPassed = (self.secondsPassed - hoursPassed *3600) / 60;
    NSUInteger secsPassed = self.secondsPassed - hoursPassed *3600 - minsPassed * 60;
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hoursPassed, minsPassed, secsPassed];
    
    if(secsPassed==12){
        if (self.isRecording) {
            [MovieFileOutput stopRecording];
            [self.timer invalidate];
        }
        self.isRecording = !self.isRecording;

    }
}

- (NSURL *) getOutputUrl{

    return [self getUrlForFile:@"movie.mov"];
}

- (NSURL *) getUrlForFile: (NSString *) fileName {
    // get base video directory
    NSMutableString *fullUrl = [[NSMutableString alloc] initWithString:[self getBasePath]];
    
    // add filename
    [fullUrl appendString:@"/"];
    [fullUrl appendString:fileName];
    
    // return URL
    return [NSURL fileURLWithPath:fullUrl isDirectory:NO];
}

- (NSString *) getBasePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString* videosPath = [[NSString alloc] initWithFormat:@"%@%@", basePath, @"/videos", nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:videosPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return videosPath;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    [self.delegate captureController:self didFinishPickingVideoAtURL:[self getOutputUrl] withError:error];
}


- (IBAction)toogleRecording:(id)sender {
    
    if (self.isRecording) {
        [MovieFileOutput stopRecording];
        ((UIView *)sender).hidden = YES;
        [self.timer invalidate];
    } else {
        self.cancelButton.hidden = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [MovieFileOutput startRecordingToOutputFileURL:[self getOutputUrl] recordingDelegate:self];
    }
    
    self.isRecording = !self.isRecording;
    
    UIButton *senderButton = (UIButton *)sender;
    senderButton.selected = self.isRecording;
}

- (void) focusAtPoint:(CGPoint)point {
    
    AVCaptureDevice *device = self.videoCapture;
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        NSError *error;
        
        if ([device lockForConfiguration:&error]) {
            
            [device setFocusPointOfInterest:point];
            
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            
            [device unlockForConfiguration];
            
        }
    }
    
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint devicePoint = [self.previewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:[gestureRecognizer view]]];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
//    dispatch_async([self sessionQueue], ^{
        AVCaptureDevice *device = self.videoCapture;
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
//    });
}
- (IBAction)toogleFlash:(id)sender {
    AVCaptureDevice *device = [self videoDevice];

    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode: device.torchActive ? AVCaptureTorchModeOff : AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
}

- (IBAction)switchCamera:(id)sender {
    //Change camera source
    if(CaptureSession)
    {
        //Indicate that some changes will be made to the session
        [CaptureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [self videoDeviceInput];
        [CaptureSession removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
        [CaptureSession addInput:newVideoInput];
        
        //Commit all the configuration changes at once
        [CaptureSession commitConfiguration];
    }
}

- (AVCaptureDevice *)videoDevice {
    NSArray *inputs = CaptureSession.inputs;
    AVCaptureDevice *device = nil;
    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *captureDevice = input.device;
        if ([captureDevice hasMediaType:AVMediaTypeVideo]) {
            device = captureDevice;
        }
    }
    
    return device;
}

- (AVCaptureDeviceInput *)videoDeviceInput {
    NSArray *inputs = CaptureSession.inputs;
    AVCaptureDeviceInput *result = nil;
    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *captureDevice = input.device;
        if ([captureDevice hasMediaType:AVMediaTypeVideo]) {
            result = input;
        }
    }
    
    return result;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

- (IBAction)cancelCamera:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
