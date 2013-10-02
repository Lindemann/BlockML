//
//  Identifier.m
//  BlockMLLight
//
//  Created by Lindemann on 29.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Identifier.h"

@implementation Identifier

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:[NSString  stringWithFormat:@"#id-%@",self.identfier] forKey:HREF];
    if (self.sectionNumber) {
        [self.attributes setValue:[NSString  stringWithFormat:@"#sec-%@",self.sectionNumber] forKey:HREF];
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
