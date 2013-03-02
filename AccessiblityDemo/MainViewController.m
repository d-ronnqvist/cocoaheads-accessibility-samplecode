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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.575 alpha:1.000];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setColorPalette:(ColorPalette *)colorPalette {
    if (colorPalette == _colorPalette) return;
    _colorPalette = colorPalette;
    
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    CGFloat currentHeight = 0.0;
    NSInteger count = [colorPalette.colors count];
    NSInteger row = 0;
    CGFloat cellSide = CGRectGetWidth(self.view.bounds)/count;
    
    ColorNameFinder *nameFinder = [ColorNameFinder new];
    
    while (currentHeight < CGRectGetHeight(self.view.bounds)) {
        ++row;
        for (NSInteger column = 0; column<count; ++column) {
            UIView *cell = [UIView new];
            cell.backgroundColor = [colorPalette randomColor];
            
            cell.isAccessibilityElement = YES;
            cell.accessibilityLabel = [nameFinder closestColorNameForColor:cell.backgroundColor];
            
            cell.frame = CGRectMake(column*cellSide, currentHeight, cellSide, cellSide);
            cell.frame = CGRectIntersection(cell.frame, self.view.bounds);
            
            [self.view addSubview:cell];
        }
        currentHeight += cellSide;
    }
    
    self.didPostAccessiblityNotification = YES;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                    [NSString stringWithFormat:@"New color palette is visibel on screen: %@", colorPalette.name]);
    });
}

- (void)announcmentFinished:(NSNotification *)notification {
    if (!self.didPostAccessiblityNotification) return;
    
    NSString *announcment = notification.userInfo[UIAccessibilityAnnouncementKeyStringValue];
    BOOL wasSuccessful = [notification.userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] boolValue];
    
    if (!wasSuccessful) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification,
                                        announcment);
    } else {
        self.didPostAccessiblityNotification = NO;
    }
    
}

@end
