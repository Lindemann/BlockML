//
//  Text.m
//  BlockMLLight
//
//  Created by Lindemann on 15.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Text.h"

@implementation Text

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", self.string];
    return result;
}

- (NSString*)closeTag {
    return nil;
}

@end
