//
//  Foursquare_APIAppDelegate.h
//  Foursquare API
//
//  Created by Constantine Fry on 10/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Foursquare_APIViewController;

@interface Foursquare_APIAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Foursquare_APIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Foursquare_APIViewController *viewController;

@end

