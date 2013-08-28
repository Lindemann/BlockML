//
//  Parser.h
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

@property (nonatomic, strong) NSString *string;

- (id)initWithString:(NSString*)string;
+ (id)parserWithString:(NSString*)string;

- (void)startParsing;

@end
