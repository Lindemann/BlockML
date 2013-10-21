//
//  EscapeTextWindowController.h
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EscapeTextWindowController : NSWindowController <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *input;
@property (unsafe_unretained) IBOutlet NSTextView *output;
@property (weak) IBOutlet NSSplitView *splitView;

@end
