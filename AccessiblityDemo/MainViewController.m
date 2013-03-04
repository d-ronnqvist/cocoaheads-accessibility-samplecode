//
//  RightViewController.m
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


#import "MainViewController.h"
#import "ColorPalette.h"
#import "ColorNameFinder.h"

@interface MainViewController ()

@property (assign) BOOL didPostAccessiblityNotification;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // Observe AnnouncementDidFinish to know when an announcment finishes
    // and if it succuded or not. This is used to repeat announcements
    // that were aborted.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(announcmentFinished:)
                                                 name:UIAccessibilityAnnouncementDidFinishNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIAccessibilityAnnouncementDidFinishNotification
                                                  object:nil];
}

- (void)refreshColorGrid {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat currentHeight = 0.0;
    NSInteger count = [self.colorPalette.colors count];
    NSInteger row = 0;
    CGFloat cellSide = CGRectGetWidth(self.view.bounds)/count;
    while (cellSide > 150) {
        cellSide/= 2;
        count*=2;
    }
    
    ColorNameFinder *nameFinder = [ColorNameFinder new];
    
    while (currentHeight < CGRectGetHeight(self.view.bounds)) {
        ++row;
        for (NSInteger column = 0; column<count; ++column) {
            UIView *cell = [UIView new];
            cell.backgroundColor = [self.colorPalette randomColor];
            
            // Each cell is configures as it's own element and
            // the name of the closest color is used as the label
            // to provide value to a visully impared user who
            // might not otherwise be able to know anything about
            // the cell which only represents a color.
            cell.isAccessibilityElement = YES; // Make it's own accisisblity element
            cell.accessibilityLabel = [nameFinder closestColorNameForColor:cell.backgroundColor]; // Set the name of the color as the label
            
            cell.frame = CGRectMake(column*cellSide, currentHeight, cellSide, cellSide);
            cell.frame = CGRectIntersection(cell.frame, self.view.bounds);
            
            [self.view addSubview:cell];
        }
        currentHeight += cellSide;
    }
}


- (void)setColorPalette:(ColorPalette *)colorPalette {
    if (colorPalette == _colorPalette) return;
    _colorPalette = colorPalette;
    
    if (![self isViewLoaded]) return;
    
    [self refreshColorGrid];
    
    // Used to know then to care about announcement notifications
    self.didPostAccessiblityNotification = YES;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // It was a better experience to wait a short time before announcing the new color.
        
        // This will use VoiceOver to read the announcement
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                        [NSString stringWithFormat:@"New color palette is visibel on screen: %@", colorPalette.name]);
    });
}

// When an announcement finishes this will get called.
// It is used to possibly repeat announcements.
- (void)announcmentFinished:(NSNotification *)notification {
    if (!self.didPostAccessiblityNotification) return;
    
    // Get the text and if it succeded (read the entire thing) or not
    NSString *announcment = notification.userInfo[UIAccessibilityAnnouncementKeyStringValue];
    BOOL wasSuccessful = [notification.userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] boolValue];
    
    if (!wasSuccessful) {
        // Repost if everything wasn't read.
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                        announcment);
    } else {
        self.didPostAccessiblityNotification = NO;
    }
    
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
//


#pragma mark -

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self refreshColorGrid];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshColorGrid];
}

@end
