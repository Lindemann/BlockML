//
//  Footnote.m
//  BlockMLLight
//
//  Created by Lindemann on 03.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Footnote.h"
#import "Endnote.h"

@implementation Footnote

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:[NSString  stringWithFormat:@"fn-back-%d",self.footnoteNumber] forKey:ID];
    [self.attributes setValue:[NSString  stringWithFormat:@"#fn-%d",self.footnoteNumber] forKey:HREF];
    [result appendString:[HTMLStringBuilder openTag:@"a" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"a" indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

- (void)setEndnote:(Endnote *)endnote {
    _endnote = endnote;
    _endnote.footnote = self;
    
}

- (NSString*)linkString {
    return [NSString  stringWithFormat:@"[%d]", self.footnoteNumber];
}

@end
