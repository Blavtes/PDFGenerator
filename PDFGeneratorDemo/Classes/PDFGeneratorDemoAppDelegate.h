//
//  PDFGeneratorDemoAppDelegate.h
//  PDFGeneratorDemo
//
//  Created by lv on 1/4/11.
//  Copyright 2011 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFGeneratorDemoViewController;

@interface PDFGeneratorDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PDFGeneratorDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PDFGeneratorDemoViewController *viewController;

@end

