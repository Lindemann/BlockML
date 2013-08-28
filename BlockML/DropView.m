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
//        [self registerForDraggedTypes:@[NSURLPboardType]];
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
//    return NSDragOperationCopy;
    return NSDragOperationGeneric;
}

//- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
//    return YES;
//}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pastboard = [sender draggingPasteboard];
    NSURL *URL = [NSURL URLFromPasteboard:pastboard];

    if (![URL.pathExtension isEqualToString:@"txt"]) {
        return NO;
    }
    
    AppDelegate *appDelegate = [NSApp delegate];
    appDelegate.fileURL = URL;
    [appDelegate processFile];
    
    return YES;
}

//- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
//    [self setNeedsDisplay:YES];
//}

@end
