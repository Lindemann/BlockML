//
//  Document.h
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLElement.h"

@interface HTMLDocument : HTMLElement

@property (nonatomic, strong) NSURL *HTMLURL;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) BOOL mathJax;
@property (nonatomic) BOOL highlight;

- (void)generateHTML;

@end
