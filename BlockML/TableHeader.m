//
//  TableHeader.m
//  BlockMLLight
//
//  Created by Lindemann on 04.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "TableHeader.h"

@implementation TableHeader

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"th" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"th" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
