//
//  Heading.m
//  BlockMLLight
//
//  Created by Lindemann on 20.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Heading.h"

@implementation Heading

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    
    [result appendString:[HTMLStringBuilder openTag:[NSString stringWithFormat:@"h%d", self.level] attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:[NSString stringWithFormat:@"h%d", self.level] indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

- (int)level {
    if (_level > 6) {
        return 6;
    }
    if (_level < 1) {
        return 1;
    }
    return _level;
}

@end
