//
//  LineBreak.m
//  BlockMLLight
//
//  Created by Lindemann on 15.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "LineBreak.h"

@implementation LineBreak

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"br" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    return nil;
}

@end
