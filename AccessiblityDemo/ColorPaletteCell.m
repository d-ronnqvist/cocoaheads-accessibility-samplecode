//
//  ColorPaletteCell.m
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
