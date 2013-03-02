//
//  RightViewController.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "MainViewController.h"
#import "ColorPalette.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.575 alpha:1.000];
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
    while (currentHeight < CGRectGetHeight(self.view.bounds)) {
        ++row;
        for (NSInteger column = 0; column<count; ++column) {
            UIView *cell = [UIView new];
            cell.backgroundColor = [colorPalette randomColor];
            
            cell.isAccessibilityElement = YES;
            cell.accessibilityLabel = [NSString stringWithFormat:@"Colored cell (row %d, column %d)", row, column+1];
            
            cell.frame = CGRectMake(column*cellSide, currentHeight, cellSide, cellSide);
            cell.frame = CGRectIntersection(cell.frame, self.view.bounds);
            
            [self.view addSubview:cell];
        }
        currentHeight += cellSide;
    }
}


@end
