//
//  ColorNameFinder.h
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 3/2/13.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorNameFinder : NSObject

- (NSString *)closestColorNameForColor:(UIColor *)color;

@end
