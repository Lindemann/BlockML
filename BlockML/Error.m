//
//  Error.m
//  BlockMLLight
//
//  Created by Lindemann on 23.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Error.h"

@implementation Error

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"error" forKey:CLASS];
    NSString *IDString = [NSString stringWithFormat:@"error-%d", self.count];
    [self.attributes setValue:IDString forKey:ID];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
