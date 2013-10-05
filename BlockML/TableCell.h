//
//  TableCell.h
//  BlockMLLight
//
//  Created by Lindemann on 05.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

typedef enum {
    VERTICAL = 1,
    HORIZONTAL = 2
} SpanDirection;

@interface TableCell : HTMLElement

@property (nonatomic) SpanDirection spanDirection;
@property (nonatomic) int spanWidth;

@end
