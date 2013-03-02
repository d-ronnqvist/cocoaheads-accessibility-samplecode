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

@property (nonatomic, strong) UIView *slidingContainerView;

@end

@implementation SlideInController

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
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSlideInButton:)
                                                 name:UIAccessibilityVoiceOverStatusChanged
                                               object:nil];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.262 alpha:1.000];
}

- (void)updateSlideInButton:(NSNotification *)notification {
    if (UIAccessibilityIsVoiceOverRunning()) {
        // Add if not already there (shouldn't happen)
        if (![self.slideInButton isDescendantOfView:self.view]) {
            [self.view insertSubview:self.slideInButton
                        belowSubview:self.slidingContainerView];
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

- (void)userDidSwipeLeft:(UISwipeGestureRecognizer *)swipe {
    [self slideOut];
}

- (void)userDidSwipeRight:(UISwipeGestureRecognizer *)swipe {
    [self slideIn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateSlideInButton:nil];
    
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

- (void)slideIn {
    self.mainController.view.isAccessibilityElement = YES;
    self.mainController.view.accessibilityLabel = @"Dismiss";
    self.mainController.view.accessibilityHint = @"Double tap to dismiss color palette.";
    self.slidingController.view.accessibilityViewIsModal = YES;
    self.slidingContainerView.hidden = NO;
    self.slidingContainerView.accessibilityViewIsModal = YES;
//    self.slidingController.view.accessibilityViewIsModal = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slidingContainerView.frame = [self slidingFrameOnScreen:YES];
        self.mainController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                        self.slidingController.view);             // Select view that slid in
    }];
}

- (void)slideOut {
//    self.mainController.view.isAccessibilityElement = NO;
    self.slidingContainerView.accessibilityViewIsModal = NO;
//    self.slidingController.view.accessibilityViewIsModal = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slidingContainerView.frame = [self slidingFrameOnScreen:NO];
        self.mainController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.slidingContainerView.hidden = YES;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, // Screen changed
                                        self.slideInButton);                      // Select slide in button
    }];
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
