//
//  Caption.h
//  BlockMLLight
//
//  Created by Lindemann on 29.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"

@interface Caption : HTMLElement

@property (nonatomic, strong) NSString *identfier; // eg. WIKIBI
@property (nonatomic, strong) NSString *captionDescription; // eg. Abb., Figure...
@property (nonatomic, strong) NSString *captionNumber; // eg. 4.1
@property (nonatomic, strong) NSString *captionText;

@end
