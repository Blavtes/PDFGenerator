//
//  PDFGeneratorDemoViewController.m
//  PDFGeneratorDemo
//
//  Created by lv on 1/4/11.
//  Copyright 2011 CocoaChina. All rights reserved.
//

#import "PDFGeneratorDemoViewController.h"
#import <CoreText/CoreText.h>
#import "WQPDFManager.h"
@implementation PDFGeneratorDemoViewController

@synthesize textView;

- (void)dealloc {
	[textView release];
    [super dealloc];
}
//*
// Use Core Text to draw the text in a frame on the page.
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
	   andFramesetter:(CTFramesetterRef)framesetter
{
	// Get the graphics context.
	CGContextRef  currentContext = UIGraphicsGetCurrentContext();
	
	// Put the text matrix into a known state. This ensures
	// that no old scaling factors are left in place.
	CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
	
	// Create a path object to enclose the text. Use 72 point
	// margins all around the text.
	CGRect    frameRect = CGRectMake(72, 72, 468, 648);
	CGMutablePathRef framePath = CGPathCreateMutable();
	CGPathAddRect(framePath, NULL, frameRect);
	
	// Get the frame that will do the rendering.
	// The currentRange variable specifies only the starting point. The framesetter
	// lays out as much text as will fit into the frame.
	CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
	CGPathRelease(framePath);
	
	// Core Text draws from the bottom-left corner up, so flip
	// the current transform prior to drawing.
	CGContextTranslateCTM(currentContext, 0, 792);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	// Draw the frame.
	CTFrameDraw(frameRef, currentContext);
	
	// Update the current range based on what was drawn.
	currentRange = CTFrameGetVisibleStringRange(frameRef);
	currentRange.location += currentRange.length;
	currentRange.length = 0;
	CFRelease(frameRef);
	
	return currentRange;
}

- (void)drawPageNumber:(NSInteger)pageNum
{
	NSString* pageString = [NSString stringWithFormat:@"Page %d", pageNum];
	UIFont* theFont = [UIFont systemFontOfSize:12];
	CGSize maxSize = CGSizeMake(612, 72);
	
	CGSize pageStringSize = [pageString sizeWithFont:theFont
								   constrainedToSize:maxSize
                                       lineBreakMode:UILineBreakModeClip];
	CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
								   720.0 + ((72.0 - pageStringSize.height) / 2.0) ,
								   pageStringSize.width,
								   pageStringSize.height);
	
	[pageString drawInRect:stringRect withFont:theFont];
}
//*/

-(NSString*)getPDFFileName{
	return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"lv_demo.pdf"];
}

- (IBAction)savePDFFile:(id)sender
{
    UIImage *image = [UIImage imageNamed:@"x.png"];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString *pdfname = @"photoToPDF.pdf";
    [WQPDFManager WQCreatePDFFileWithSrc:data toDestFile:pdfname withPassword:nil];
    
    
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)textView.text, NULL);
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
			
            NSString* pdfFileName = [self getPDFFileName];
			NSLog(@"path[%@]", pdfFileName);
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
			
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
			
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
				//*
                // Draw a page number at the bottom of each page
                currentPage++;
                [self drawPageNumber:currentPage];
				
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                //currentRange = [self renderPageWithTextRange:currentRange andFramesetter:framesetter];
				currentRange = [self renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter];
				//*/
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText))
                    done = YES;
            } while (!done);
			
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
			
            // Release the framewetter.
            CFRelease(framesetter);
			
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
        // Release the attributed string.
        CFRelease(currentText);
    } else {
		NSLog(@"Could not create the attributed string for the framesetter");
    }
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
