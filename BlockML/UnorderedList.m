//
//  UnorderedList.m
//  BlockMLLight
//
//  Created by Lindemann on 21.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "UnorderedList.h"

@implementation UnorderedList

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"ul" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"ul" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
