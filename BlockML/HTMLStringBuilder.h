//
//  HTMLStringBuilder.h
//  HTMLStringBuilder
//
//  Created by Lindemann on 14.08.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>

// ATTRIBUTES
static NSString *const ID = @"id";
static NSString *const CLASS = @"class";
static NSString *const HREF = @"href";

// TAGS
static NSString *const DIV = @"div";
static NSString *const SPAN = @"span";
static NSString *const A = @"a";
static NSString *const P = @"p";

@interface HTMLStringBuilder : NSObject

+ (NSString*)openTag:(NSString*)opentag attributes:(NSDictionary*)attributes indentation:(int)indentation lineBreak:(BOOL)lineBreak;
+ (NSString*)closingTag:(NSString*)closingTag indentation:(int)indentation lineBreak:(BOOL)lineBreak;
+ (NSString*)text:(NSString*)text indentation:(int)indentation lineBreak:(BOOL)lineBreak;

@end
