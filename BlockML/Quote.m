//
//  Quote.m
//  BlockMLLight
//
//  Created by Lindemann on 02.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Quote.h"

@implementation Quote

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"quote" forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
