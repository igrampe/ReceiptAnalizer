//
//  RAImageProcessor.h
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 20.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
//#include <opencv.hpp>
#import "imgproc/imgproc.hpp"

cv::vector<cv::Mat> processImage(cv::Mat image);