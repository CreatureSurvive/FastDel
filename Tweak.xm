#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

//Preference Setup
@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//Preference Variables
static NSString *domainString = @"com.creaturecoding.fastdelprefs";
static NSString *notificationString = @"com.creaturecoding.fastdelprefs/preferences.changed";

//Variables
static BOOL enableTweak = YES;
static double speed = 0.08;

//Tweak Code
@interface UIKeyboardImpl
	+(id)sharedInstance;
@end

%hook UIKeyboardImpl

-(void)completeHandleAutoDelete {
	if(enableTweak == YES){
		return;
	}
	%orig;
}

-(void)touchAutoDeleteTimerWithThreshold:(double)threshold {
	if (enableTweak == YES){
		threshold = speed;
	}
	%orig(threshold);
}
%end;

//Preferences
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

	NSNumber *a = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enableTweak" inDomain:domainString];
	enableTweak = (a)? [a boolValue]:YES;
	NSString *b = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"speed" inDomain:domainString];
	speed = (b)? [b doubleValue]:0.08;
}

//Receiver for preferences
%ctor {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//Register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	[pool release];
}
