//
//  Scanner.h
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface Scanner : NSObject

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableAttributedString *highlightedString;

- (id)initWithString:(NSString*)string;
+ (id)scannerWithString:(NSString*)string;

- (Token *)getToken;

@end
