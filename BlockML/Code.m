//
//  Code.m
//  BlockMLLight
//
//  Created by Lindemann on 26.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Code.h"

@implementation Code

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:self.language forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:@"pre" attributes:nil indentation:self.openTagIndentation lineBreak:NO]];
    [result appendString:[HTMLStringBuilder openTag:@"code" attributes:self.attributes indentation:NO lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"code" indentation:self.openTagIndentation lineBreak:NO]];
    [result appendString:[HTMLStringBuilder closingTag:@"pre" indentation:NO lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
