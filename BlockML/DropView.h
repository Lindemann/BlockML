//
//  DropView.h
//  BlockML
//
//  Created by Lindemann on 28.04.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DropViewDelegate;

@interface DropView : NSView <NSDraggingDestination>

@property (weak) id <DropViewDelegate> delegate;

@end

@protocol DropViewDelegate <NSObject>

- (void)dropedFileWithURL:(NSURL*)URL;
- (void)draggingStarted;
- (void)draggingEnded;

@end