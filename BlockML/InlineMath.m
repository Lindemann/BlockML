//
//  InlineMath.m
//  BlockML
//
//  Created by Lindemann on 28.02.14.
//  Copyright (c) 2014 Lindemann. All rights reserved.
//

#import "InlineMath.h"

@implementation InlineMath

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"math" forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:SPAN attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:SPAN indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
