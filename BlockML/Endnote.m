//
//  Endnote.m
//  BlockMLLight
//
//  Created by Lindemann on 03.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Endnote.h"
#import "Footnote.h"

@implementation Endnote

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:[NSString  stringWithFormat:@"fn-%d",self.footnote.footnoteNumber] forKey:ID];
    [self.attributes setValue:@"en" forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

- (NSString*)href {
    return [NSString  stringWithFormat:@"#fn-back-%d", self.footnote.footnoteNumber];
}

- (NSString*)linkString {
    return [NSString  stringWithFormat:@"[%d]↩", self.footnote.footnoteNumber];
}

@end
