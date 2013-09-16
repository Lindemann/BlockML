//
//  HTMLElement.h
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLStringBuilder.h"

@interface HTMLElement : NSObject

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) HTMLElement *parent;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) NSMutableString *htmlString;
@property (nonatomic, strong) NSString *openTag;
@property (nonatomic, strong) NSString *closeTag;

@property (nonatomic) int openTagIndentation;
@property (nonatomic) BOOL openTagLineBreak;
@property (nonatomic) int closingTagIndentation;
@property (nonatomic) BOOL closingTagLineBreak;

- (void)addElement:(HTMLElement*)element;
- (void)removeElement:(HTMLElement*)element;

@end
