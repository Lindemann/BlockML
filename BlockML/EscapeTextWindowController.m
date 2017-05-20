//
//  EscapeTextWindowController.m
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "EscapeTextWindowController.h"

@interface EscapeTextWindowController ()

@end

@implementation EscapeTextWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.input.delegate = self;
    self.output.delegate = self;
}

-(void)textDidChange:(NSNotification *)notification {
    NSTextView *textView = [notification object];
    if (textView == self.input) {
        [self escapeSquareBrackets];
    }
    if (textView == self.output) {
        [self unEscapeSquareBrackets];
    }
}

- (void)escapeSquareBrackets {
    self.output.string = [self.input.string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    self.output.string = [self.output.string stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
    self.output.string = [self.output.string stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
}

- (void)unEscapeSquareBrackets {
    self.input.string = [self.output.string stringByReplacingOccurrencesOfString:@"\\]" withString:@"]"];
    self.input.string = [self.input.string stringByReplacingOccurrencesOfString:@"\\[" withString:@"["];
    self.input.string = [self.input.string stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
}


@end
