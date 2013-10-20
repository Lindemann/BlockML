//
//  AppDelegate.m
//  BlockML
//
//  Created by Lindemann on 28.04.13.
//  Copyright (c) 2013 Lindemann. All rights reserved.
//

#import "AppDelegate.h"
#import "EscapeTextWindowController.h"
#import "MainWindowController.h"
#import "DocumentController.h"

@interface AppDelegate()

@property (nonatomic, strong) EscapeTextWindowController *escapeTextWindowController;
@property (nonatomic, strong) MainWindowController *mainWindowController;


@end

@implementation AppDelegate

- (id)init {
    self = [super init];
    if (self) {
        DocumentController *documentController = [DocumentController new];
        
        if (!self.mainWindowController) {
            self.mainWindowController = [[MainWindowController alloc]initWithWindowNibName:@"Main"];
        }
        [self.mainWindowController showWindow:nil];
        
        documentController.delegate = self.mainWindowController;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    [self.recompileButton setHidden:YES];
//    [self.recompileMenuItem setEnabled:NO];

    // Remove this!
//    self.fileURL = [NSURL fileURLWithPath:@"/Users/LINDEMANN/Desktop/test.txt"];
//    [self processFile];
    // Really! Remove this!
    
    [self.mainWindowController.segmentedControl setMenu:self.openRecentMenuItem forSegment:0];
}

// Reopen window from dock after it was closed
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    //    [self.window orderFront:self];
    [self.mainWindowController.window makeKeyAndOrderFront:nil];
    return YES;
}

- (IBAction)recompileMenuItemWasPressed:(id)sender {
    [self.mainWindowController recompileMenuItemWasPressed:sender];
}

- (IBAction)openEscapeTextWindowMenuItemWasPressed:(id)sender {
    if (!self.escapeTextWindowController) {
        self.escapeTextWindowController = [[EscapeTextWindowController alloc]initWithWindowNibName:@"EscapeText"];
    }
    [self.escapeTextWindowController showWindow:nil];
}


// Get file path after drag and drop a file on the dock icon
//- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
//    self.fileURL = [NSURL fileURLWithPath:filename];
//    [self processFile];
//    return YES;
//}


//// Action!
//- (void)processFile {
//    // Test if fileURL exists...relevant when method became called from Recompile button
//    if (![self.fileURL checkResourceIsReachableAndReturnError:nil]) {
//        // Play warning beep
//        NSBeep();
//        return;
//    }
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    // Generate directory for compiled data with
//    NSURL *compiledDataDirectory = [self.fileURL URLByDeletingPathExtension];
//    if (![compiledDataDirectory checkResourceIsReachableAndReturnError:nil]) {
//        [fileManager createDirectoryAtURL:compiledDataDirectory withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    
//    self.HTMLURL = [compiledDataDirectory URLByAppendingPathComponent:@"document.html"];
//    NSString *textFileName = [self.fileURL lastPathComponent];
//    self.fileNameTextField.stringValue = textFileName;
//    
//    // Read source text file and compile it
//    NSString *content =  [[NSString alloc] initWithContentsOfURL:self.fileURL encoding:NSUTF8StringEncoding error:nil];
//    
//    [self.progessIndicator startAnimation:self];
//    [self.recompileButton setEnabled:NO];
//    [self.recompileButton setHidden:NO];
//    [self.recompileMenuItem setEnabled:YES];
//    
//    Parser *parser = [Parser parserWithString:content];
//    parser.document.HTMLURL = self.HTMLURL;
//    dispatch_queue_t parseData = dispatch_queue_create("parseData", NULL);
//    dispatch_async(parseData, ^{
//        [parser startParsing];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Do something after compilation
//            [self.progessIndicator stopAnimation:self];
//            [self.recompileButton setEnabled:YES];
//            [[NSWorkspace sharedWorkspace] openURL:self.HTMLURL];
//            
//            // Copy Images
//            NSURL *ImagesSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Images" isDirectory:YES];
//            NSURL *ImagesDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"Images" isDirectory:YES];
//            [fileManager copyItemAtURL:ImagesSourceDirectory toURL:ImagesDestinationDirectory error:nil];
//            // Copy CSS
//            NSURL *CSSSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"CSS" isDirectory:YES];
//            NSURL *CSSDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"CSS" isDirectory:YES];
//            [fileManager copyItemAtURL:CSSSourceDirectory toURL:CSSDestinationDirectory error:nil];
//            
//            /*
//            // Copy MathJax
//            if (parser.document.mathJax || parser.document.inlineMath) {
//                NSURL *mathJaxSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"MathJax" isDirectory:YES];
//                NSURL *mathJaxDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"MathJax" isDirectory:YES];
//                [fileManager copyItemAtURL:mathJaxSourceDirectory toURL:mathJaxDestinationDirectory error:nil];
//            }
//            */
//            // Copy Highlight.JS
//            if (parser.document.highlight) {
//                NSURL *highlightJSSourceDirectory = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"highlight.js" isDirectory:YES];
//                NSURL *highlightJSDestinationDirectory = [compiledDataDirectory URLByAppendingPathComponent:@"highlight.js" isDirectory:YES];
//                [fileManager copyItemAtURL:highlightJSSourceDirectory toURL:highlightJSDestinationDirectory error:nil];
//            }
//
//        });
//    });
//}
//
//- (IBAction)recompileButtonWasPressed:(id)sender {
//    [self processFile];
//}
//
//- (IBAction)recompileMenuItemWasPressed:(id)sender {
//    [self processFile];
//}

@end
