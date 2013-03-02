//
//  SlideInController.h
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "LeftPaneTableViewController.h"

@interface SlideInController : UIViewController

@property (strong, nonatomic) LeftPaneTableViewController *slidingController;
@property (strong, nonatomic) MainViewController *mainController;

- (void)slideIn;
- (void)slideOut;

@end
