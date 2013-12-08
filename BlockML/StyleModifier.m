//
//  StyleModifier.m
//  BlockMLLight
//
//  Created by Lindemann on 05.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "StyleModifier.h"

@implementation StyleModifier

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    
    NSString *styleString;
    switch (self.style) {
        case MARKED:
            styleString = @"marked";
            break;
        case BOLD:
            styleString = @"bold";
            break;
        case CODE:
            styleString = @"code";
            break;
        case ITALIC:
            styleString = @"italic";
            break;
        case UNDERLINE:
            styleString = @"underline";
            break;
        case STRIKETHROUGH:
            styleString = @"strikethrough";
            break;
        case SUB:
            styleString = @"sub";
            break;
        case SUP:
            styleString = @"sup";
            break;
            
        default:
            break;
    }
    
    [self.attributes setValue:styleString forKey:CLASS];
    
    [result appendString:[HTMLStringBuilder openTag:SPAN attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:SPAN indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
