//
//  MainWindowController.h
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DocumentController.h"
#import "BlockMLDocument.h"
#import "DropView.h"

@interface MainWindowController : NSWindowController <DocumentControllerDelegate, DropViewDelegate>

@property (strong) NSURL *HTMLURL;
@property (strong) BlockMLDocument *currentDocument;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *fileNameTextField;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet DropView *dropView;

- (IBAction)segmentedControlWasPressed:(id)sender;
- (void)recompileMenuItemWasPressed:(id)sender;

@end
