//
//  AboutWindowController.m
//  BlockML
//
//  Created by Lindemann on 21.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "AboutWindowController.h"

@interface AboutWindowController ()

@end

@implementation AboutWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    self.versionTextField.stringValue = [NSString stringWithFormat:@"Version %@, Build %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [self.versionTextField setSelectable:YES];
    [self.awwAppsTextField setSelectable:YES];
}

- (IBAction)creditsButtonWasPressed:(id)sender {
    NSURL *url = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Credits/Credits/document.html"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}
@end
