//
//  InlineCode.m
//  BlockMLLight
//
//  Created by Lindemann on 26.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "InlineCode.h"

@implementation InlineCode

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"inlineCode" forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:@"code" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"code" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
