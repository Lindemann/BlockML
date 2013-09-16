//
//  Paragraph.m
//  BlockMLLight
//
//  Created by Lindemann on 13.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Paragraph.h"

@implementation Paragraph

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"p" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"p" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
