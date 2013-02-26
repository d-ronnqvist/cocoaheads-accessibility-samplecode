//
//  SlideInController.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "SlideInController.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kSlidingFrameWidth = 320.0;

@interface SlideInController ()

@property (assign) CGFloat startX;
@property (strong, nonatomic) UIButton *slideInButton;

@end

@implementation SlideInController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSlideInButton:)
                                                 name:UIAccessibilityVoiceOverStatusChanged
                                               object:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.262 alpha:1.000];
}

- (void)updateSlideInButton:(NSNotification *)notification {
    if (UIAccessibilityIsVoiceOverRunning() || YES) {
        // Add if not already there (shouldn't happen)
        if (![self.slideInButton isDescendantOfView:self.view]) {
            [self.view insertSubview:self.slideInButton
                        belowSubview:self.slidingController.view];
        } else {
            [self.view bringSubviewToFront:self.slideInButton];
        }
    } else {
        // Remove
        [self.slideInButton removeFromSuperview];
    }
}

- (UIButton *)slideInButton {
    if (!_slideInButton) {
        UIButton *slideInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        slideInButton.isAccessibilityElement = YES;
        slideInButton.accessibilityLabel = @"Slide in";
        slideInButton.accessibilityHint = @"Slide in a palette of colors.";
        slideInButton.frame = CGRectMake(30, 30, 90, 70);
        
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
//        layer.backgroundColor = [UIColor colorWithRed:0.458 green:0.589 blue:0.700 alpha:1.000].CGColor;

        [slideInButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [slideInButton setImage:[UIImage imageNamed:@"slideInButton"] forState:UIControlStateNormal];
        
        [slideInButton addTarget:self
                          action:@selector(slideIn)
                forControlEvents:UIControlEventTouchUpInside];
        
        _slideInButton = slideInButton;
    }
    return _slideInButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateSlideInButton:nil];
    
    if ([self.view.gestureRecognizers count] == 0) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(userDidPan:)];
        [self.view addGestureRecognizer:pan];
        
    }
    
    if (self.slidingController) {
        self.slidingController.view.frame = [self slidingFrameOnScreen:NO];
    }
    if (self.mainController) {
        self.mainController.view.frame = self.view.bounds;
    }
}

- (void)slideIn {
    self.mainController.view.isAccessibilityElement = YES;
    self.mainController.view.accessibilityLabel = @"Dismiss";
    self.mainController.view.accessibilityHint = @"Double tap to dismiss color palette.";
    self.slidingController.view.accessibilityViewIsModal = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (CGAffineTransformIsIdentity(self.slidingController.view.transform)) {
            self.slidingController.view.frame = [self slidingFrameOnScreen:YES];
        } else {
            self.slidingController.view.transform = CGAffineTransformIdentity;
        }
        self.mainController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                        self.slidingController.view);             // Select view that slid in
    }];
}

- (void)slideOut {
    self.mainController.view.isAccessibilityElement = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (CGAffineTransformIsIdentity(self.slidingController.view.transform)) {
            self.slidingController.view.frame = [self slidingFrameOnScreen:NO];
        } else {
            self.slidingController.view.transform = CGAffineTransformIdentity;
        }
        self.mainController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                        self.slideInButton);                      // Select slide in button
    }];
}

- (void)userDidTap:(UITapGestureRecognizer *)tap {
    if (CGRectGetMaxX(self.slidingController.view.frame) <= 0) return;
    
    [self slideOut];
}

- (void)userDidPan:(UIPanGestureRecognizer *)pan {
    CGPoint newPosition = self.slidingController.view.layer.position;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startX = CGRectGetMinX(self.slidingController.view.frame);
        
        CGFloat screenScaleFactor = [UIScreen mainScreen].scale;
        
        self.mainController.view.layer.shouldRasterize = YES;
        self.mainController.view.layer.rasterizationScale = screenScaleFactor;
        
        self.slidingController.view.layer.shouldRasterize = YES;
        self.slidingController.view.layer.rasterizationScale = screenScaleFactor;
    }
    
    CGFloat translation = [pan translationInView:self.view].x;
    CGFloat percentageVisible = MAX(0.0, 1.0+(self.startX+translation)/kSlidingFrameWidth);
    CGFloat scaleFactor = 1.0-pow(percentageVisible,0.75)*0.05;
    self.mainController.view.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    
    CGFloat stretchFactor = MAX(1.0, percentageVisible);
    self.slidingController.view.transform = CGAffineTransformMakeScale(pow(stretchFactor, 0.125), 1.0);
    
//    CGFloat translation = [pan translationInView:self.view].x;
    
    CGFloat newX = MIN(self.startX+translation, 0.0);
    newX = MAX(newX, -kSlidingFrameWidth);
    newPosition.x = newX;
    
//    CGFloat percentageVisible = 1.0+CGRectGetMinX(self.startX+translation)/kSlidingFrameWidth;
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled) {
        
        if (percentageVisible > 0.5) {
            [self slideIn];
        } else {
            [self slideOut];
        }
        return;
    }
    
    self.slidingController.view.layer.position = newPosition;
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
        [self.view insertSubview:mainController.view belowSubview:self.slidingController.view];
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
    slidingController.view.layer.anchorPoint = CGPointMake(0.0, 0.5); // for stretching
    [self.view addSubview:slidingController.view];
    slidingController.view.frame = slidingFrame;
    
    slidingController.view.clipsToBounds = NO;
    
    CALayer *layer = slidingController.view.layer;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 1.0;
    layer.shadowRadius = 7.0;
    CGPathRef shadowPath = CGPathCreateWithRect(slidingController.view.bounds, NULL);
    layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);

    [self setUpSelectionBlock];
    
    [slidingController didMoveToParentViewController:self];
}

- (void)setUpSelectionBlock {
    if (_mainController && _slidingController) { 
        __weak MainViewController *weakMain = self.mainController;
        __weak SlideInController  *weakSelf = self;
        self.slidingController.selectionBlock = ^(ColorPalette *palette) {
            weakMain.colorPalette = palette;
            [weakSelf slideOut];
        };
    }
}

@end
