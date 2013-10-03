//
//  Endnote.h
//  BlockMLLight
//
//  Created by Lindemann on 03.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@class  Footnote;

@interface Endnote : HTMLElement

@property (nonatomic, strong) Footnote *footnote;
@property (nonatomic, strong) NSString *linkString;
@property (nonatomic, strong) NSString *href;

@end
