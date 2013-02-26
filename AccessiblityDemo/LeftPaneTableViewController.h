//
//  LeftViewController.h
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPalette;

typedef void(^LeftPaneSelectionBlock)(ColorPalette *);

@interface LeftPaneTableViewController : UITableViewController

@property (copy) LeftPaneSelectionBlock selectionBlock;

@end
