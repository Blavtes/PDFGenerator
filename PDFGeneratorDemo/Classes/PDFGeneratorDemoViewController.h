//
//  PDFGeneratorDemoViewController.h
//  PDFGeneratorDemo
//
//  Created by lv on 1/4/11.
//  Copyright 2011 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFGeneratorDemoViewController : UIViewController {

	IBOutlet UITextView* textView;
    IBOutlet UIImageView *imageView;
}

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic, retain) UITextView* textView;

- (IBAction)savePDFFile:(id)sender;

@end

