
//prefs
#define PREFS_BUNDLE_ID (@"com.creatix.fdprefs")

NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creaturecoding.fastdel.plist"];

static bool enabled = [[prefs objectForKey:@"Enabled"] boolValue];
// static bool smoothingEnabled = [[prefs objectForKey:@"smoothingEnabled"] boolValue];
static double cursorThreshold = [[prefs objectForKey:@"cursorThreshold"] doubleValue];
static float cursorAnimSpeed = [[prefs objectForKey:@"cursorAnimSpeed"] floatValue];

static void reloadPrefs() {
	dispatch_async(dispatch_get_main_queue(), ^{
		prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creaturecoding.fastdel.plist"];

		enabled = [[prefs objectForKey:@"Enabled"] boolValue];
		// smoothingEnabled = [[prefs objectForKey:@"smoothingEnabled"] boolValue];
		cursorThreshold = [[prefs objectForKey:@"cursorThreshold"] doubleValue];
		cursorAnimSpeed = [[prefs objectForKey:@"cursorAnimSpeed"] floatValue];
	});
}

//Tweak Code
@interface UIKeyboardImpl
	+(id)sharedInstance;
@end

%hook UIKeyboardImpl

-(void)completeHandleAutoDelete {
	if(enabled){
		return;
	}
	%orig;
}

-(void)touchAutoDeleteTimerWithThreshold:(double)threshold {
	if (enabled){
		threshold = cursorThreshold;
	}
	%orig(threshold);
}
%end;

%hook UITextSelectionView

- (void)updateSelectionRects
{
	if (enabled) {
		// if (smoothingEnabled) {
			[UIView animateWithDuration:cursorAnimSpeed animations:^{
				%orig;
		}];
		// }
	}else {
		%orig;
	}
}

%end

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.creaturecoding.fastdel.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
