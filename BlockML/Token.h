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

@end
