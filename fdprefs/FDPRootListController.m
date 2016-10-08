#include "FDPRootListController.h"
#import <Preferences/PSSpecifier.h>


@implementation FDPRootListController

// gets the specifiers from Root.plist
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

// Respring methon
- (void)respring {
	#pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	system("killall -9 SpringBoard");
	#pragma GCC diagnostic pop
}

// launch Github
- (void)github {
	NSURL *githubURL = [NSURL URLWithString:@"https://github.com/creaturesurvive"];
	[[UIApplication sharedApplication] openURL:githubURL];
}

// launch Email
- (void)contact {
	NSURL *url = [NSURL URLWithString:@"mailto:dbuehre@gmail.com?subject=FastDel"];
	[[UIApplication sharedApplication] openURL:url];
}

// launch PayPal
- (void)paypal {
	NSURL *url = [NSURL URLWithString:@"https://paypal.me/creaturesurvive"];
	[[UIApplication sharedApplication] openURL:url];
}

// launch Twitter
- (void)twitter {
	NSString *user = @"creaturesurvive";
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

// - (void)viewDidAppear:(BOOL)arg1 {
// 	UINavigationController *navController = self.navigationController;
// 	[navController popViewControllerAnimated:YES];
// }
@end
