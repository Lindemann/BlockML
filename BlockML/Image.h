//
//  Image.h
//  BlockMLLight
//
//  Created by Lindemann on 27.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@interface Image : HTMLElement

@property (nonatomic, strong) NSString* source;
@property (nonatomic) int witdh;
@property (nonatomic) int height;

@end
