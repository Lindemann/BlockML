//
//  Document.m
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLDocument.h"

@interface HTMLDocument ()

@property (nonatomic, strong) NSMutableString *htmlString;

@end

@implementation HTMLDocument


- (void)generateHTML {
    // Write Content to File
    NSString *content = @"Hello World!";
    [content writeToURL:self.HTMLURL atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
