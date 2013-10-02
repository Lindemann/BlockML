//
//  Identifier.h
//  BlockMLLight
//
//  Created by Lindemann on 29.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@interface Identifier : HTMLElement

@property (nonatomic, strong) NSString *identfier;
// If Identifier is a reference to a section
@property (nonatomic, strong) NSString *sectionNumber;
// If Identifier is a reference to a bibliographic item
@property (nonatomic, strong) NSString *bibliographyID;

@end
