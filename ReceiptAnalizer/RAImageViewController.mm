//
//  RAImageViewController.m
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 19.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import "RAImageViewController.h"
#include "RAImageProcessor.h"
#import "RACVHelper.h"
#import <imgproc.hpp>

@interface RAImageViewController ()

@end

using namespace cv;

@implementation RAImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.imageView.image = _image;

	NSTimeInterval t1 = [[NSDate date] timeIntervalSince1970];
	cv::vector<cv::Mat> segments = processImage([RACVHelper cvMatWithImage:_image]);
	
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"rus"];
    tesseract.delegate = self;
    [tesseract setVariableValue:@"аАбБвВгГдДеЕёЁжЖзЗиИйЙкКлЛмМнНоОпПпРсСтТуУфФчХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ0123456789.=" forKey:@"tessedit_char_whitelist"]; //limit search
	
	for (int i = 0; i < segments.size(); i++) {
		UIImage *img = [RACVHelper imageWithCVMat:segments[i]];
		
//		self.imageView.image = img;
		
		[tesseract setImage:img];
		[tesseract recognize];
		
		NSLog(@"%@", [tesseract recognizedText]);
	}
	
	NSTimeInterval t2 = [[NSDate date] timeIntervalSince1970];
	NSLog(@"%f", t2 - t1);
    tesseract = nil;
}

- (IBAction)cancelAction:(id)sender
{
	[self.delegate imageCtlCancelAction];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)progressImageRecognitionForTesseract:(Tesseract*)tesseract
{
	
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
	return NO;
}

@end
