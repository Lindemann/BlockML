//
//  HTMLElement.m
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@implementation HTMLElement

- (id)init {
    if (self = [super init]) {
        self.elements = [NSMutableArray new];
        self.htmlString = [NSMutableString string];
    }
    return self;
}

- (void)addElement:(HTMLElement*)element {
    [self.elements addObject:element];
    element.parent = self;
}

- (void)removeElement:(HTMLElement*)element {
    [self.elements removeObject:element];
    element.parent = nil;
}

- (int)parentCount {
    return [self calculateParentCount:self withCounter:0];
}

- (int)calculateParentCount:(HTMLElement*)currentElement withCounter:(int)counter {
    int i = counter;
    if (currentElement.parent) {
        i = [self calculateParentCount:currentElement.parent withCounter:counter + 1];
    }
    return i;
}

@end
