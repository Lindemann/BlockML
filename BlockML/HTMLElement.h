//
//  HTMLElement.h
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLElement : NSObject

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) HTMLElement *parent;
@property (nonatomic, strong) NSString *openTag;
@property (nonatomic, strong) NSString *closeTag;
@property (nonatomic) int *indentation;
@property (nonatomic) BOOL *lineBreak;
@property (nonatomic, strong) NSMutableDictionary *attributes;

@end
