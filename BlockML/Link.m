//
//  Link.m
//  BlockMLLight
//
//  Created by Lindemann on 18.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Link.h"

@implementation Link

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    
    if (self.href) {
        self.attributes = [NSMutableDictionary dictionaryWithDictionary:@{HREF: self.href, @"target": @"_blank"}];
    }
    
    [result appendString:[HTMLStringBuilder openTag:@"a" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"a" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
