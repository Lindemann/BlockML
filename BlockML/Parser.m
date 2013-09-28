//
//  Parser.m
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "Parser.h"
#import "Scanner.h"
#import "Token.h"
#import "HTMLTree.h"

@interface Parser ()

@property (nonatomic, strong) Scanner *scanner;
@property (nonatomic, strong) Token *token;

@end

@implementation Parser

- (id)initWithString:(NSString*)string {
    if(self = [super init]) {
        self.string = string;
        self.scanner = [Scanner scannerWithString:string];
        self.document = [HTMLDocument new];
    }
    return self;
}

+ (id)parserWithString:(NSString*)string {
    return [[Parser alloc] initWithString:string];
}

- (void)scannerOutput {
    while (self.token.type != END) {
        self.token = [self.scanner getToken];
        NSLog(@"%@", self.token);
    }
}

- (void)startParsing {
    [self scannerOutput];
    
    while (self.token.type != END) {
        self.token = [self.scanner getToken];
        [self documentWithParent:self.document];
    }
    [self.document generateHTML];
    NSLog(@"%@", self.token);
}

- (void)nextToken {
    NSLog(@"%@", self.token);
    self.token = [self.scanner getToken];
}

- (void)errorWithParent:(HTMLElement*)parent andErrorMessage:(NSString*)message {
    Error *error = [Error new];
    Text *text = [Text new];
    text.string = [NSString stringWithFormat:@"Error with %@", message];
    [error addElement:text];
    [parent addElement:error];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                     PRODUCTION RULES                                         */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Production Rules

- (void)documentWithParent:(HTMLElement*)parent {
    // Everything
    while (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= TITLE_SB)) {
        // STRING & Inline Tags
        if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
            Paragraph *paragraph = [Paragraph new];
            [parent addElement:paragraph];
            [self textBlock:paragraph];
        }
        // Block Tags
        [self blockTag:parent];
    }
}

//- (void)bracketsWithParent:(HTMLElement*)parent {
//    // Keep Parsing to find Erros
//    BOOL error;
//    while (self.token.type == OPEN_SB || self.token.type == CLOSE_SB) {
//        error = YES;
//        [self nextToken];
//    }
//    if (error) {
//        [self errorWithParent:parent andErrorMessage:@"Brackets"];
//        error = NO;
//    }
//}

- (void)inlineTag:(HTMLElement*)parent {
    [self link:parent];
    [self inlineCode:parent];
}

- (void)blockTag:(HTMLElement*)parent {
    [self tableOfContent:parent];
    [self section:parent];
    [self title:parent];
    [self code:parent];
    [self image:parent];
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            TEXT                                              */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Text

- (void)textBlock:(HTMLElement*)parent {
    if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
        [self text:parent];
        if (self.token.type == LF) {
            [self nextToken];
            
            // Parent for paragraph depends on from which methode
            // - textBlockWithParent: was invoked
            if ([parent isKindOfClass:[HTMLDocument class]]) {
                [self paragraph:parent];
            } else {
                // Parent is paragraph
                [self paragraph:parent.parent];
            }
            
            if (self.token.type != LF) {
                if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
                    LineBreak *lineBreak = [LineBreak new];
                    [parent addElement:lineBreak];
                }
                [self textBlock:parent];
            }
        }
    }
}

- (void)text:(HTMLElement*)parent {
    if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
        if (self.token.type == STRING) {
            
            Text *text = [Text new];
            [parent addElement:text];
            text.string = self.token.value;
            
            [self nextToken];
        }
        [self inlineTag:parent];
        while (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
            if (self.token.type == STRING) {
                
                Text *text = [Text new];
                [parent addElement:text];
                text.string = self.token.value;
                
                [self nextToken];
            }
            [self inlineTag:parent];
        }
    }
}

- (void)paragraph:(HTMLElement*)parent {
    if (self.token.type == LF) {
        [self nextToken];
        while (self.token.type == LF) {
            [self nextToken];
        }
        
        if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
            
            Paragraph *paragraph = [Paragraph new];
            [parent addElement:paragraph];
            [self textBlock:paragraph];
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         INLINE TAGS                                          */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - INLINE TAGS

- (void)link:(HTMLElement*)parent {
    // a[
    if (self.token.type == A_SB) {
        Link *link = [Link new];
        [parent addElement:link];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            link.href = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // ![
            if (self.token.type != OPEN_SB && link.href) {
                Text *text = [Text new];
                [link addElement:text];
                text.string = link.href;
            }
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // STRING
                if (self.token.type == STRING) {
                    Text *text = [Text new];
                    [link addElement:text];
                    text.string = self.token.value;
                    [self nextToken];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Link"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Link"];
        }
    }
}

- (void)inlineCode:(HTMLElement*)parent {
    // c[
    if (self.token.type == C_SB) {
        InlineCode *inlineCode = [InlineCode new];
        [parent addElement:inlineCode];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = self.token.value;
            [inlineCode addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Inline Code"];
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                          BLOCK TAGS                                          */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Block Tags

- (void)tableOfContent:(HTMLElement*)parent {
    // toc[
    if (self.token.type == TOC_SB) {
        TableOfContent *tableOfContent = [TableOfContent new];
        self.document.tableOfContent = tableOfContent;
        [parent addElement:tableOfContent];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Heading *heading = [Heading new];
            heading.level = 1;
            Text *text = [Text new];
            text.string = self.token.value;
            [heading addElement:text];
            [tableOfContent addElement:heading];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Table of Content"];
        }
    }
}

- (void)section:(HTMLElement*)parent {
    // sec[
    if (self.token.type == SEC_SB) {
        Section *section = [Section new];
        Heading *heading = [Heading new];
        Text *text = [Text new];
        text.string = @"";
        [section addElement:heading];
        [heading addElement:text];
        [parent addElement:section];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            text.string = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // document
                [self documentWithParent:section];
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Section"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Section"];
        }
    }
}

- (void)title:(HTMLElement*)parent {
    // title[
    if (self.token.type == TITLE_SB) {
        Heading *heading = [Heading new];
        heading.level = 1;
        [heading.attributes setValue:@"title" forKey:ID];
        [parent addElement:heading];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = self.token.value;
            [heading addElement:text];
            self.document.title = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Title"];
        }
    }
}

- (void)code:(HTMLElement*)parent {
    // code[
    if (self.token.type == CODE_SB) {
        Code *code = [Code new];
        [parent addElement:code];
        self.document.highlight = YES;
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            code.language = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // STRING
                if (self.token.type == STRING) {
                    Text *text = [Text new];
                    text.string = self.token.value;
                    [code addElement:text];
                    [self nextToken];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Code"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Code"];
        }
    }
}

- (void)image:(HTMLElement*)parent {
    // img[
    if (self.token.type == IMG_SB) {
        Image *image = [Image new];
        [parent addElement:image];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            image.source = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // STRING
                if (self.token.type == STRING) {
                    NSRange searchStringRange = [self.token.value rangeOfString:@"," options:NSCaseInsensitiveSearch];
                    if (searchStringRange.location != NSNotFound) {
                        NSString *tmpIntValue = [[self.token.value componentsSeparatedByString:@","] objectAtIndex:0];
                        image.witdh = [tmpIntValue intValue];
                        tmpIntValue = [[self.token.value componentsSeparatedByString:@","] objectAtIndex:1];
                        image.height = [tmpIntValue intValue];
                    } else {
                        [self errorWithParent:parent andErrorMessage:@"Image"];
                    }
                    [self nextToken];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Image"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Image"];
        }
    }
}

@end
