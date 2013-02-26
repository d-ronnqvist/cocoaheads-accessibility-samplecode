//
//  ColorPaletteCell.h
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPalette;
@interface ColorPaletteCell : UITableViewCell

- (void)applyStyleAccordingToColorPalette:(ColorPalette *)colorPalette;

@end
