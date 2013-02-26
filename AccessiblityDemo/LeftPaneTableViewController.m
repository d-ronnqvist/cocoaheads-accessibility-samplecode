//
//  LeftViewController.m
//  AccessiblityDemo
//
//  Created by David Rönnqvist on 2013-02-25.
//  Copyright (c) 2013 David Rönnqvist. All rights reserved.
//

// This controller is only ment for filling out the demo.
// Nothing of value can be found in this code.

#import "LeftPaneTableViewController.h"
#import "ColorPaletteCell.h"
#import "ColorPalette.h"

static NSString * const kPaletteCellIdentifier = @"PaletteCellIdentifier";

@interface LeftPaneTableViewController ()

@property (strong) NSArray *palettes;

@end

@implementation LeftPaneTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.420 alpha:1.000];
    
    [self.tableView registerClass:[ColorPaletteCell class]
           forCellReuseIdentifier:kPaletteCellIdentifier];
    
    self.palettes = [self arrayOfColorPalettes];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.selectionBlock && self.palettes) {
        self.selectionBlock(self.palettes[0]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.palettes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorPaletteCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaletteCellIdentifier
                                                            forIndexPath:indexPath];
    
    [cell applyStyleAccordingToColorPalette:self.palettes[indexPath.row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectionBlock) {
        self.selectionBlock(self.palettes[indexPath.row]);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Creating some color palettes

- (NSArray *)arrayOfColorPalettes {
    NSMutableArray *palettes = [NSMutableArray new];
    
    
    for (int i = 0; i<4; ++i) {
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Ice" fromColor:[UIColor colorWithRed:0.145 green:0.867 blue:1.000 alpha:1.000] toColor:[UIColor colorWithRed:0.612 green:0.994 blue:1.000 alpha:1.000] inNumberOfSteps:6]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Orange" fromColor:[UIColor orangeColor] toColor:[UIColor whiteColor] inNumberOfSteps:8]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Forrest" fromColor:[UIColor greenColor] toColor:[UIColor brownColor] inNumberOfSteps:5]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Fire" fromColor:[UIColor redColor] toColor:[UIColor yellowColor] inNumberOfSteps:7]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Gray" fromColor:[UIColor blackColor] toColor:[UIColor whiteColor] inNumberOfSteps:9]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Water" fromColor:[UIColor blueColor] toColor:[UIColor cyanColor] inNumberOfSteps:6]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Pink" fromColor:[UIColor colorWithRed:1.000 green:0.628 blue:0.699 alpha:1.000] toColor:[UIColor colorWithRed:1.000 green:0.075 blue:0.899 alpha:1.000] inNumberOfSteps:6]];
        
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Autumn" fromColor:[UIColor colorWithRed:1.000 green:0.604 blue:0.132 alpha:1.000] toColor:[UIColor colorWithRed:1.000 green:0.821 blue:0.363 alpha:1.000] inNumberOfSteps:4]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Lavender" fromColor:[UIColor colorWithRed:0.904 green:0.646 blue:1.000 alpha:1.000] toColor:[UIColor colorWithRed:0.465 green:0.664 blue:1.000 alpha:1.000] inNumberOfSteps:12]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Brown" fromColor:[UIColor colorWithRed:0.387 green:0.221 blue:0.072 alpha:1.000] toColor:[UIColor colorWithRed:0.863 green:0.581 blue:0.296 alpha:1.000] inNumberOfSteps:8]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Sweden" fromColor:[UIColor colorWithRed:1.000 green:0.911 blue:0.000 alpha:1.000] toColor:[UIColor colorWithRed:0.000 green:0.073 blue:1.000 alpha:1.000] inNumberOfSteps:7]];
        
        [palettes addObject:[ColorPalette colorPaletteWithGradientWithName:@"Love" fromColor:[UIColor colorWithRed:0.642 green:0.007 blue:0.000 alpha:1.000] toColor:[UIColor colorWithRed:0.992 green:0.440 blue:1.000 alpha:1.000] inNumberOfSteps:8]];
        
    }
    
    
    
    return [palettes copy];
}

@end
