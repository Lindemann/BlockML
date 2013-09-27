//
//  Image.m
//  BlockMLLight
//
//  Created by Lindemann on 27.09.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "Image.h"

@implementation Image

- (NSString*)openTag {
    NSMutableString *result = [NSMutableString new];
    if ([self.source hasPrefix:@"http"]) {
        [self.attributes setValue:self.source forKey:@"src"];
    } else {
        NSString *sourcePath = [NSString  stringWithFormat:@"images/%@",self.source];
        [self.attributes setValue:sourcePath forKey:@"src"];
    }
    if (self.witdh > 0) {
        [self.attributes setValue:[NSString  stringWithFormat:@"%d",self.witdh] forKey:@"width"];
    }
    if (self.height > 0) {
        [self.attributes setValue:[NSString  stringWithFormat:@"%d",self.height] forKey:@"height"];
    }
    [result appendString:[HTMLStringBuilder openTag:@"img" attributes:self.attributes indentation:self.openTagIndentation lineBreak:self.openTagLineBreak]];
    return result;
}

- (NSString*)closeTag {
    return nil;
}

@end
