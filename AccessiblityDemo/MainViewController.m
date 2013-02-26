//
//  RightViewController.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "MainViewController.h"
#import "ColorPalette.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kCellMargin = 15.0;

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat currentHeight = kCellMargin;
    NSInteger count = [colorPalette.colors count];
    NSInteger row = 0;
    CGFloat cellSide = (CGRectGetWidth(self.view.bounds)-kCellMargin)/count - kCellMargin;
    while (currentHeight < CGRectGetHeight(self.view.bounds)) {
        ++row;
        for (NSInteger column = 0; column<count; ++column) {
            UIView *cell = [UIView new];
            cell.backgroundColor = [colorPalette randomColor];
            
            cell.isAccessibilityElement = YES;
            cell.accessibilityLabel = [NSString stringWithFormat:@"Row: %d, Column: %d", row, column+1];
            
            cell.frame = CGRectMake(column*(kCellMargin+cellSide)+kCellMargin, currentHeight, cellSide, cellSide);
            
            cell.layer.shadowColor = [UIColor blackColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            cell.layer.shadowOpacity = 0.75;
            cell.layer.shadowRadius = 3.0;
            CGPathRef shadowPath = CGPathCreateWithRect(cell.bounds, NULL);
            cell.layer.shadowPath = shadowPath;
            CGPathRelease(shadowPath);
            
            [self.view addSubview:cell];
        }
        currentHeight += cellSide+kCellMargin;
    }
}



@end
