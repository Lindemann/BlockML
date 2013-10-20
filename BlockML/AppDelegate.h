//
//  AppDelegate.h
//  BlockML
//
//  Created by Lindemann on 28.04.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;
//@property (weak) IBOutlet NSProgressIndicator *progessIndicator;
//@property (weak) IBOutlet NSButton *recompileButton;
//@property (weak) IBOutlet NSTextField *fileNameTextField;
//@property (weak) IBOutlet NSMenuItem *recompileMenuItem;
//
//@property (strong) NSURL *fileURL; // Text File
//@property (strong) NSURL *HTMLURL;
//
//- (IBAction)recompileButtonWasPressed:(id)sender;
//- (void)processFile;

@property (weak) IBOutlet NSMenu *openRecentMenuItem;

- (IBAction)recompileMenuItemWasPressed:(id)sender;
- (IBAction)openEscapeTextWindowMenuItemWasPressed:(id)sender;

@end
