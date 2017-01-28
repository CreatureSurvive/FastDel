#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
// #import <Preferences/PSLinkCell.h>
// #import <Preferences/PSSegmentCell.h>
#define _plistfile (@"/User/Library/Preferences/com.creaturesurvive.fastdel.plist")
#define _prefsChanged (@"com.creaturesurvive.fastdel.prefschanged")
#define _bundleID (@"com.creaturesurvive.fastdel")


@interface FDPrefs_RootListController : PSListController {
    NSMutableDictionary *_settings;
    UIColor *_prefsTintColor;
}

- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled;
@end
