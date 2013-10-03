//
//  Sup.m
//  BlockMLLight
//
//  Created by Lindemann on 03.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Sup.h"

@implementation Sup

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder openTag:@"sup" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"sup" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
