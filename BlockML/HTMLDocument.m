//
//  Document.m
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLDocument.h"
#import "HTMLStringBuilder.h"
#import "HTMLTree.h"

@interface HTMLDocument ()

@end

static NSString *const BLOCKML = @"<!--\n    ____  __           __   __  _____\n   / __ )/ /___  _____/ /__/  |/  / /\n  / __  / / __ \\/ ___/ //_/ /|_/ / /\n / /_/ / / /_/ / /__/ ,< / /  / / /___\n/_____/_/\\____/\\___/_/|_/_/  /_/_____/\n\n-->\n";

@implementation HTMLDocument

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"♥ BlockML ♥";
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
    [result appendString:[HTMLStringBuilder openTag:@"title" attributes:nil indentation:2 lineBreak:NO]];
    [result appendString:[HTMLStringBuilder text:self.title indentation:NO lineBreak:NO]];
    [result appendString:[HTMLStringBuilder closingTag:@"title" indentation:0 lineBreak:YES]];
    if (self.mathJax) {
        ;
    }
    if (self.highlight) {
        ;
    }
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

- (void)generateHTML {
    [self formatHTMLString:self];
    
    // Write Content to File
    [self.htmlString appendString:self.openTag];
    [self assamblyHTMLString:self];
    [self.htmlString appendString:self.closeTag];
    NSString *content = self.htmlString;
    [content writeToURL:self.HTMLURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)formatHTMLString:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            
            if ([element.parent isKindOfClass:[HTMLDocument class]]) {
                element.closingTagLineBreak = YES;
                // +1 for body tag
                element.openTagIndentation = element.parentCount + 1;
            }
            
            [self formatHTMLString:element];
            
            
        }
    }
}

- (void)assamblyHTMLString:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
            [element.htmlString appendString:element.openTag];
            
            [self assamblyHTMLString:element];
            
            if (element.closeTag) {
                [element.htmlString appendString:element.closeTag];
            }
            
            [root.htmlString appendString:element.htmlString];
        }
    }
}

@end
