//
//  DocumentController.m
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "DocumentController.h"

@implementation DocumentController

- (void)openDocumentWithContentsOfURL:(NSURL *)url display:(BOOL)displayDocument completionHandler:(void (^)(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error))completionHandler {
    [super openDocumentWithContentsOfURL:url display:displayDocument completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error){
        [self.delegate currentDocumentHasChanged:document];
        if (completionHandler) {
            completionHandler(document, documentWasAlreadyOpen, error);
        }
    }];
}

@end
