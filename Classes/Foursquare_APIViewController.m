//
//  Foursquare_APIViewController.m
//  Foursquare API
//
//  Created by Constantine Fry on 10/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Foursquare_APIViewController.h"
#import "Foursquare.h"


@implementation Foursquare_APIViewController


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

#pragma mark NSUserDefaults Methods
- (BOOL)isAccountConfigured {	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *token  = [defaults stringForKey:FS_ACC_TOKEN];
	NSString *secret = [defaults stringForKey:FS_ACC_SECRET];
	BOOL res = ([token length] > 0 && [secret length] > 0);
	return res;
}

-(void)configureFoursquare{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *token  = [defaults stringForKey:FS_ACC_TOKEN];
	NSString *secret = [defaults stringForKey:FS_ACC_SECRET];
	BOOL res = ([token length] > 0 && [secret length] > 0);
	if (res) {
		[Foursquare setOAuthAccessToken:token secret:secret];
	}
}

-(void)removeFoursqureFromDefaults{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:FS_ACC_TOKEN];
	[defaults removeObjectForKey:FS_ACC_SECRET];
	[defaults synchronize];
}
#pragma mark -

- (void) loadUI {
	_userField = [[UITextField alloc]initWithFrame:CGRectMake(50, 50, 200, 30)];
	_userField.center = CGPointMake(160, 100);
	_userField.keyboardType = UIKeyboardTypeEmailAddress;
	_userField.delegate = self;
	_userField.returnKeyType = UIReturnKeyNext;
	_userField.placeholder = @"Email/phone";
	//	_userField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_userField.borderStyle = UITextBorderStyleRoundedRect;
	[_userField becomeFirstResponder];
	
	_passField = [[UITextField alloc]initWithFrame:CGRectMake(50, 120, 200, 30)];
	_passField.returnKeyType = UIReturnKeyDone;
	_passField.delegate=self;
	_passField.center = CGPointMake(160, 150);
	_passField.placeholder = @"Password";
	_passField.secureTextEntry = YES;
	_passField.borderStyle = UITextBorderStyleRoundedRect;
	[self.view addSubview:_userField];
	[self.view addSubview:_passField];
	
	checkinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[checkinButton setTitle:@"Checkin" forState:UIControlStateNormal];
	[checkinButton sizeToFit];
	checkinButton.center = CGPointMake(160, 50);
	checkinButton.frame = CGRectIntegral(checkinButton.frame);
	[checkinButton addTarget:self
					  action:@selector(checkin)
			forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:checkinButton];
	
	logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
	[logoutButton sizeToFit];
	logoutButton.center = CGPointMake(160, 100);
	logoutButton.frame = CGRectIntegral(logoutButton.frame);
	[logoutButton addTarget:self
					 action:@selector(logout)
		   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:logoutButton];
	
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	[self loadUI];
	if ([self isAccountConfigured]) {
		[self configureFoursquare];
		[self showButtons];
		_passField.hidden = YES;
		_userField.hidden = YES;
		return;
	}else {
		logoutButton.hidden = YES;
		checkinButton.hidden = YES;
	}
}


-(void)LoginWithUser:(NSString*)u andPass:(NSString*)p{
	if (u == nil || p == nil) {
		return;
	}
	[Foursquare getOAuthAccessTokenForUsername:u password:p callback:
	 ^(BOOL success, id response) {
		 if (success) {
			 
			 NSDictionary *dict = [response objectForKey:@"credentials"];
			 
			 NSString *token  = [dict objectForKey:@"oauth_token"];
			 NSString *secret = [dict objectForKey:@"oauth_token_secret"];
			 
			 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			 [defaults setObject:token  forKey:@"access_token"];
			 [defaults setObject:secret forKey:@"access_secret"];
			 [defaults synchronize];
			 [Foursquare setOAuthAccessToken:token secret:secret];
			 [self showButtons];
		 } else {
			 [self showAlertWithMessage:@"Error :(!"];
		 }
	 }];
}


-(void)showButtons{
	_passField.hidden = YES;
	_userField.hidden = YES;
	
	[_userField resignFirstResponder];
	[_passField resignFirstResponder];
	logoutButton.hidden = NO;
	checkinButton.hidden = NO;
}

#pragma mark Actions
- (void) showAlertWithMessage:(NSString*)str {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"!!!"
													message:str
												   delegate:nil
										  cancelButtonTitle:@"ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

-(void)checkin{
	[Foursquare checkinAtVenueId:@"6522771"
					   venueName:nil
						   shout:@"This center of Omsk City" 
					 showFriends:YES 
					   sendTweet:NO 
					tellFacebook:NO 
						latitude:nil 
					   longitude:nil 
						callback:^(BOOL s, id response){
							if (YES == s) {
								[self showAlertWithMessage:@"You just checkin! :)"];
							}else {
								[self showAlertWithMessage:@"Error :(!"];
							}
						}];
}

-(void)logout{
	[Foursquare removeOAUthAccessTokenAndSecret];
	[self removeFoursqureFromDefaults];
	_passField.hidden = NO;
	_userField.hidden = NO;
	_passField.text = @"";
	_userField.text = @"";
	[_userField becomeFirstResponder];
	logoutButton.hidden = YES;
	checkinButton.hidden = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField == _userField) {
		[_passField becomeFirstResponder];
	}else if (textField == _passField) {
		[self LoginWithUser:_userField.text andPass:_passField.text];
	}
	return NO;
}

#pragma mark -

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_passField release];
	[_userField release];
    [super dealloc];
}

@end
