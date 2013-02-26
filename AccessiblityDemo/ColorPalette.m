//
//  ColorPalette.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "ColorPalette.h"

@implementation ColorPalette

#pragma mark - Init

- (id)init {
    return [self initWithName:nil colors:nil];
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name colors:nil];
}

- (instancetype)initWithName:(NSString *)name
                      colors:(NSArray *)colors {
    self = [super init];
    if (self) {
        _name = name;
        _colors = colors;
    }
    return self;
}

#pragma mark - Random colors

- (UIColor *)randomColor
{
    if (!_colors) return nil;
    
    NSUInteger randomIndex = arc4random() % [self.colors count];
    
    return self.colors[randomIndex];
}

- (NSArray *)randomizedColors
{
    if (!_colors) return nil;
    
    NSMutableArray *mutableColors = [self.colors mutableCopy];
    NSUInteger count = [mutableColors count];
    
    for (NSUInteger index = 0; index < count; ++index) {
        // Select a random element between i and end of array to swap with.
        NSInteger remainingElements = count - index;
        NSInteger newIndex = (arc4random() % remainingElements) + index;
        [mutableColors exchangeObjectAtIndex:index withObjectAtIndex:newIndex];
    }
    
    return [mutableColors copy];
}

#pragma mark - Creating a new palette

+ (instancetype)colorPaletteWithGradientWithName:(NSString *)name
                                       fromColor:(UIColor *)fromColor
                                         toColor:(UIColor *)toColor
                                 inNumberOfSteps:(NSUInteger)numberOfSteps
{
    NSParameterAssert(name);
    NSParameterAssert(fromColor);
    NSParameterAssert(toColor);
    NSParameterAssert(numberOfSteps > 2);
    
    ColorPalette *palette = [[ColorPalette alloc] initWithName:name];
    
    CGFloat startRed = 0.0, startGreen = 0.0, startBlue = 0.0, startAlpha = 0.0;
    CGFloat endRed   = 0.0, endGreen   = 0.0, endBlue   = 0.0, endAlpha   = 0.0;
    
    if (CGColorGetNumberOfComponents(fromColor.CGColor) == 2) {
        CGFloat white = 0.0;
        [fromColor getWhite:&white alpha:&startAlpha];
        startRed = startGreen = startBlue = white; // I know this isn't technically correct due to color calibration.
    } else {
        [fromColor getRed:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];
    }
    if (CGColorGetNumberOfComponents(toColor.CGColor) == 2) {
        CGFloat white = 0.0;
        [toColor getWhite:&white alpha:&endAlpha];
        endRed = endGreen = endBlue = white; // I know this isn't technically correct due to color calibration.
    } else {
        [toColor   getRed:&endRed   green:&endGreen   blue:&endBlue   alpha:&endAlpha];
    }
    
    CGFloat deltaRed   = (endRed   - startRed)   / numberOfSteps;
    CGFloat deltaGreen = (endGreen - startGreen) / numberOfSteps;
    CGFloat deltaBlue  = (endBlue  - startBlue)  / numberOfSteps;
    CGFloat deltaAlpha = (endAlpha - startAlpha) / numberOfSteps;
    
    NSMutableArray *colors = [NSMutableArray new];
    for (NSInteger colorIndex = 0 ; colorIndex < numberOfSteps ; ++colorIndex) {
        UIColor *color = [UIColor colorWithRed:startRed   + colorIndex*deltaRed
                                         green:startGreen + colorIndex*deltaGreen
                                          blue:startBlue  + colorIndex*deltaBlue
                                         alpha:startAlpha + colorIndex*deltaAlpha];
        [colors addObject:color];
    }
    
    palette.colors = colors;
    
    return palette;
}

@end
