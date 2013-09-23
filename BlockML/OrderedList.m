//
//  OrderedList.m
//  BlockMLLight
//
//  Created by Lindemann on 21.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "OrderedList.h"

@implementation OrderedList

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"ol" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"ol" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
