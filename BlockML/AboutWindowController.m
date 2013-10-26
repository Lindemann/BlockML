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
    
//    [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//    
//    NSMutableAttributedString *version = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BlockML V %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];
//    [version addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:54] range:NSMakeRange(0, 7)];
//    self.versionTextField.attributedStringValue = version;
    
    self.versionTextField.stringValue = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

- (IBAction)creditsButtonWasPressed:(id)sender {
    NSURL *url = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Credits/Credits/document.html"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}
@end
