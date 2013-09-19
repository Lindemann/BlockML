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

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                     PRODUCTION RULES                                         */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Production Rules

- (void)documentWithParent:(HTMLElement*)parent {
    while (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= TITLE_SB)) {
        
        Paragraph *paragraph = [Paragraph new];
        [parent addElement:paragraph];
        
        [self textBlockWithParent:paragraph];
        [self blockTagWithParent:parent];
    }
//    // Keep parsing to find erros
//    while (self.token.type == OPEN_SB || self.token.type == CLOSE_SB) {
//        self.token = [self.scanner getToken];
//        [self documentWithParent:parent];
//    }
}

- (void)inlineTagWithParent:(HTMLElement*)parent {
    [self linkWithParent:parent];
}

- (void)blockTagWithParent:(HTMLElement*)parent {
    
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                            TEXT                                              */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - Text

- (void)textBlockWithParent:(HTMLElement*)parent {
    if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
        [self textWithParent:parent];
        if (self.token.type == LF) {
            [self nextToken];
            [self paragraphWithParent:parent.parent];
            if (self.token.type != LF) {
                
                if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
                    LineBreak *lineBreak = [LineBreak new];
                    [parent addElement:lineBreak];
                }
                
                [self textBlockWithParent:parent];
            }
        }
    }
}

- (void)textWithParent:(HTMLElement*)parent {
    if (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
        if (self.token.type == STRING) {
            
            Text *text = [Text new];
            [parent addElement:text];
            text.string = self.token.value;
            
            
            [self nextToken];
        }
        [self inlineTagWithParent:parent];
        while (self.token.type == STRING || (self.token.type >= A_SB && self.token.type <= ID_SB)) {
            if (self.token.type == STRING) {
                
                Text *text = [Text new];
                [parent addElement:text];
                text.string = self.token.value;
                
                [self nextToken];
            }
            [self inlineTagWithParent:parent];
        }
    }
}

- (void)paragraphWithParent:(HTMLElement*)parent {
    if (self.token.type == LF) {
        [self nextToken];
        while (self.token.type == LF) {
            [self nextToken];
        }
        
        if (self.token.type == STRING) {
            
            Paragraph *paragraph = [Paragraph new];
            [parent addElement:paragraph];
            
            [self textBlockWithParent:paragraph];
        }
        
        if (self.token.type >= A_SB && self.token.type <= ID_SB) {
            [self textBlockWithParent:parent];
        }
        
    }
}

/*//////////////////////////////////////////////////////////////////////////////////////////////*/

/*                                         INLINE TAGS                                          */

/*//////////////////////////////////////////////////////////////////////////////////////////////*/
#pragma mark - INLINE TAGS

- (void)linkWithParent:(HTMLElement*)parent {
    if (self.token.type == A_SB) {
        [self nextToken];
        
        Link *link = [Link new];
        
        if (self.token.type == STRING) {

            link.href = self.token.value;
            
            [self nextToken];
            
            if (self.token.type == CLOSE_SB) {
                
                [parent addElement:link];
                
                [self nextToken];
                
                if (self.token.type != OPEN_SB) {
                    
                    Text *text = [Text new];
                    [link addElement:text];
                    text.string = link.href;
                }
            }
        }
    }
}


@end
