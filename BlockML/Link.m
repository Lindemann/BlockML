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
    
    [self.attributes setValue:self.href forKey:HREF];
    [self.attributes setValue:@"_blank" forKey:@"target"];
    
    [result appendString:[HTMLStringBuilder openTag:@"a" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"a" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
