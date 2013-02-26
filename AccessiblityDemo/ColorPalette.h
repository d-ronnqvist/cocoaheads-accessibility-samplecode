//
//  ColorPalette.h
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPalette : NSObject

@property (copy) NSString *name;
@property (copy) NSArray *colors;

- (UIColor *)randomColor;
- (NSArray *)randomizedColors;


- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name
                      colors:(NSArray *)colors;


+ (instancetype)colorPaletteWithGradientWithName:(NSString *)name
                                         fromColor:(UIColor *)fromColor
                                           toColor:(UIColor *)toColor
                                   inNumberOfSteps:(NSUInteger)numberOfSteps;


@end
