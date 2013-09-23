//
//  Section.m
//  BlockMLLight
//
//  Created by Lindemann on 20.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Section.h"

@implementation Section

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    [self.attributes setValue:@"sec" forKey:CLASS];
    NSString *IDString = [NSString stringWithFormat:@"sec-%@", self.sectionNumber];
    [self.attributes setValue:IDString forKey:ID];
    [result appendString:[HTMLStringBuilder openTag:DIV attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:DIV indentation:self.closingTagIndentation lineBreak:self.closingTagLineBreak]];
    return result;
}

- (NSString*)sectionNumber {
    if ([self.parent isKindOfClass:[Section class]]) {
        return [NSString stringWithFormat:@"%@.%d", ((Section*)self.parent).sectionNumber, self.sectionIndex];
    } else {
        return [NSString stringWithFormat:@"%d", self.sectionIndex];
    }
}

- (int)headingLevel {
    return [self calculateHeadingLevel:self withCounter:1];
}

- (int)calculateHeadingLevel:(Section*)currentElement withCounter:(int)counter {
    int i = counter;
    if (currentElement.parent && [currentElement.parent isKindOfClass:[Section class]]) {
        i = [self calculateHeadingLevel:(Section*)currentElement.parent withCounter:counter + 1];
    }
    return i;
}

@end
