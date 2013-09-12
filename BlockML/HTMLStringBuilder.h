//
//  HTMLStringBuilder.h
//  HTMLStringBuilder
//
//  Created by Lindemann on 14.08.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>

// ATTRIBUTES
#define ID @"id"
#define CLASS @"class"
#define HREF @"href"

// TAGS
#define DIV @"div"
#define SPAN @"span"
#define A @"a"
static NSString const *bla = @"hg";

@interface HTMLStringBuilder : NSObject

+ (NSString*)openTag:(NSString*)opentag attributes:(NSDictionary*)attributes indentation:(int)indentation lineBreak:(BOOL)lineBreak;
+ (NSString*)closingTag:(NSString*)closingTag indentation:(int)indentation lineBreak:(BOOL)lineBreak;
+ (NSString*)text:(NSString*)text indentation:(int)indentation lineBreak:(BOOL)lineBreak;

@end
