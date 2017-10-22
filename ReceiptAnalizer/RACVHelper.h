//
//  RACVHelper.h
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 20.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv.hpp>

@interface RACVHelper : NSObject

+ (cv::Mat)cvMatWithImage:(UIImage *)image;
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;

@end
