//
//  HTMLStringBuilder.m
//  HTMLStringBuilder
//
//  Created by Lindemann on 14.08.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLStringBuilder.h"

@implementation HTMLStringBuilder

+ (NSString*)openTag:(NSString*)opentag attributes:(NSDictionary*)attributes indentation:(int)indentation lineBreak:(BOOL)lineBreak {
    NSMutableString* attributesString = [NSMutableString new];
    for (NSString* key in attributes) {
        NSString* value = [attributes objectForKey:key];
        [attributesString appendFormat:@" %@=\"%@\"", key, value];
    }
    NSString* indentationString = [HTMLStringBuilder indentationStringForIndentation:indentation];
    NSMutableString* openTagString = [NSMutableString stringWithFormat:@"%@<%@%@>", indentationString, opentag, attributesString];
    if (lineBreak) {
        [openTagString appendString:@"\n"];
    }
    return openTagString;
}

+ (NSString*)closingTag:(NSString*)closingTag indentation:(int)indentation lineBreak:(BOOL)lineBreak {
    NSString* indentationString = [HTMLStringBuilder indentationStringForIndentation:indentation];
    NSMutableString* closingTagString = [NSMutableString stringWithFormat:@"%@</%@>", indentationString, closingTag];
    if (lineBreak) {
        [closingTagString appendString:@"\n"];
    }
    return closingTagString;
}

+ (NSString*)text:(NSString*)text indentation:(int)indentation lineBreak:(BOOL)lineBreak {
    NSString* indentationString = [HTMLStringBuilder indentationStringForIndentation:indentation];
    NSMutableString* textString = [NSMutableString stringWithFormat:@"%@%@", indentationString, text];
    if (lineBreak) {
        [textString appendString:@"\n"];
    }
    return textString;
}

+ (NSString*)indentationStringForIndentation:(int)indentation {
    NSMutableString* indentationString = [NSMutableString new];
    for (int i = 1; i <= indentation; ++i) {
        [indentationString appendString:@"\t"];
    }
    return indentationString;
}

@end
