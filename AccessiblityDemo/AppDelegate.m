//
//  AppDelegate.m
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


//     _  _  ___ _____ ___   _   _____ _                  _               _   _    _
//    | \| |/ _ \_   _| __| (_) |_   _| |_  ___ _ _ ___  (_)___  _ _  ___| |_| |_ (_)_ _  __ _
//    | .` | (_) || | | _|   _    | | | ' \/ -_) '_/ -_) | (_-< | ' \/ _ \  _| ' \| | ' \/ _` |
//    |_|\_|\___/ |_| |___| (_)   |_| |_||_\___|_| \___| |_/__/ |_||_\___/\__|_||_|_|_||_\__, |
//          __            _             __           _   _             _                 |___/
//     ___ / _| __ ____ _| |_  _ ___   / _|___ _ _  | |_| |_  ___   __| |___ _ __  ___  | |_  ___ _ _ ___
//    / _ \  _| \ V / _` | | || / -_) |  _/ _ \ '_| |  _| ' \/ -_) / _` / -_) '  \/ _ \ | ' \/ -_) '_/ -_)
//    \___/_|    \_/\__,_|_|\_,_\___| |_| \___/_|    \__|_||_\___| \__,_\___|_|_|_\___/ |_||_\___|_| \___|
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
