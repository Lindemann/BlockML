//
//  Document.m
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLDocument.h"
#import "HTMLStringBuilder.h"

@interface HTMLDocument ()

@property (nonatomic, strong) NSMutableArray *errors;

@end

static NSString *const BLOCKML = @"<!--\n    ____  __           __   __  _____\n   / __ )/ /___  _____/ /__/  |/  / /\n  / __  / / __ \\/ ___/ //_/ /|_/ / /\n / /_/ / / /_/ / /__/ ,< / /  / / /___\n/_____/_/\\____/\\___/_/|_/_/  /_/_____/\n\n-->\n";

@implementation HTMLDocument

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"BlockML ▲ ▲ ▲ ";
        self.errors = [NSMutableArray new];
    }
    return self;
}

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    
    [result appendString:[HTMLStringBuilder openTag:@"!DOCTYPE html" attributes:nil indentation:0 lineBreak:YES]];
    [result appendString:BLOCKML];
    [result appendString:[HTMLStringBuilder openTag:@"html" attributes:nil indentation:0 lineBreak:YES]];
    [result appendString:[HTMLStringBuilder openTag:@"head" attributes:nil indentation:1 lineBreak:YES]];
    [result appendString:[HTMLStringBuilder
                          openTag:@"meta"
                          attributes:@{@"http-equiv": @"Content-Type",
                                       @"content": @"text/html; charset=UTF-8"}
                          indentation:2
                          lineBreak:YES]];
    [result appendString:[HTMLStringBuilder
                          openTag:@"meta"
                          attributes:@{@"name": @"viewport",
                                       @"content": @"width=device-width, initial-scale=1, maximum-scale=1"}
                          indentation:2
                          lineBreak:YES]];
    [result appendString:[HTMLStringBuilder
                          openTag:@"link"
                          attributes:@{HREF: @"images/favicon.ico",
                                       @"type": @"image/x-icon",
                                       @"rel": @"icon"}
                          indentation:2
                          lineBreak:YES]];
    [result appendString:[HTMLStringBuilder
                          openTag:@"link"
                          attributes:@{HREF: @"css/screen.css",
                                       @"type": @"text/css",
                                       @"rel": @"stylesheet",
                                       @"media": @"screen"}
                          indentation:2
                          lineBreak:YES]];
    [result appendString:[HTMLStringBuilder
                          openTag:@"link"
                          attributes:@{HREF: @"css/print.css",
                                       @"type": @"text/css",
                                       @"rel": @"stylesheet",
                                       @"media": @"print"}
                          indentation:2
                          lineBreak:YES]];
    if (self.highlight) {
        [result appendString:[HTMLStringBuilder
                              openTag:@"link"
                              attributes:@{HREF: @"highlight.js/styles/github.css",
                                           @"type": @"text/css",
                                           @"rel": @"stylesheet",
                                           @"media": @"screen"}
                              indentation:2
                              lineBreak:YES]];
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:@{@"src": @"highlight.js/highlight.pack.js"} indentation:2 lineBreak:NO]];
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:0 lineBreak:YES]];
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:nil indentation:2 lineBreak:NO]];
        [result appendString:[HTMLStringBuilder text:@"hljs.initHighlightingOnLoad();" indentation:NO lineBreak:NO]];
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:0 lineBreak:YES]];
    }
    if (self.mathJax) {
        ;
    }
    [result appendString:[HTMLStringBuilder openTag:@"title" attributes:nil indentation:2 lineBreak:NO]];
    [result appendString:[HTMLStringBuilder text:self.title indentation:NO lineBreak:NO]];
    [result appendString:[HTMLStringBuilder closingTag:@"title" indentation:0 lineBreak:YES]];
    
    [result appendString:[HTMLStringBuilder closingTag:@"head" indentation:1 lineBreak:YES]];
    [result appendString:[HTMLStringBuilder openTag:@"body" attributes:nil indentation:1 lineBreak:YES]];

    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"body" indentation:1 lineBreak:YES]];
    [result appendString:[HTMLStringBuilder closingTag:@"html" indentation:0 lineBreak:NO]];
    return result;
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                     ASSEMBLY HTML                                            */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Assembly HTML

- (void)generateHTML {
    [self assemblyNumbering:self];
    [self addErrorMessage];
    [self formatHTMLString:self];
    
    // Write Content to File
    [self.htmlString appendString:self.openTag];
    [self assemblyHTMLString:self];
    [self.htmlString appendString:self.closeTag];
    NSString *content = self.htmlString;
    [content writeToURL:self.HTMLURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)formatHTMLString:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            
            if ([element.parent isKindOfClass:[HTMLDocument class]] ||
                [element.parent isKindOfClass:[Section class]] ||
                [element.parent isKindOfClass:[TableOfContent class]] ||
                [element.parent isKindOfClass:[UnorderedList class]] ||
                [element.parent isKindOfClass:[OrderedList class]]) {
                element.closingTagLineBreak = YES;
                // +1 for body tag
                element.openTagIndentation = element.parentCount + 1;
            }
            if ([element isKindOfClass:[Section class]] ||
                [element isKindOfClass:[TableOfContent class]] ||
                [element isKindOfClass:[UnorderedList class]] ||
                [element isKindOfClass:[OrderedList class]] ||
                [element isKindOfClass:[Image class]]) {
                element.openTagLineBreak = YES;
                element.closingTagLineBreak = YES;
                // +1 for body tag
                element.openTagIndentation = element.parentCount + 1;
                element.closingTagIndentation = element.parentCount + 1;
            }
            
            [self formatHTMLString:element];
        }
    }
}

- (void)assemblyHTMLString:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            [element.htmlString appendString:element.openTag];
            
            [self assemblyHTMLString:element];
            
            if (element.closeTag) {
                [element.htmlString appendString:element.closeTag];
            }
            
            [root.htmlString appendString:element.htmlString];
        }
    }
}

- (void)assemblyNumbering:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        int sectionIndex = 1;
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            
            if ([element isKindOfClass:[Section class]]) {
                // Section index
                Section *section = (Section*)element;
                section.sectionIndex = sectionIndex;
                ++sectionIndex;
                
                // Section heading level
                Heading *heading = [section.elements objectAtIndex:0];
                heading.level = section.headingLevel;
                
                // Add section number to heading
                Text *text = [heading.elements objectAtIndex:0];
                NSMutableString *numberedHeadingString = [NSMutableString stringWithFormat:@"%@ %@", section.sectionNumber, text.string];
                text.string = numberedHeadingString;
                
                // TOC
                if (self.tableOfContent) {
                    UnorderedList *unorderedList = [UnorderedList new];
                    ListItem *listItem = [ListItem new];
                    // Set heading
                    Text *TOCHeadingText = [Text new];
                    TOCHeadingText.string = numberedHeadingString;
                    [unorderedList addElement:listItem];
                    Span *outerHeadingSpan = [Span new];
                    Span *innerHeadingSpan = [Span new];
                    [outerHeadingSpan addElement:innerHeadingSpan];
                    [innerHeadingSpan addElement:TOCHeadingText];
                    [listItem addElement:outerHeadingSpan];
                    // Set link
                    Link *link = [Link new];
                    link.href = [NSString stringWithFormat:@"#sec-%@", section.sectionNumber];
                    Text *linkText = [Text new];
                    Span *linkSpan = [Span new];
                    linkText.string = @"[⚐]";
                    [linkSpan addElement:linkText];
                    [link addElement:linkSpan];
                    [listItem addElement:link];
                    
                    // Assambly TOC
                    int TOCLevel = heading.level - 1;
                    if (TOCLevel == 0) {
                        [self.tableOfContent addElement:unorderedList];
                    } else {
                        UnorderedList *parentList = [self lastElementOfTOCForLevel:TOCLevel];
                        [parentList addElement:unorderedList];
                    }
                }
            }
            
            // Errors
            if ([element isKindOfClass:[Error class]]) {
                Error *error = (Error*)element;
                [self.errors addObject:error];
                error.count = self.errors.count;
            }
            
            
            
            
            
            
            
            
            
            [self assemblyNumbering:element];
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           HELPER                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Helper

- (UnorderedList*)lastElementOfTOCForLevel:(int)level {
    UnorderedList *root = [self.tableOfContent.elements lastObject];
    // Loop starts at level 1 because root is already on level 1
    // Loop ends at level-1 because new element became added to level-1
    for (int i = 1; i < level; ++i) {
        root = [root.elements lastObject];
    }
    return root;
}

- (void)addErrorMessage {
    if (self.errors.count) {
        Error *error = [Error new];
        Text *text = [Text new];
        [error addElement:text];
        error.parent = self;
        [self.elements insertObject:error atIndex:0];
        
        if (self.errors.count == 1) {
            text.string = @"1 Error found!";
        } else {
            text.string = [NSString  stringWithFormat:@"%lu Errors found!", (unsigned long)self.errors.count];
        }
        for (int i = 0; i < self.errors.count; ++i) {
            LineBreak *lineBreak = [LineBreak new];
            [error addElement:lineBreak];
            Link *link = [Link new];
            link.href = [NSString  stringWithFormat:@"#error-%d",i+1];
            Text *subText = [Text new];
            Error *currentError = [self.errors objectAtIndex:i];
            subText.string = [[currentError.elements objectAtIndex:0] string];
            [link addElement:subText];
            [error addElement:link];
        }
    }
}

@end
