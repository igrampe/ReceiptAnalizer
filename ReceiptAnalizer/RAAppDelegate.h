//
//  RAAppDelegate.h
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 16.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAMainViewController;

@interface RAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RAMainViewController *mainCtl;

@end
