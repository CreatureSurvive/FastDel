//prefs
#define PREFS_BUNDLE_ID (@"com.creaturecoding.fdprefs")

NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creaturecoding.fastdel.plist"];

static bool enabled = [[prefs objectForKey:@"Enabled"] boolValue];
static bool smoothingEnabled = [[prefs objectForKey:@"smoothingEnabled"] boolValue];
static double cursorThreshold = [[prefs objectForKey:@"cursorThreshold"] doubleValue];
static float cursorAnimSpeed = [[prefs objectForKey:@"cursorAnimSpeed"] floatValue];

static void reloadPrefs() {
	dispatch_async(dispatch_get_main_queue(), ^{
		prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creaturecoding.fastdel.plist"];

		enabled = [[prefs objectForKey:@"Enabled"] boolValue];
		smoothingEnabled = [[prefs objectForKey:@"smoothingEnabled"] boolValue];
		cursorThreshold = [[prefs objectForKey:@"cursorThreshold"] doubleValue];
		cursorAnimSpeed = [[prefs objectForKey:@"cursorAnimSpeed"] floatValue];
	});
}

// // Tweak Code

// donet even know if i need this
// @interface UIKeyboardImpl
// 	+(id)sharedInstance;
// @end
%group latest
	%hook UIKeyboardImpl
		// disable word delete 7.0 - 9.3.3
		-(void)completeHandleAutoDelete {
			if(enabled){
				return;
			}
			%orig;
		}

		// adjust delete speed 6.0 - 9.3.3
		-(void)touchAutoDeleteTimerWithThreshold:(double)threshold {
			if (enabled){
				threshold = cursorThreshold;
			}
			%orig(threshold);
		}
	%end
%end

%group ios6
	%hook UIKeyboardImpl

		// disable word delete ios6 only
		-(void)handleAutoDelete {
			if(enabled){
				return;
			}
			%orig;
		}

		// adjust delete speed 6.0 - 9.3.3
		-(void)touchAutoDeleteTimerWithThreshold:(double)threshold {
			if (enabled){
				threshold = cursorThreshold;
			}
			%orig(threshold);
		}
	%end
%end

%hook UITextSelectionView
	// adjust cursor animation speed ios6 &^
	- (void)updateSelectionRects
	{
		if (enabled && smoothingEnabled) {
				[UIView animateWithDuration:cursorAnimSpeed animations:^{
					%orig;
			}];
		}else {
			%orig;
		}
	}

%end


// load prefs
%ctor {
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        %init(latest);
    } else {
        %init(ios6);
    }
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.creaturecoding.fastdel.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
