//
//  SlideInController.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in the
// Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "SlideInController.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kSlidingFrameWidth = 320.0;

@interface SlideInController ()

@property (assign) CGFloat startX;
@property (strong, nonatomic) UIButton *slideInButton;

@property (nonatomic, strong) UIView *slidingContainerView;

@end

@implementation SlideInController

/// DEMO-6: (Responing to the escape gesture)
- (BOOL)accessibilityPerformEscape {
    [self slideOut];
    return YES;
}

- (UIView *)slidingContainerView {
    if (!_slidingContainerView) {
        _slidingContainerView = [UIView new];
        [self.view addSubview:_slidingContainerView];
    }
    return _slidingContainerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.262 alpha:1.000];
    
    
    /// DEMO-1: (Subscribing to VoiceOver notifications)
    // Observe the VoiceOverStatusChanged notification to know when VoiceOver
    // is turned on or off. This is used to turn on features that only need to
    // be on for VoiceOver and to possibly display new elements on screen.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSlideInButton:)
                                                 name:UIAccessibilityVoiceOverStatusChanged
                                               object:nil];
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIAccessibilityVoiceOverStatusChanged
                                                  object:nil];
}

// This method puts a new button on screen if VoiceOver is on
// and removes it if VoiceOver is off. The button is used as
// a replacement for a swipe gesture.
- (void)updateSlideInButton:(NSNotification *)notification {
    // Check if VoiceOver is running
    /// DEMO-2: (Checking if VoiceOver is on)
    if (UIAccessibilityIsVoiceOverRunning()) {
        // VoiceOver is on so the replacement button should show
        
        // Add button, if not already there otherwise bring it to front
        if (![self.slideInButton isDescendantOfView:self.view]) {
            [self.view insertSubview:self.slideInButton
                        belowSubview:self.slidingContainerView];
        } else {
            [self.view bringSubviewToFront:self.slideInButton];
        }
        // Select the new button.
        /// DEMO-3: (Informing the user about new items on screen)
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification,
                                        self.slideInButton);
    } else {
        // Remove (since VoiceOver is off)
        [self.slideInButton removeFromSuperview];
    }
}

- (void)slideIn {
    // Notify the user that the screen changed and select the new view
    /// DEMO-4: (Informing the user about complete screen changes)
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                    self.slidingController.view);             // Select view that slid in
    
    // Make the container "modal" so that swiping the next element
    // Won't take you to the main view (which is visually obscured)
    /// DEMO-5: (Making sibling views unreachable)
    self.slidingContainerView.accessibilityViewIsModal = YES;
    
    // Actual sliding animation ...
    [UIView animateWithDuration:0.3 animations:^{
        self.slidingContainerView.frame = [self slidingFrameOnScreen:YES];
        self.mainController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
}

- (void)slideOut {
    // Notifiy the user that the screen changed and select something
    // that will be on screen (the slide in view will slide out).
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                    self.slideInButton);                      // Select slide in button
    
    // Make the container not modal again so that the main view
    // can be selected again.
    self.slidingContainerView.accessibilityViewIsModal = NO;
    
    // Actual sliding animation ..
    [UIView animateWithDuration:0.3 animations:^{
        self.slidingContainerView.frame = [self slidingFrameOnScreen:NO];
        self.mainController.view.transform = CGAffineTransformIdentity;
    }];
}


//     _  _  ___ _____ ___   _   _____ _                  _               _   _    _
//    | \| |/ _ \_   _| __| (_) |_   _| |_  ___ _ _ ___  (_)___  _ _  ___| |_| |_ (_)_ _  __ _
//    | .` | (_) || | | _|   _    | | | ' \/ -_) '_/ -_) | (_-< | ' \/ _ \  _| ' \| | ' \/ _` |
//    |_|\_|\___/ |_| |___| (_)   |_| |_||_\___|_| \___| |_/__/ |_||_\___/\__|_||_|_|_||_\__, |
//          __            _             __           _   _             _                 |___/
//     ___ / _| __ ____ _| |_  _ ___   / _|___ _ _  | |_| |_  ___   __| |___ _ __  ___
//    / _ \  _| \ V / _` | | || / -_) |  _/ _ \ '_| |  _| ' \/ -_) / _` / -_) '  \/ _ \
//    \___/_|    \_/\__,_|_|\_,_\___| |_| \___/_|    \__|_||_\___| \__,_\___|_|_|_\___/
//           __ _             _   _    _                _     _
//     __ _ / _| |_ ___ _ _  | |_| |_ (_)___  _ __  ___(_)_ _| |_
//    / _` |  _|  _/ -_) '_| |  _| ' \| (_-< | '_ \/ _ \ | ' \  _|  _ _ _
//    \__,_|_|  \__\___|_|    \__|_||_|_/__/ | .__/\___/_|_||_\__| (_|_|_)
//                                           |_|

#pragma mark -

- (UIButton *)slideInButton {
    if (!_slideInButton) {
        UIButton *slideInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        slideInButton.isAccessibilityElement = YES;                              // Even though there is some VoiceOver code
        slideInButton.accessibilityLabel = @"Slide in";                          // here, it is not considered a main part
        slideInButton.accessibilityHint = @"Slide in a list of color palettes."; // of the demo and is otherwise to long and
        slideInButton.frame = CGRectMake(30, 30, 90, 70);                        // more a distraction ...
        
        CALayer *layer = slideInButton.layer;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOffset = CGSizeMake(0.0, 1.0);
        layer.shadowOpacity = 0.5;
        layer.shadowRadius = 2.0;
        layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:layer.bounds
                                                      cornerRadius:10.0].CGPath;;

        layer.cornerRadius = 10.0;
        
        // Draw gradient
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0);
        CGFloat colors [] = {
            0.88, 1.0,
            0.67, 1.0
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        CGContextAddPath(context, layer.shadowPath);
        CGContextClip(context);
        
        CGPoint startPoint = CGPointMake(0, 0);
        CGPoint endPoint   = CGPointMake(0, CGRectGetHeight(layer.bounds));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // End of drawing
        
        
        layer.borderWidth = 1.0;
        layer.borderColor = [UIColor colorWithWhite:0.421 alpha:1.000].CGColor;

        [slideInButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [slideInButton setImage:[UIImage imageNamed:@"slideInButton"] forState:UIControlStateNormal];
        
        [slideInButton addTarget:self
                          action:@selector(slideIn)
                forControlEvents:UIControlEventTouchUpInside];
        
        _slideInButton = slideInButton;
    }
    return _slideInButton;
}

- (void)userDidSwipeLeft:(UISwipeGestureRecognizer *)swipe {
    [self slideOut];
}

- (void)userDidSwipeRight:(UISwipeGestureRecognizer *)swipe {
    [self slideIn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    if ([self.view.gestureRecognizers count] == 0) {
        
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(userDidSwipeLeft:)];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(userDidSwipeRight:)];
        right.direction = UISwipeGestureRecognizerDirectionRight;
        
        
        [self.view addGestureRecognizer:left];
        [self.view addGestureRecognizer:right];
        
    }
    
    if (_slidingContainerView) {
        _slidingContainerView.frame = [self slidingFrameOnScreen:NO];
    }
    if (self.mainController) {
        self.mainController.view.frame = self.view.bounds;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateSlideInButton:nil];
}

- (void)userDidTap:(UITapGestureRecognizer *)tap {
    if (CGRectGetMaxX(self.slidingContainerView.frame) <= 0) return;
    
    [self slideOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMainController:(MainViewController *)mainController {
    [self addChildViewController:mainController];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(userDidTap:)];
    [mainController.view addGestureRecognizer:tap];
    
    _mainController = mainController;
    
    if (self.slidingController) {
        [self.view insertSubview:mainController.view belowSubview:self.slidingContainerView];
    } else {
        [self.view addSubview:mainController.view];
    }
    
    mainController.view.bounds = self.view.bounds;
    
    CALayer *layer = mainController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.75;
    layer.shadowRadius = 10.0;
    CGPathRef shadowPath = CGPathCreateWithRect(mainController.view.bounds, NULL);
    layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    
    [self setUpSelectionBlock];
    
    [mainController didMoveToParentViewController:self];
}

- (CGRect)slidingFrameOnScreen:(BOOL)onScreen {
    return CGRectMake(onScreen?0:-kSlidingFrameWidth, 0, kSlidingFrameWidth, CGRectGetHeight(self.view.bounds));
}

- (void)setSlidingController:(LeftPaneTableViewController *)slidingController {
    [self addChildViewController:slidingController];
    
    _slidingController = slidingController;
    
    CGRect slidingFrame = [self slidingFrameOnScreen:NO];
    
    [self.slidingContainerView addSubview:slidingController.view];
    self.slidingContainerView.frame = slidingFrame;
    slidingFrame.origin = CGPointZero;
    slidingController.view.frame = slidingFrame;
    
    slidingController.view.clipsToBounds = NO;
    
    CALayer *layer = slidingController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 17.0;
    CGPathRef shadowPath = CGPathCreateWithRect(slidingController.view.bounds, NULL);
    layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);

    [self setUpSelectionBlock];
    
    [slidingController didMoveToParentViewController:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGAffineTransform t = self.mainController.view.transform;
    if (!CGAffineTransformIsIdentity(t)) self.mainController.view.transform = CGAffineTransformIdentity;
    self.mainController.view.frame = self.view.bounds;
    self.mainController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    if (!CGAffineTransformIsIdentity(t)) self.mainController.view.transform = t;
    self.slidingContainerView.frame = [self slidingFrameOnScreen:self.slidingContainerView.accessibilityViewIsModal];
    self.slidingController.view.frame = self.slidingContainerView.bounds;
}

- (void)setUpSelectionBlock {
    if (_mainController && _slidingController) { 
        __weak MainViewController *weakMain = self.mainController;
        __weak SlideInController  *weakSelf = self;
        self.slidingController.selectionBlock = ^(ColorPalette *palette) {
            [weakSelf slideOut];
            weakMain.colorPalette = palette;
        };
    }
}

@end
