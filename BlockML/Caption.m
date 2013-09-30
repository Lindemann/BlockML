//
//  Caption.m
//  BlockMLLight
//
//  Created by Lindemann on 29.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Caption.h"

@implementation Caption

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"cap" forKey:CLASS];
    if (self.identfier) {
        [self.attributes setValue:[NSString  stringWithFormat:@"id-%@",self.identfier] forKey:ID];
    }
    [result appendString:[HTMLStringBuilder openTag:@"div" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"div" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}
@end
