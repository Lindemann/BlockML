//
//  Token.h
//  BlockML
//
//  Created by Lindemann on 02.09.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenType.h"

@interface Token : NSObject

@property (nonatomic) TokenType type;
@property (nonatomic, strong) NSString *value;

// Look up list for TokenType <-> String
// (A_SB <-> @"a[")
// Gets handy for Scanner and -description
+ (NSMutableArray*)stringList;
+ (NSString*)stringForStringListElement:(NSArray*)element;
+ (TokenType)tokenTypeForStringListElement:(NSArray*)element;

// Only needed for extern syntax highlighting stuff like the tmBundle
+ (void)printAllTokenWithDelimiter:(NSString*)delimiter;

@end
