//
//  CaptionStorage.m
//  BlockMLLight
//
//  Created by Lindemann on 30.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Captions.h"

@implementation Captions

- (id)init {
    self = [super init];
    if (self) {
        self.captionStoreArray = [NSMutableArray new];
    }
    return self;
}

- (void)addCaption:(Caption *)caption {
    CaptionStore *captionStore;
    for (CaptionStore *tmpCaptionStore in self.captionStoreArray) {
        if ([tmpCaptionStore.description isEqual:caption.description]) {
            captionStore = tmpCaptionStore;
        }
    }
    if (captionStore) {
        [captionStore.captionsArray addObject:caption];
    } else {
        captionStore = [CaptionStore new];
        captionStore.description = caption.description;
        [captionStore.captionsArray addObject:caption];
    }
    [self.captionStoreArray addObject:captionStore];
    
    if (self.sectionIndex) {
        caption.captionNumber = [NSString  stringWithFormat:@"%d.%lu", self.sectionIndex, (unsigned long)captionStore.captionsArray.count];
    } else {
        caption.captionNumber = [NSString  stringWithFormat:@"%lu", (unsigned long)captionStore.captionsArray.count];
    }
}

@end
