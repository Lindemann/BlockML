//
//  Footnote.h
//  BlockMLLight
//
//  Created by Lindemann on 03.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@class Endnote;

@interface Footnote : HTMLElement

@property (nonatomic, strong) Endnote *endnote;
@property (nonatomic) int footnoteNumber;
@property (nonatomic, strong) NSString *linkString;

@end
