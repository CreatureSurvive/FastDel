/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   28-01-2017 12:51:15
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: Tweak.xm
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-07-2017 1:50:29
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#define _plistfile (@"/User/Library/Preferences/com.creaturesurvive.fastdel.plist")
#define _prefsChanged "com.creaturesurvive.fastdel.prefschanged"

// Variables
static bool enabled = YES;
static bool smoothingEnabled;
static double cursorThreshold;
static float cursorAnimSpeed;


// Functions
static void LoadSettings(){
    NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:_plistfile];

    if (preferences == nil) {
        enabled = NO;
    } else {
        enabled = preferences[@"enabled"] ? [preferences[@"enabled"] boolValue] : YES;
        smoothingEnabled = preferences[@"smoothingEnabled"] ? [preferences[@"smoothingEnabled"] boolValue] : YES;
        cursorThreshold = preferences[@"cursorThreshold"] ? [preferences[@"cursorThreshold"] doubleValue] : 0.06;
        cursorAnimSpeed = preferences[@"cursorAnimSpeed"] ? [preferences[@"cursorAnimSpeed"] floatValue] : 0.2;
    }
}

static void TweakReceivedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    NSString *notificationName = (__bridge NSString *)name;
    if ([notificationName isEqualToString:[NSString stringWithUTF8String:_prefsChanged]]) {
        LoadSettings();
    }
}

%group IOS_VERSION_10
%hook UIKeyboardImpl
- (double)timestampOfLastTouchesEnded {
    if (enabled) {
        return 0;
    }
    return %orig;
}

// disable word delete 7.0 - 10.0
- (void)completeHandleAutoDelete {
    if (enabled) {
        return;
    }
    %orig;
}

// adjust delete speed 6.0 - 10.0
- (void)touchAutoDeleteTimerWithThreshold:(double)threshold adjustForPartialCompletion:(BOOL)completion {
    if (enabled) {
        threshold = cursorThreshold;
    }
    %orig(threshold, completion);
}

%end // UIKeyboardImpl

%hook UITextSelectionView
// adjust cursor animation speed ios6 &^
- (void)updateSelectionRects
{
    if (enabled && smoothingEnabled) {
        [UIView animateWithDuration:cursorAnimSpeed animations:^{
            %orig;
        }];
    } else {
        %orig;
    }
}

%end // UITextSelectionView

%end // IOS_VERSION_10

%group IOS_VERSION_7_8_9
%hook UITextSelectionView
// adjust cursor animation speed ios6 &^
- (void)updateSelectionRects
{
    if (enabled && smoothingEnabled) {
        [UIView animateWithDuration:cursorAnimSpeed animations:^{
            %orig;
        }];
    } else {
        %orig;
    }
}

%end // UITextSelectionView

%hook UIKeyboardImpl
// disable word delete 7.0 - 9.3.3
-(void)completeHandleAutoDelete {
    if (enabled) {
        return;
    }
    %orig;
}

// adjust delete speed 6.0 - 9.3.3
- (void)touchAutoDeleteTimerWithThreshold:(double)threshold {
    if (enabled) {
        threshold = cursorThreshold;
    }
    %orig(threshold);
}

%end //UIKeyboardImpl

%end // IOS_VERSION_7_8_9

%group LEGACY_IOS_VERSION
%hook UITextSelectionView
// adjust cursor animation speed ios6 &^
- (void)updateSelectionRects {
    if (enabled && smoothingEnabled) {
        [UIView animateWithDuration:cursorAnimSpeed animations:^{
            %orig;
        }];
    } else {
        %orig;
    }
}

%end // UITextSelectionView

%hook UIKeyboardImpl

// disable word delete ios6 only
-(void)handleAutoDelete {
    if (enabled) {
        return;
    }
    %orig;
}

// adjust delete speed 6.0 - 9.3.3
- (void)touchAutoDeleteTimerWithThreshold:(double)threshold {
    if (enabled) {
        threshold = cursorThreshold;
    }
    %orig(threshold);
}

%end // UIKeyboardImpl

%end // LEGACY_IOS_VERSION

// Initialize
%ctor {
    @autoreleasepool {
        LoadSettings();
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        TweakReceivedNotification,
                                        CFSTR(_prefsChanged),
                                        NULL,
                                        CFNotificationSuspensionBehaviorCoalesce
                                        );

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
            %init(IOS_VERSION_7_8_9);
        } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            %init(IOS_VERSION_10);
        } else {
            %init(LEGACY_IOS_VERSION);
        }
    }
}
