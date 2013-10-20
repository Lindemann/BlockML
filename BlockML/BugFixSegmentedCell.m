//
//  BugFixCell.m
//  BlockML
//
//  Created by Lindemann on 20.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "BugFixSegmentedCell.h"

@implementation BugFixSegmentedCell

- (SEL)action
{
    //this allows connected menu to popup instantly (because no action is returned for menu button)
    if ([self tagForSegment:[self selectedSegment]] == 0) {
        return nil;
    } else {
        return [super action];
    }
}

@end
