//
//  MainWindowController.m
//  BlockML
//
//  Created by Lindemann on 19.10.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "MainWindowController.h"
#import "Parser.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.dropView.delegate = self;
    self.fileNameTextField.stringValue = @"";
}

- (void)processFile {
    // Test if fileURL exists...relevant when method became called from Recompile button
    if (![self.currentDocument.fileURL checkResourceIsReachableAndReturnError:nil]) {
        // Play warning beep
        NSBeep();
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Generate directory for compiled data with
    NSURL *compiledDataDirectory = [self.currentDocument.fileURL URLByDeletingPathExtension];
    if (![compiledDataDirectory checkResourceIsReachableAndReturnError:nil]) {
        [fileManager createDirectoryAtURL:compiledDataDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    self.HTMLURL = [compiledDataDirectory URLByAppendingPathComponent:@"document.html"];
    NSString *textFileName = [self.currentDocument.fileURL lastPathComponent];
    self.fileNameTextField.stringValue = textFileName;
    
    // Read source text file and compile it
    NSString *content =  [[NSString alloc] initWithContentsOfURL:self.currentDocument.fileURL encoding:NSUTF8StringEncoding error:nil];
    
    [self.progressIndicator startAnimation:self];
//    [self.recompileButton setEnabled:NO];
//    [self.recompileButton setHidden:NO];
//    [self.recompileMenuItem setEnabled:YES];
    
    Parser *parser = [Parser parserWithString:content];
    parser.document.HTMLURL = self.HTMLURL;
    dispatch_queue_t parseData = dispatch_queue_create("parseData", NULL);
    dispatch_async(parseData, ^{
        [parser startParsing];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do something after compilation
            [self.progressIndicator stopAnimation:self];
//            [self.recompileButton setEnabled:YES];
            [[NSWorkspace sharedWorkspace] openURL:self.HTMLURL];
            
            // Copy Images
            NSURL *ImagesSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Images" isDirectory:YES];
            NSURL *ImagesDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"Images" isDirectory:YES];
            [fileManager copyItemAtURL:ImagesSourceDirectory toURL:ImagesDestinationDirectory error:nil];
            // Copy CSS
            NSURL *CSSSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"CSS" isDirectory:YES];
            NSURL *CSSDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"CSS" isDirectory:YES];
            [fileManager copyItemAtURL:CSSSourceDirectory toURL:CSSDestinationDirectory error:nil];
            
            /*
             // Copy MathJax
             if (parser.document.mathJax || parser.document.inlineMath) {
             NSURL *mathJaxSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"MathJax" isDirectory:YES];
             NSURL *mathJaxDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"MathJax" isDirectory:YES];
             [fileManager copyItemAtURL:mathJaxSourceDirectory toURL:mathJaxDestinationDirectory error:nil];
             }
             */
            // Copy Highlight.JS
            if (parser.document.highlight) {
                NSURL *highlightJSSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"highlight.js" isDirectory:YES];
                NSURL *highlightJSDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"highlight.js" isDirectory:YES];
                [fileManager copyItemAtURL:highlightJSSourceDirectory toURL:highlightJSDestinationDirectory error:nil];
            }
            
        });
    });
}

- (void)recompileMenuItemWasPressed:(id)sender {
    [self processFile];
}

- (IBAction)segmentedControlWasPressed:(id)sender {
    NSSegmentedControl *segmentedControl = (NSSegmentedControl *)sender;
    NSInteger segment = [segmentedControl selectedSegment];
    if (segment == 1) {
        [self processFile];
    }
}

- (void)currentDocumentHasChanged:(NSDocument *)document {
    self.currentDocument = (BlockMLDocument*)document;
    self.fileNameTextField.stringValue = document.displayName;
    [self processFile];
}

- (void)dropedFileWithURL:(NSURL*)URL {
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:URL display:NO completionHandler:nil];
}

@end
