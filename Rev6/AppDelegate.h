//
//  AppDelegate.h
//  Rev6
//
//  Created by Bryce Redd on 1/11/12.
//  Copyright Itv 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

+ (NSString *) documentDir;

@end
