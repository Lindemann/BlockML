//
//  CustomWindow.m
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
    self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
    if (self) {
        
        NSColor *color = [NSColor colorWithCalibratedRed:1.f green:1.f blue:1.f alpha:1.00f];
        [self setBackgroundColor:color];
        
        self.titleBarStartColor     = color;
        self.titleBarEndColor       = color;
        self.baselineSeparatorColor = color;
        
        self.inactiveTitleBarEndColor       = color;
        self.inactiveTitleBarStartColor     = color;
        self.inactiveBaselineSeparatorColor = color;
        
        self.zoomButton = [INWindowButton new];
        self.minimizeButton = [INWindowButton new];
        
        self.centerFullScreenButton = YES;
        self.fullScreenButtonRightMargin = 10;
        
        self.titleBarHeight = 35.0;
        self.trafficLightButtonsLeftMargin = 10;
        
        INWindowButton *closeButton = [INWindowButton windowButtonWithSize:NSMakeSize(15, 15) groupIdentifier:nil];
        closeButton.activeImage = [NSImage imageNamed:@"CloseButton"];
        NSImage *image = [NSImage imageNamed:@"CloseButton"];
        closeButton.activeNotKeyWindowImage = image;
        closeButton.inactiveImage = image;
        closeButton.pressedImage = image;
        closeButton.rolloverImage = image;
        self.closeButton = closeButton;
        
        [self setMovableByWindowBackground:YES];
    }
    return self;
}

@end
