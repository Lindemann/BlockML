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
@property (nonatomic, strong) NSMutableArray *footnotes;
// Needed for IDs
@property (nonatomic, strong) NSMutableArray *captionsOfSectionsAndDocument;
@property (nonatomic, strong) NSMutableArray *sectionsForIdentifier;
@property (nonatomic, strong) NSMutableArray *bibliographyForIdentifier;

@end

static NSString *const BLOCKML = @"<!--\n    ____  __           __   __  _____\n   / __ )/ /___  _____/ /__/  |/  / /\n  / __  / / __ \\/ ___/ //_/ /|_/ / /\n / /_/ / / /_/ / /__/ ,< / /  / / /___\n/_____/_/\\____/\\___/_/|_/_/  /_/_____/\n\n-->\n";

@implementation HTMLDocument

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"D O C U M E N T";
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
    
//    [result appendString:[HTMLStringBuilder
//                          openTag:@"meta"
//                          attributes:@{@"name": @"viewport",
//                                       @"content": @"width=device-width, initial-scale=1, maximum-scale=1"}
//                          indentation:2
//                          lineBreak:YES]];
    
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
        /*
        // local
        [result appendString:[HTMLStringBuilder
                              openTag:@"link"
                              attributes:@{HREF: @"highlight.js/styles/github.css",
                                           @"type": @"text/css",
                                           @"rel": @"stylesheet",
                                           @"media": @"screen"}
                              indentation:2
                              lineBreak:YES]];
        */
        
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:@{@"src": @"highlight/highlight.pack.js"} indentation:2 lineBreak:NO]];
        
        /*
        // CDN and CSS is called in style.css
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:@{@"src": @"http://yandex.st/highlightjs/7.3/highlight.min.js"} indentation:2 lineBreak:NO]];
        */
        
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:0 lineBreak:YES]];
        
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:nil indentation:2 lineBreak:NO]];
        [result appendString:[HTMLStringBuilder text:@"hljs.tabReplace = '    ';" indentation:0 lineBreak:NO]];
        [result appendString:[HTMLStringBuilder text:@"hljs.initHighlightingOnLoad();" indentation:0 lineBreak:NO]];
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:0 lineBreak:YES]];
    }
    
    if (self.mathJax) {
        //CDN
        [result appendString:[HTMLStringBuilder
                              openTag:@"script"
                              attributes:@{@"type": @"text/javascript",
                                           @"src": @"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"}
                              indentation:2
                              lineBreak:NO]];
        /*
        // Local
        [result appendString:[HTMLStringBuilder
                              openTag:@"script"
                              attributes:@{@"type": @"text/javascript",
                                           @"src": @"MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"}
                              indentation:2
                              lineBreak:NO]];
        */
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:0 lineBreak:YES]];
        
        [result appendString:[HTMLStringBuilder openTag:@"script" attributes:@{@"type": @"text/x-mathjax-config"} indentation:2 lineBreak:YES]];
        [result appendString:[HTMLStringBuilder text:@"MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'],['\\\\(','\\\\)']], processClass: 'math', ignoreClass: 'no-math'}});" indentation:3 lineBreak:YES]];
        [result appendString:[HTMLStringBuilder closingTag:@"script" indentation:2 lineBreak:YES]];
    }
    
    [result appendString:[HTMLStringBuilder openTag:@"title" attributes:nil indentation:2 lineBreak:NO]];
    [result appendString:[HTMLStringBuilder text:self.title indentation:NO lineBreak:NO]];
    [result appendString:[HTMLStringBuilder closingTag:@"title" indentation:0 lineBreak:YES]];
    
    [result appendString:[HTMLStringBuilder closingTag:@"head" indentation:1 lineBreak:YES]];
    
    NSDictionary *bodyAttributes = nil;
    if (self.mathJax) {
        bodyAttributes = @{CLASS: @"no-math"};
    }
    [result appendString:[HTMLStringBuilder openTag:@"body" attributes:bodyAttributes indentation:1 lineBreak:YES]];
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
    [self assemblyCrossReferences:self];
    [self addErrorMessage];
    [self appendEndnotes];
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
                [element.parent isKindOfClass:[OrderedList class]] ||
                [element.parent isKindOfClass:[Quote class]] ||
                [element.parent isKindOfClass:[Bibliography class]] ||
                [element.parent isKindOfClass:[Table class]] ||
                [element.parent isKindOfClass:[TableRow class]] ||
                [element.parent isKindOfClass:[TableHeader class]] ||
                [element.parent isKindOfClass:[TableData class]] ||
                [element.parent isKindOfClass:[DocumentHead class]]) {
                element.closingTagLineBreak = YES;
                // +1 for body tag
                element.openTagIndentation = element.parentCount + 1;
            }
            if ([element isKindOfClass:[Section class]] ||
                [element isKindOfClass:[TableOfContent class]] ||
                [element isKindOfClass:[UnorderedList class]] ||
                [element isKindOfClass:[OrderedList class]] ||
                [element isKindOfClass:[Image class]] ||
                [element isKindOfClass:[Quote class]] ||
                [element isKindOfClass:[Bibliography class]] ||
                [element isKindOfClass:[Table class]] ||
                [element isKindOfClass:[TableRow class]] ||
                [element isKindOfClass:[TableHeader class]] ||
                [element isKindOfClass:[TableData class]] ||
                [element isKindOfClass:[DocumentHead class]]) {
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
                    
                    // Assembly TOC
                    int TOCLevel = heading.level - 1;
                    if (TOCLevel == 0) {
                        [self.tableOfContent addElement:unorderedList];
                    } else {
                        UnorderedList *parentList = [self lastElementOfTOCForLevel:TOCLevel];
                        [parentList addElement:unorderedList];
                    }
                }
                
                // Prepare stuff for captions
                if ([section.parent isKindOfClass:[HTMLDocument class]]) {
                    if (!self.captionsOfSectionsAndDocument) {
                        self.captionsOfSectionsAndDocument = [NSMutableArray new];
                    }
                    Captions *captions = [Captions new];
                    captions.sectionIndex = section.sectionIndex;
                    [self.captionsOfSectionsAndDocument addObject:captions];
                }
                
                // Prepare XRefs for sections
                if (section.identfier) {
                    if (!self.sectionsForIdentifier) {
                        self.sectionsForIdentifier = [NSMutableArray new];
                    }
                    [self.sectionsForIdentifier addObject:section];
                }
            }
            
            // Errors
            if ([element isKindOfClass:[Error class]]) {
                if (!self.errors) {
                    self.errors = [NSMutableArray new];
                }
                Error *error = (Error*)element;
                [self.errors addObject:error];
                error.count = (int)self.errors.count;
            }
            
            // Captions
            if ([element isKindOfClass:[Caption class]]) {
                if (!self.captionsOfSectionsAndDocument) {
                    self.captionsOfSectionsAndDocument = [NSMutableArray new];
                }
                if (self.captionsOfSectionsAndDocument.count == 0) {
                    Captions *captions = [Captions new];
                    [self.captionsOfSectionsAndDocument addObject:captions];
                }
                Caption *caption = (Caption*)element;
                [[self.captionsOfSectionsAndDocument lastObject] addCaption:caption];
                
                // Assembly String
                Text *text = [Text new];
                text.string = [NSString  stringWithFormat:@"%@ %@: ", caption.captionDescription, caption.captionNumber];
                Span *span = [caption.elements objectAtIndex:0];
                [span addElement:text];
            }
            
            // Bibliography
            if ([element isKindOfClass:[Bibliography class]]) {
                // Prepare XRefs for IDs
                Bibliography *bibliography = (Bibliography*)element;
                if (!self.bibliographyForIdentifier) {
                    self.bibliographyForIdentifier = [NSMutableArray new];
                }
                [self.bibliographyForIdentifier addObject:bibliography];
                
                // Sort bibliography items ascending
                int j = i;
                while (j > 0 && [[root.elements objectAtIndex:j-1] isKindOfClass:[Bibliography class]]) {
                    NSComparisonResult result = [[[root.elements objectAtIndex:j] identfier] compare:[[root.elements objectAtIndex:j-1] identfier]];
                    if (result == NSOrderedAscending) {
                        Bibliography *tmpBib = [Bibliography new];
                        tmpBib = [root.elements objectAtIndex:j-1];
                        
                        [root.elements replaceObjectAtIndex:j-1 withObject:[root.elements objectAtIndex:j]];
                        [root.elements replaceObjectAtIndex:j withObject:tmpBib];
                    }
                    j--;
                }
            }
            
            // Footnotes
            if ([element isKindOfClass:[Footnote class]]) {
                Footnote *footnote = (Footnote*)element;
                if (!self.footnotes) {
                    self.footnotes = [NSMutableArray new];
                }
                [self.footnotes addObject:footnote];
                footnote.footnoteNumber = (int)self.footnotes.count;
                Sup *sup = [Sup new];
                Text *text = [Text new];
                text.string = footnote.linkString;
                [sup addElement:text];
                [footnote addElement:sup];
            }
            
            
            [self assemblyNumbering:element];
        }
    }
}

- (void)assemblyCrossReferences:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            
            if ([element isKindOfClass:[Identifier class]]) {
                Identifier *identifier = (Identifier*)element;
                
                // XRefs to captions
                if (self.captionsOfSectionsAndDocument) {
                    for (Captions *captions in self.captionsOfSectionsAndDocument) {
                        for (CaptionStore *captionStore in captions.captionStoreArray) {
                            for (Caption *caption in captionStore.captionsArray) {
                                if ([identifier.identfier isEqual:caption.identfier]) {
                                    Text *text = [Text new];
                                    text.string = [NSString stringWithFormat:@"%@ %@", caption.captionDescription, caption.captionNumber];
                                    [identifier addElement:text];
                                }
                            }
                        }
                    }
                }
                // XRefs to sections
                if (self.sectionsForIdentifier) {
                    for (Section *section in self.sectionsForIdentifier) {
                        if ([section.identfier isEqual:identifier.identfier]) {
                            identifier.sectionNumber = section.sectionNumber;
                            Text *text = [Text new];
                            Text *sectionHeadingText = [[[section.elements objectAtIndex:0] elements] objectAtIndex:0];
                            text.string = sectionHeadingText.string;
                            [identifier addElement:text];
                        }
                    }
                }
                // XRefs to bibliography items
                if (self.bibliographyForIdentifier) {
                    for (Bibliography *bibliography in self.bibliographyForIdentifier) {
                        if ([bibliography.identfier isEqual:identifier.identfier]) {
                            Text *text = [Text new];
                            text.string = [NSString  stringWithFormat:@"[%@]",identifier.identfier];
                            [identifier addElement:text];
                            identifier.bibliographyID = identifier.identfier;
                        }
                    }
                }
                
            }
            [self assemblyCrossReferences:element];
        }
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                           HELPER                                             */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Helper

- (void)appendEndnotes {
    for (Footnote *footnote in self.footnotes) {
        if (footnote.endnote) {
            Endnote *endnote = footnote.endnote;
            
            Link *link = [Link new];
            link.href = endnote.href;
            Text *text = [Text new];
            [link addElement:text];
            text.string = endnote.linkString;
            link.parent = endnote;
            [endnote.elements insertObject:link atIndex:0];
            
            [self addElement:endnote];
        }
    }
}

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
