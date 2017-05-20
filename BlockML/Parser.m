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
//    [self scannerOutput];

//    [Token printAllTokenWithDelimiter:@" "];
    
    while (self.token.type != END) {
        self.token = [self.scanner getToken];
        [self documentWithParent:self.document];
    }
    [self.document generateHTML];
//    NSLog(@"%@", self.token);
}

- (void)nextToken {
//    NSLog(@"%@", self.token);
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
    [self identifier:parent];
    [self inlineMath:parent];
    [self footnote:parent];
    [self styleModifier:parent];
    [self inlineHTML:parent];
}

- (void)blockTag:(HTMLElement*)parent {
    [self tableOfContent:parent];
    [self section:parent];
    [self title:parent];
    [self code:parent];
    [self image:parent];
    [self unorderedList:parent];
    [self orderedList:parent];
    [self caption:parent];
    [self bibliography:parent];
    [self quote:parent];
    [self math:parent];
    
    [self table:parent];
    // Not really Block Tags but keep parsing
    [self tableData:parent];
    [self tableHeader:parent];
    [self tableRow:parent];
    
    [self heading:parent];
    [self head:parent];
    [self pageBreak:parent];
    [self html:parent];
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
            // - textBlock: was invoked
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
#pragma mark - Inline Tags

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

- (void)identifier:(HTMLElement*)parent {
    // id[
    if (self.token.type == ID_SB) {
        Identifier *identifier = [Identifier new];
        [parent addElement:identifier];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            identifier.identfier = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"ID"];
        }
    }
}

- (void)inlineMath:(HTMLElement*)parent {
    // math[
    if (self.token.type == IM_SB) {
        InlineMath *inlineMath = [InlineMath new];
        [parent addElement:inlineMath];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            self.document.mathJax = YES;;
            Text *text = [Text new];
            text.string = self.token.value;
            [inlineMath addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Inline Math"];
        }
    }
}

- (void)footnote:(HTMLElement*)parent {
    // fn[
    if (self.token.type == FN_SB) {
        Footnote *footnote = [Footnote new];
        [parent addElement:footnote];
        [self nextToken];
        // text
        if (self.token.type == STRING) {
            Endnote *endnote = [Endnote new];
            footnote.endnote = endnote;
            // Insert a " " infront of the string
            NSString *tmpValueString = [NSString  stringWithFormat:@" %@",self.token.value];
            self.token.value = tmpValueString;
            [self text:endnote];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Footnote"];
        }
    }
}

- (void)styleModifier:(HTMLElement*)parent {
    // $styleModifier[
    if (self.token.type >= SUB_SB && self.token.type <= U_SB) {
        StyleModifier *styleModifier = [StyleModifier new];
        [parent addElement:styleModifier];
        
        NSString *errorString;
        
        switch (self.token.type) {
            case M_SB:
                styleModifier.style = MARKED;
                errorString = @"Marked Style";
                break;
            case B_SB:
                styleModifier.style = BOLD;
                errorString = @"Bold Style";
                break;
            case U_SB:
                styleModifier.style = UNDERLINE;
                errorString = @"Underline Style";
                break;
            case C_SB:
                styleModifier.style = CODE;
                errorString = @"Inline Code";
                break;
            case I_SB:
                styleModifier.style = ITALIC;
                errorString = @"Italic Style";
                break;
            case S_SB:
                styleModifier.style = STRIKETHROUGH;
                errorString = @"Strikethrough Style";
                break;
            case SUB_SB:
                styleModifier.style = SUB;
                errorString = @"Sub Style";
                break;
            case SUP_SB:
                styleModifier.style = SUP;
                errorString = @"Sup Style";
                break;
            default:
                break;
        }
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = self.token.value;
            
            [styleModifier addElement:text];
            [self nextToken];
            
//            [self text:styleModifier];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:errorString];
        }
    }
}

- (void)inlineHTML:(HTMLElement*)parent {
    // ihtml[
    if (self.token.type == IH_SB) {
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = self.token.value;
            [parent addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Inline HTML"];
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
                    // [
                    if (self.token.type == OPEN_SB) {
                        [self nextToken];
                        // STRING
                        if (self.token.type == STRING) {
                            section.identfier = self.token.value;
                            [self nextToken];
                        }
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
            } else {
                [self errorWithParent:parent andErrorMessage:@"Section"];
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
            } else {
                [self errorWithParent:parent andErrorMessage:@"Code"];
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


- (void)unorderedList:(HTMLElement*)parent {
    // ul[
    if (self.token.type == UL_SB) {
        UnorderedList *unorderedList = [UnorderedList new];
        [parent addElement:unorderedList];
        [self nextToken];
        // STRING | List | LF
        while (self.token.type == STRING ||
               (self.token.type >= A_SB && self.token.type <= ID_SB) ||
               self.token.type == UL_SB || self.token.type == OL_SB ||
               self.token.type == LF) {
            [self listItem:unorderedList];
            [self unorderedList:unorderedList];
            [self orderedList:unorderedList];
            if (self.token.type == LF) {
                [self nextToken];
            }
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Unordered List"];
        }
    }
}

- (void)orderedList:(HTMLElement*)parent {
    // ol[
    if (self.token.type == OL_SB) {
        OrderedList *orderedList = [OrderedList new];
        [parent addElement:orderedList];
        [self nextToken];
        // STRING | List | LF
        while (self.token.type == STRING ||
               (self.token.type >= A_SB && self.token.type <= ID_SB) ||
               self.token.type == UL_SB || self.token.type == OL_SB ||
               self.token.type == LF) {
            [self listItem:orderedList];
            [self unorderedList:orderedList];
            [self orderedList:orderedList];
            if (self.token.type == LF) {
                [self nextToken];
            }
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Ordered List"];
        }
    }

}

- (void)listItem:(HTMLElement*)parent {
    if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
        ListItem *listItem = [ListItem new];
        [parent addElement:listItem];
        [self text:listItem];
    }
}

- (void)caption:(HTMLElement*)parent {
    // caption[
    if (self.token.type == CAP_SB) {
        Caption *caption = [Caption new];
        [parent addElement:caption];
        Span *span = [Span new];
        [caption addElement:span];
        // If cap[]
        caption.captionDescription = @" ";
        [self nextToken];
        // STRING eg. Figure
        if (self.token.type == STRING) {
            caption.captionDescription = self.token.value;
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // text
                [self text:caption];
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                    // [
                    if (self.token.type == OPEN_SB) {
                        [self nextToken];
                        // STRING eg. FDERT
                        if (self.token.type == STRING) {
                            caption.identfier = self.token.value;
                            [self nextToken];
                        }
                        if (self.token.type == CLOSE_SB) {
                            [self nextToken];
                        } else {
                            [self errorWithParent:parent andErrorMessage:@"Caption"];
                        }
                    }
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Caption"];
                }
            } else {
                [self errorWithParent:parent andErrorMessage:@"Caption"];
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Caption"];
        }
    }
}

- (void)bibliography:(HTMLElement*)parent {
    // bib[
    if (self.token.type == BIB_SB) {
        Bibliography *bibliography = [Bibliography new];
        [parent addElement:bibliography];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            bibliography.identfier = self.token.value;
            bibliography.linkString = self.token.value;
            Link *link = [Link new];
            [bibliography addElement:link];
            bibliography.href = self.token.value;
            link.href = bibliography.href;
            Text *text = [Text new];
            text.string = bibliography.linkString;
            [link addElement:text];
            
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // textBlock
                if (self.token.type == STRING) {
                    Paragraph *paragraph = [Paragraph new];
                    [bibliography addElement:paragraph];
                    [self textBlock:paragraph];
                }
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Bibliography"];
                }
            } else {
                [self errorWithParent:parent andErrorMessage:@"Bibliography"];
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Bibliography"];
        }
    }
}

- (void)quote:(HTMLElement*)parent {
    // q[
    if (self.token.type == Q_SB) {
        Quote *quote = [Quote new];
        [parent addElement:quote];
        [self nextToken];
        // textBlock
        if (self.token.type == STRING) {
            Paragraph *paragraph = [Paragraph new];
            [quote addElement:paragraph];
            [self textBlock:paragraph];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // text
                if (self.token.type == STRING) {
                    Source *source = [Source new];
                    [quote addElement:source];
                    [self text:source];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Quote"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Quote"];
        }
    }
}

- (void)math:(HTMLElement*)parent {
    // math[
    if (self.token.type == MATH_SB) {
        Math *math = [Math new];
        [parent addElement:math];
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            self.document.mathJax = YES;
            Text *text = [Text new];
            text.string = self.token.value;
            [math addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Math"];
        }
    }
}

- (void)table:(HTMLElement*)parent {
    // table[
    if (self.token.type == TABLE_SB) {
        Table *table = [Table new];
        [parent addElement:table];
        [self nextToken];
        // tableRow
        while (self.token.type == TR_SB) {
            [self tableRow:table];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Table"];
        }
    }
}

- (void)tableRow:(HTMLElement*)parent {
    // tr[
    if (self.token.type == TR_SB) {
        TableRow *tableRow = [TableRow new];
        [parent addElement:tableRow];
        [self nextToken];
        // TableHeader || TableData
        while (self.token.type == TH_SB ||
               self.token.type == TD_SB) {
            [self tableHeader:tableRow];
            [self tableData:tableRow];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Table Row"];
        }
    }
}

- (void)tableHeader:(HTMLElement*)parent {
    // th[
    if (self.token.type == TH_SB) {
        TableHeader *tableHeader = [TableHeader new];
        [parent addElement:tableHeader];
        [self nextToken];
        // Document
        [self documentWithParent:tableHeader];
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // STRING
                if (self.token.type == STRING) {
                    NSRange searchStringRange = [self.token.value rangeOfString:@":" options:NSCaseInsensitiveSearch];
                    if (searchStringRange.location != NSNotFound) {
                        NSString *tmpIntValue = [[self.token.value componentsSeparatedByString:@":"] objectAtIndex:0];
                        if ([tmpIntValue isEqual:@"v"]) {
                            tableHeader.spanDirection = VERTICAL;
                        }
                        if ([tmpIntValue isEqual:@"h"]) {
                            tableHeader.spanDirection = HORIZONTAL;
                        }
                        tmpIntValue = [[self.token.value componentsSeparatedByString:@":"] objectAtIndex:1];
                        tableHeader.spanWidth = [tmpIntValue intValue];
                    } else {
                        [self errorWithParent:parent andErrorMessage:@"Table Header"];
                    }
                    [self nextToken];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Table Header"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Table Header"];
        }
    }
}

- (void)tableData:(HTMLElement*)parent {
    // td[
    if (self.token.type == TD_SB) {
        TableData *tableData = [TableData new];
        [parent addElement:tableData];
        [self nextToken];
        // Document
        [self documentWithParent:tableData];
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
            // [
            if (self.token.type == OPEN_SB) {
                [self nextToken];
                // STRING
                if (self.token.type == STRING) {
                    NSRange searchStringRange = [self.token.value rangeOfString:@":" options:NSCaseInsensitiveSearch];
                    if (searchStringRange.location != NSNotFound) {
                        NSString *tmpIntValue = [[self.token.value componentsSeparatedByString:@":"] objectAtIndex:0];
                        if ([tmpIntValue isEqual:@"v"]) {
                            tableData.spanDirection = VERTICAL;
                        }
                        if ([tmpIntValue isEqual:@"h"]) {
                            tableData.spanDirection = HORIZONTAL;
                        }
                        tmpIntValue = [[self.token.value componentsSeparatedByString:@":"] objectAtIndex:1];
                        tableData.spanWidth = [tmpIntValue intValue];
                    } else {
                        [self errorWithParent:parent andErrorMessage:@"Table Data"];
                    }
                    [self nextToken];
                }
                // ]
                if (self.token.type == CLOSE_SB) {
                    [self nextToken];
                } else {
                    [self errorWithParent:parent andErrorMessage:@"Table Data"];
                }
            }
        } else {
            [self errorWithParent:parent andErrorMessage:@"Table Data"];
        }
    }
}

- (void)heading:(HTMLElement*)parent {
    // title[
    if (self.token.type >= H1_SB && self.token.type <= H6_SB) {
        Heading *heading = [Heading new];
        [parent addElement:heading];
        switch (self.token.type) {
            case H1_SB:
                heading.level = 1;
                break;
            case H2_SB:
                heading.level = 2;
                break;
            case H3_SB:
                heading.level = 3;
                break;
            case H4_SB:
                heading.level = 4;
                break;
            case H5_SB:
                heading.level = 5;
                break;
            case H6_SB:
                heading.level = 6;
                break;
            default:
                break;
        }
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = self.token.value;
            [heading addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Heading"];
        }
    }
}

- (void)head:(HTMLElement*)parent {
    // fp[
    if (self.token.type == HEAD_SB) {
        DocumentHead *frontPage = [DocumentHead new];
        [parent addElement:frontPage];
        [self nextToken];
        // Heading | Image | Title
        while ((self.token.type >= H1_SB && self.token.type <= H6_SB) ||
               self.token.type == IMG_SB ||
               self.token.type == TITLE_SB) {
            [self heading:frontPage];
            [self image:frontPage];
            [self title:frontPage];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"Front Page"];
        }
    }
}

- (void)pageBreak:(HTMLElement*)parent {
    // pb[
    if (self.token.type == PB_SB) {
        PageBreak *pageBreak = [PageBreak new];
        [parent addElement:pageBreak];
        [self nextToken];
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"TITLE"];
        }
    }
}

- (void)html:(HTMLElement*)parent {
    // html[
    if (self.token.type == HTML_SB) {
        [self nextToken];
        // STRING
        if (self.token.type == STRING) {
            Text *text = [Text new];
            text.string = [HTMLStringBuilder text:self.token.value indentation:0 lineBreak:YES];
            [parent addElement:text];
            [self nextToken];
        }
        // ]
        if (self.token.type == CLOSE_SB) {
            [self nextToken];
        } else {
            [self errorWithParent:parent andErrorMessage:@"HTML"];
        }
    }
}

@end
