//
//  AppDelegate.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "AppDelegate.h"

#import "SlideInController.h"
#import "LeftPaneTableViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    SlideInController *slideInController = [SlideInController new];
    slideInController.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    slideInController.mainController = [MainViewController new];
    slideInController.slidingController = [LeftPaneTableViewController new];
    
    self.window.rootViewController = slideInController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
