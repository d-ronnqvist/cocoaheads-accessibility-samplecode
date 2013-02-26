//
//  ColorPaletteCell.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import "ColorPaletteCell.h"
#import "ColorPalette.h"

#import <QuartzCore/QuartzCore.h>

@interface ColorPaletteCell (/*Private*/)

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIView  *paletteView;

@end

@implementation ColorPaletteCell

#pragma mark - Lazy loading

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [UILabel new];
        label.frame = self.contentView.bounds;
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        label.font = [UIFont fontWithName:@"AvenirNext-Medium"
                                     size:30];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
        label.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UIView *)paletteView {
    if (!_paletteView) {
        UIView *view = [UIView new];
        view.frame = self.contentView.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if (_nameLabel) {
            [self.contentView insertSubview:view belowSubview:_nameLabel];
        } else {
            [self.contentView addSubview:view];
        }
        
        _paletteView = view;
    }
    return _paletteView;
}

#pragma mark - Styling

- (void)applyStyleAccordingToColorPalette:(ColorPalette *)colorPalette {
    [[self.paletteView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *colors = colorPalette.randomizedColors;
    CGSize segmentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds)/[colors count],
                                    CGRectGetHeight(self.contentView.bounds));
    for (NSInteger colorIndex = 0; colorIndex < [colors count]; ++colorIndex) {
        UIView *segment = [UIView new];
        segment.backgroundColor = colors[colorIndex];
        segment.frame = CGRectMake(colorIndex*segmentSize.width, 0,
                                   segmentSize.width, segmentSize.height);
        [self.paletteView addSubview:segment];
    }
    
    self.nameLabel.text = colorPalette.name;
    
    [self setNeedsDisplay];
}

#pragma mark - Accessiblity

- (BOOL)isAccessibilityElement {
    return YES;
}

- (NSString *)accessibilityLabel {
    return self.nameLabel.text;
}

- (NSString *)accessibilityHint {
    return [NSString stringWithFormat:@"A palette of %@ colors", self.nameLabel.text];
}

@end
