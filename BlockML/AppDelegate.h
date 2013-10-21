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

@property (weak) IBOutlet NSMenu *openRecentMenuItem;

- (IBAction)recompileMenuItemWasPressed:(id)sender;
- (IBAction)openEscapeTextWindowMenuItemWasPressed:(id)sender;
- (IBAction)openHelpMenuItemWasPressed:(id)sender;
- (IBAction)aboutMenuItemWasPressed:(id)sender;

@end
