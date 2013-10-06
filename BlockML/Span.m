//
//  Span.m
//  BlockMLLight
//
//  Created by Lindemann on 23.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Span.h"

@implementation Span

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:SPAN attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:SPAN indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
