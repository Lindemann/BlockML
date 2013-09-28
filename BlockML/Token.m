//
//  Token.m
//  BlockML
//
//  Created by Lindemann on 02.09.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "Token.h"

@implementation Token

- (void)setType:(TokenType)type {
    _type = type;
    if (type != STRING) {
        self.value = nil;
    }
}

- (NSString*)description {
    if (self.type == LF) {
        return @"LF";
    }
    if (self.type == END) {
        return @"END";
    }
    if (self.type != STRING) {
        NSMutableArray *stringList = [Token stringList];
        for (NSArray *element in stringList) {
            if (self.type == [Token tokenTypeForStringListElement:element]) {
                return [Token stringForStringListElement:element];
            }
        }
    }
    return self.value;
}

+ (NSString*)stringForStringListElement:(NSArray*)element {
    return [element objectAtIndex:1];
}

+ (TokenType)tokenTypeForStringListElement:(NSArray*)element {
    return [[element objectAtIndex:0] intValue];
}

+ (NSMutableArray*)stringList {
    NSMutableArray* stringList = [NSMutableArray new];
    
    /* K E Y W O R D */
    /* inline */
    [stringList addObject:@[[NSNumber numberWithInt:A_SB], @"a["]];
//    [stringList addObject:@[[NSNumber numberWithInt:FN_SB], @"fn["]];
//    [stringList addObject:@[[NSNumber numberWithInt:HTML_SB], @"html["]];
    [stringList addObject:@[[NSNumber numberWithInt:C_SB], @"c["]];
//    [stringList addObject:@[[NSNumber numberWithInt:B_SB], @"b["]];
//    [stringList addObject:@[[NSNumber numberWithInt:I_SB], @"i["]];
//    [stringList addObject:@[[NSNumber numberWithInt:U_SB], @"u["]];
//    [stringList addObject:@[[NSNumber numberWithInt:M_SB], @"m["]];
    
    /* block */
    [stringList addObject:@[[NSNumber numberWithInt:CODE_SB], @"code["]];
    [stringList addObject:@[[NSNumber numberWithInt:SEC_SB], @"sec["]];
    [stringList addObject:@[[NSNumber numberWithInt:TOC_SB], @"toc["]];
    [stringList addObject:@[[NSNumber numberWithInt:IMG_SB], @"img["]];
    [stringList addObject:@[[NSNumber numberWithInt:UL_SB], @"ul["]];
    [stringList addObject:@[[NSNumber numberWithInt:OL_SB], @"ol["]];
    [stringList addObject:@[[NSNumber numberWithInt:TITLE_SB], @"title["]];
    
    /* sqare brackets */
    [stringList addObject:@[[NSNumber numberWithInt:OPEN_SB], @"["]];
    [stringList addObject:@[[NSNumber numberWithInt:CLOSE_SB], @"]"]];
    
    /* W H I T S P A C E */
    [stringList addObject:@[[NSNumber numberWithInt:LF], @"\n"]];
    
    return stringList;
}

@end
