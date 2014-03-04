//
//  Scanner.m
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "Scanner.h"

@interface Scanner()

@property (nonatomic, strong) Token *token;
@property (nonatomic) int scannerLocation;
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableArray *stringList;
@property (nonatomic, strong) NSMutableArray *openTags;
@property (nonatomic) int lastAndProbablyStillOpenTag;
@property (nonatomic) BOOL commentIsOpen;
@property (nonatomic) int backslashCounter;

@end

@implementation Scanner

- (id)initWithString:(NSString*)string {
    if(self = [super init]) {
        self.token = [Token new];
        self.string = string;
        self.currentString = [NSMutableString new];
        self.stringList = [Token stringList];
        self.openTags = [NSMutableArray new];
    }
    return self;
}

+ (id)scannerWithString:(NSString*)string {
    return [[Scanner alloc]initWithString:string];
}

- (Token *)getToken {
    while (self.scannerLocation < self.string.length) {
        [self readNextCharacter];
        
        // Yes...all these special cases must become exactly handeled in this order!
        if ([self isImmutableContentString]) {
            continue;
        }
        if ([self isEscapedBracket]) {
            continue;
        }
        if ([self isWhiteSpace]) {
            continue;
        }
        if ([self isComment]) {
            continue;
        }
        if ([self isWhiteSpaceInList]) {
            continue;
        }
        if ([self isListItemDash]) {
            continue;
        }
        if ([self isPreCommentString]) {
            [self unescapeSquareBracketsAndEscapeHTMLSymbols];
            return self.token;
        }
        if ([self isKeyword]) {
            return self.token;
        }
        if ([self isString]) {
            [self unescapeSquareBracketsAndEscapeHTMLSymbols];
            return self.token;
        }
    }
    if ([self isParagraph]) {
        [self unescapeSquareBracketsAndEscapeHTMLSymbols];
        return self.token;
    }
    self.token.type = END;
    return self.token;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            CASES                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Cases

- (BOOL)isString {
    if (self.commentIsOpen) {
        return NO;
    }
    NSString *searchString;
    for (NSArray *element in self.stringList) {
        searchString = [Token stringForStringListElement:element];
        if ([self.currentString hasSuffix:searchString] && ![self.currentString isEqual:searchString]) {
            self.token.type = STRING;
            NSRange stringRange = {0, self.currentString.length - searchString.length};
            self.token.value = [self.currentString substringWithRange:stringRange];
            _scannerLocation = _scannerLocation - (int)searchString.length;
            self.currentString = [NSMutableString new];
            return YES;
        }
    }
    return NO;
}

- (BOOL)isKeyword {
    if (self.commentIsOpen) {
        return NO;
    }
    NSString *searchString;
    for (NSArray *element in self.stringList) {
        searchString = [Token stringForStringListElement:element];
        if ([self.currentString isEqual:searchString]) {
            TokenType tokenType = [Token tokenTypeForStringListElement:element];
            self.token.type = tokenType;
            self.currentString = [NSMutableString new];
            [self manageOpenTagsWithElement:element];
            return YES;
        }
    }
    return NO;
}

- (BOOL)isParagraph {
    // Returns pure strings without any markup elements
    if (self.currentString.length > 0) {
        self.token.type = STRING;
        self.token.value = self.currentString;
        self.currentString = [NSMutableString new];
        return YES;
    }
    return  NO;
}

- (BOOL)isEscapedBracket {
    [self countBackslashes];
    NSString *ESCAPED_OPEN_SB = @"\\[";
    NSString *ESCAPED_CLOSE_SB = @"\\]";
    if ([self.currentString hasSuffix:ESCAPED_OPEN_SB] || [self.currentString hasSuffix:ESCAPED_CLOSE_SB]) {
        if (self.backslashCounter % 2 == 0) {
            self.backslashCounter = 0;
            return NO;
        }
        self.backslashCounter = 0;
        return YES;
    }
    return NO;
}

- (BOOL)isImmutableContentString {
    if ([self isImmutableContentTag]) {
        NSMutableArray *searchStringList = [NSMutableArray new];
        [searchStringList addObject:@"/*"];
        [searchStringList addObject:@"*/"];
        [searchStringList addObject:@"\n"];
        for (NSString *searchString in searchStringList) {
            if ([self.currentString hasSuffix:searchString] || [self.currentString isEqual:searchString]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)isWhiteSpace {
    // Don't change this strings
    if ([self isImmutableContentTag]) {
        return NO;
    }
    // Inline Tags must be handeled like strings
    // Don't removes the whitespaces after inline tags
    // Because they are like whitespace between two strings
    if ([self isProbablyInlineTag]) {
        return NO;
    }
    // Remove strings which contains only a LF
    // Except when the last token is a string or a LF
    // Because that indicates a new line or a new paragraph
    // 1 LF -> New Line
    // > 2 LFs -> New Paragraph
    if (self.token.type != STRING && self.token.type != LF) {
        NSString *LF = @"\n";
        if ([self.currentString isEqual:LF]) {
            self.currentString = [NSMutableString new];
            return YES;
        }
    }
    // Remove leading TABs or SPACEs
    NSString *SPACE = @" ";
    NSString *TAB = @"\t";
    if ([self.currentString isEqual:SPACE] || [self.currentString isEqual:TAB]) {
        self.currentString = [NSMutableString new];
        return YES;
    }
    return NO;
}

- (BOOL)isPreCommentString {
    // Example: Foo /*...
    // Returns the string Foo 
    NSString *OPEN_COM = @"/*";
    if ([self.currentString hasSuffix:OPEN_COM]) {
        self.token.type = STRING;
        NSRange stringRange = {0, self.currentString.length - OPEN_COM.length};
        self.token.value = [self.currentString substringWithRange:stringRange];
        _scannerLocation = _scannerLocation - (int)OPEN_COM.length;
        self.currentString = [NSMutableString new];
        return YES;
    }
    return NO;
}

- (BOOL)isComment {
    NSString *OPEN_COM = @"/*";
    NSString *CLOSE_COM = @"*/";
    if ([self.currentString isEqual:OPEN_COM] || [self.currentString isEqual:CLOSE_COM]) {
        if ([self.currentString isEqual:OPEN_COM]) {
            self.commentIsOpen = YES;
        }
        if ([self.currentString isEqual:CLOSE_COM]) {
            self.commentIsOpen = NO;
            // Nifty tweak for correct whitepace removal
            self.token.type = 666;
        }
        self.currentString = [NSMutableString new];
        return YES;
    }
    if ([self.currentString hasSuffix:CLOSE_COM]) {
        self.currentString = [NSMutableString new];
        _scannerLocation = _scannerLocation - (int)CLOSE_COM.length;
        return YES;
    }
    return NO;
}

- (BOOL)isWhiteSpaceInList {
    // Don't remove whitespace after an inline tag in an item
    if (([self isList] && ![self isProbablyInlineTag]) ||
        // Remove whitspace infront of an item
        // when a LF has indicated that the previous item is closed
        ([self isList] && self.token.type == LF)) {

        // Remove leading TABs or SPACEs
        NSString *SPACE = @" ";
        NSString *TAB = @"\t";
        if ([self.currentString isEqual:SPACE] || [self.currentString isEqual:TAB]) {
            self.currentString = [NSMutableString new];
            return YES;
        }
    }
    return NO;
}

- (BOOL)isListItemDash {
    // Removes dashes infront of a list item
    if ([self isList]) {
        
        // Don't remove dashes from an item text
        // e.g - c[foo]-bar
        if ([self isProbablyInlineTag] && self.token.type != LF) {
            return NO;
        }
        
        NSString *DASH = @"-";
        if ([self.currentString isEqual:DASH]) {
            self.currentString = [NSMutableString new];
            return YES;
        }
    }
   
    return NO;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           HELPER                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Helper

- (BOOL)isList {
    if ([[self.openTags lastObject] intValue] == OL_SB ||
        [[self.openTags lastObject] intValue] == UL_SB) {
        return YES;
    }
    return NO;
}

- (BOOL)isProbablyInlineTag {
    if (self.lastAndProbablyStillOpenTag >= A_SB && self.lastAndProbablyStillOpenTag <= ID_SB) {
        return YES;
    }
    return NO;
}

- (void)readNextCharacter {
    // range.location must become assigned every time again
    NSRange range = {self.scannerLocation, 1};
    _scannerLocation++;
    [self.currentString appendString:[self.string substringWithRange:range]];
}

- (BOOL)element:(NSArray*)element hasTokenType:(TokenType)tokenType {
    if ([Token tokenTypeForStringListElement:element] == tokenType) {
        return YES;
    }
    return NO;
}

- (BOOL)isImmutableContentTag {
    // All tags which probably contains content,
    // which should stay in one string and not become divided trough comments or LFs
    // For example a code tag with LFs
    if ([[self.openTags lastObject] intValue] == CODE_SB ||
        [[self.openTags lastObject] intValue] == C_SB ||
        [[self.openTags lastObject] intValue] == MATH_SB ||
        [[self.openTags lastObject] intValue] == IM_SB ||
        [[self.openTags lastObject] intValue] == HTML_SB ||
        [[self.openTags lastObject] intValue] == IH_SB) {
        return YES;
    }
    return NO;
}

- (BOOL)isRealTag:(NSArray*)element {
    if ([self element:element hasTokenType:OPEN_SB] ||
        [self element:element hasTokenType:CLOSE_SB] ||
        [self element:element hasTokenType:LF]) {
        return NO;
    }
    return YES;
}

- (void)manageOpenTagsWithElement:(NSArray*)element {
    // Push all openning tags like "a[" or "code[" on  a stack
    // The stack is sufficent for the "special cases"
    if ([self isRealTag:element]) {
        [self.openTags addObject:[NSNumber numberWithInt:self.token.type]];
        // When a new Tag is open the lastAndProbablyStillOpenTag is definitely closed
        self.lastAndProbablyStillOpenTag = 666;
    }
    // Remove tags from the stack, when the tag became closed by a "]"
    // Preserve tag for the case that he was not really closed like in "a[][]"
    if ([self element:element hasTokenType:CLOSE_SB]) {
        self.lastAndProbablyStillOpenTag = [[self.openTags lastObject] intValue];
        [self.openTags removeLastObject];
    }
    // When a "[" appears it is clear that the tag is still open
    // Push preserved tag back to the stack
    if ([self element:element hasTokenType:OPEN_SB]) {
        [self.openTags addObject:[NSNumber numberWithInt:self.lastAndProbablyStillOpenTag]];
    }
}
// Unescapes backslashes
// \\\\ -> \\
// Removes Backslahes infront of Square Brackets
// \] -> ] and \\] -> \]
// Escape HTML Symbols
// Used for Code and Math
- (void)unescapeSquareBracketsAndEscapeHTMLSymbols {
    
    self.token.value = [self.token.value stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    
    self.token.value = [self.token.value stringByReplacingOccurrencesOfString:@"\\]" withString:@"]"];
    self.token.value = [self.token.value stringByReplacingOccurrencesOfString:@"\\[" withString:@"["];
    
    if (![[self.openTags lastObject] isEqual:[NSNumber numberWithInt:HTML_SB]] &&
        ![[self.openTags lastObject] isEqual:[NSNumber numberWithInt:IH_SB]]) {
        self.token.value = [self.token.value stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        self.token.value = [self.token.value stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    }
}

- (void)countBackslashes {
    // To investigate if a backslash escape a bracket or escape another backslash
    // "\\"-> escape another backslash
    if ([self.currentString hasSuffix:@"\\"]) {
        ++ self.backslashCounter;
        return;
    }
    if ([self.currentString hasSuffix:@"["] || [self.currentString hasSuffix:@"]"]) {
        return;
    }
    self.backslashCounter = 0;
}

@end
