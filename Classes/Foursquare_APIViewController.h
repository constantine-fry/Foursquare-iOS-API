//
//  Foursquare_APIViewController.h
//  Foursquare API
//
//  Created by Constantine Fry on 10/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Foursquare_APIViewController : UIViewController<UITextFieldDelegate> {
	UITextField *_userField;
	UITextField *_passField;
	UIButton *checkinButton;
	UIButton *logoutButton;
}
- (void) showAlertWithMessage:(NSString*)str;
@end

