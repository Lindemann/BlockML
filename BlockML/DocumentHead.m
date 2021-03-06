//
//  FrontPage.m
//  BlockMLLight
//
//  Created by Lindemann on 06.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "DocumentHead.h"

@implementation DocumentHead

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"document_head" forKey:CLASS];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

@end
