//
//  RAMainViewController.m
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 16.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import "RAMainViewController.h"
#import "RAImageViewController.h"

@interface RAMainViewController ()

@end

@implementation RAMainViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openImagePicker
{
	[AKSVideoAndImagePicker needImage:YES
							needVideo:NO FromLibrary:YES
								 from:self
						  didFinished:^(NSString *filePath, NSString *fileType) {
							  NSData *imgData = [NSData dataWithContentsOfFile:filePath];
							  _image = [[UIImage alloc] initWithData:imgData];
	}];
}

- (IBAction)openImagePickerAction:(id)sender
{
	[self openImagePicker];
}

- (void)viewDidAppear:(BOOL)animated
{
	if (_image) {
		RAImageViewController *ctl = [[RAImageViewController alloc] initWithNibName:@"RAImageViewController" bundle:nil];
		ctl.delegate = self;
		ctl.image = _image;
		[self presentViewController:ctl animated:YES completion:nil];
	}
}

#pragma mark - RAImageCtlProtocol

- (void)imageCtlCancelAction
{
	_image = nil;
}

@end
