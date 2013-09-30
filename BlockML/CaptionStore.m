//
//  DescriptionStore.m
//  BlockMLLight
//
//  Created by Lindemann on 30.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "CaptionStore.h"

@implementation CaptionStore

- (id)init
{
    self = [super init];
    if (self) {
        self.captionsArray = [NSMutableArray new];
    }
    return self;
}

@end
