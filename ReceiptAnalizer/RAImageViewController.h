//
//  RAImageViewController.h
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 19.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR.h>

@protocol RAImageCtlProtocol <NSObject>

- (void)imageCtlCancelAction;

@end

@interface RAImageViewController : UIViewController <TesseractDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<RAImageCtlProtocol> delegate;

@end
