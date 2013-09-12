//
//  Parser.h
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLDocument.h"

@interface Parser : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) HTMLDocument *document;

- (id)initWithString:(NSString*)string;
+ (id)parserWithString:(NSString*)string;

- (void)startParsing;

@end
