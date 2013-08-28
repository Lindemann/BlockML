//
//  Scanner.m
//  BlockML
//
//  Created by Lindemann on 27.08.12.
//  Copyright (c) 2012 Lindemann. All rights reserved.
//

#import "Scanner.h"

@interface Scanner()

@property (nonatomic, strong) Token *token;

@end

@implementation Scanner

- (id)initWithString:(NSString*)string {
    if(self = [super init]) {
        self.token = [Token new];
    }
    return self;
}

+ (id)scannerWithString:(NSString*)string {
    return [[Scanner alloc]initWithString:string];
}

- (Token *)getToken {
    return self.token;
}

@end
