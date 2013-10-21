//
//  DropView.m
//  BlockML
//
//  Created by Lindemann on 28.04.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "DropView.h"
#import "AppDelegate.h"

@implementation DropView

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingEntered:");
    return NSDragOperationGeneric;
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender {
    NSLog(@"draggingEnded:");
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
    NSLog(@"draggingExited:");
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSLog(@"performDragOperation:");
    NSPasteboard *pastboard = [sender draggingPasteboard];
    NSURL *URL = [NSURL URLFromPasteboard:pastboard];
    if (![URL.pathExtension caseInsensitiveCompare:@"txt"] == NSOrderedSame &&
        ![URL.pathExtension caseInsensitiveCompare:@"blockml"] == NSOrderedSame) {
        return NO;
    }
    [self.delegate dropedFileWithURL:URL];
    return YES;
}

@end
