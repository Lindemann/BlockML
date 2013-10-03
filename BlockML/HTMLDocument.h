//
//  Document.h
//  BlockMLLight
//
//  Created by Lindemann on 11.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLElement.h"
#import "HTMLTree.h"

@interface HTMLDocument : HTMLElement

@property (nonatomic, strong) NSURL *HTMLURL;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) BOOL mathJax;
@property (nonatomic) BOOL inlineMath;
@property (nonatomic) BOOL highlight;

@property (nonatomic, strong) TableOfContent *tableOfContent;

- (void)generateHTML;

@end
