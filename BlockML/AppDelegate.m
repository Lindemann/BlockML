//
//  AppDelegate.m
//  BlockML
//
//  Created by Lindemann on 28.04.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "AppDelegate.h"
#import "EscapeTextWindowController.h"
#import "MainWindowController.h"
#import "DocumentController.h"
#import "AboutWindowController.h"

@interface AppDelegate()

@property (strong) EscapeTextWindowController *escapeTextWindowController;
@property (strong) MainWindowController *mainWindowController;
@property (strong) AboutWindowController *aboutWindowController;

@end

@implementation AppDelegate

- (id)init {
    self = [super init];
    if (self) {
        DocumentController *documentController = [DocumentController new];
        
        if (!self.mainWindowController) {
            self.mainWindowController = [[MainWindowController alloc]initWithWindowNibName:@"Main"];
        }
        [self.mainWindowController showWindow:nil];
        
        documentController.delegate = self.mainWindowController;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.mainWindowController.segmentedControl setMenu:self.openRecentMenuItem forSegment:0];
}

// Reopen window from dock after it was closed
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    [self.mainWindowController.window makeKeyAndOrderFront:nil];
    return YES;
}

- (IBAction)recompileMenuItemWasPressed:(id)sender {
    [self.mainWindowController recompileMenuItemWasPressed:sender];
}

- (IBAction)openEscapeTextWindowMenuItemWasPressed:(id)sender {
    if (!self.escapeTextWindowController) {
        self.escapeTextWindowController = [[EscapeTextWindowController alloc]initWithWindowNibName:@"EscapeText"];
    }
    [self.escapeTextWindowController showWindow:nil];
}

- (IBAction)openHelpMenuItemWasPressed:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://lindemann.github.io/BlockML/"]];
}

- (IBAction)aboutMenuItemWasPressed:(id)sender {
    if (!self.aboutWindowController) {
        self.aboutWindowController = [[AboutWindowController alloc]initWithWindowNibName:@"About"];
    }
    [self.aboutWindowController showWindow:nil];
}

@end
