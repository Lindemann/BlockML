//
//  CaptionStorage.h
//  BlockMLLight
//
//  Created by Lindemann on 30.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "HTMLElement.h"
#import "CaptionStore.h"
#import "Caption.h"

@interface Captions : NSObject

// if caption is a part of Section this is > 0
// if caption is a part of HTMLDocument this is 0
@property (nonatomic) int sectionIndex;
@property (nonatomic, strong) NSMutableArray *captionStoreArray;

- (void)addCaption:(Caption *)caption;

@end
