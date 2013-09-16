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

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    
    [result appendString:[HTMLStringBuilder openTag:@"!DOCTYPE html" attributes:nil indentation:0 lineBreak:YES]];
    [result appendString:BLOCKML];
    [result appendString:[HTMLStringBuilder openTag:@"html" attributes:nil indentation:0 lineBreak:YES]];

    return result;
}

- (NSString*)closeTag {
    NSMutableString *result = [NSMutableString new];
    [result appendString:[HTMLStringBuilder closingTag:@"html" indentation:0 lineBreak:NO]];
    return result;
}

- (void)generateHTML {
    // Write Content to File
    [self.htmlString appendString:self.openTag];
    [self assamblyHTMLString:self];
    [self.htmlString appendString:self.closeTag];
    NSString *content = self.htmlString;
    [content writeToURL:self.HTMLURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (void)assamblyHTMLString:(HTMLElement*)root {
    if (root.elements != nil && root.elements.count > 0) {
        for (int i = 0; i < root.elements.count; ++i) {
            HTMLElement *element = [root.elements objectAtIndex:i];
//            element.parent = root;
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
