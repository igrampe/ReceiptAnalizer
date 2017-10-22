//
//  RAMainViewController.h
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 16.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKSVideoAndImagePicker.h"
#import "RAImageViewController.h"

@interface RAMainViewController : UIViewController <RAImageCtlProtocol> {
	AKSVideoAndImagePicker *_imagePicker;
	UIImage *_image;
}

@end
