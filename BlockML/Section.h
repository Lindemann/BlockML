//
//  Section.h
//  BlockMLLight
//
//  Created by Lindemann on 20.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@interface Section : HTMLElement

@property (nonatomic) int headingLevel; // H1 - H6
@property (nonatomic) int sectionIndex; // 4
@property (nonatomic, strong) NSString *sectionNumber; // 2.3.4 Section Title
@property (nonatomic, strong) NSString *identfier; // eg. WIKIBI


@end
