//
//  Bibliography.m
//  BlockMLLight
//
//  Created by Lindemann on 02.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Bibliography.h"

@implementation Bibliography

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"bib" forKey:CLASS];
    [self.attributes setValue:[NSString  stringWithFormat:@"id-%@",self.identfier] forKey:ID];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

- (NSString*)href {
    return [NSString  stringWithFormat:@"#bib-%@", _href];
}

- (NSString*)linkString {
    return [NSString  stringWithFormat:@"[%@] ↩", _linkString];
}

@end
