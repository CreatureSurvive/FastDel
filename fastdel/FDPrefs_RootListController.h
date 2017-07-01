/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   28-01-2017 12:51:15
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: FDPrefs_RootListController.h
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-07-2017 2:12:01
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSwitchTableCell.h>
#import <SafariServices/SafariServices.h>
#include <spawn.h>

#define _plistfile (@"/User/Library/Preferences/com.creaturesurvive.fastdel.plist")
#define _prefsChanged (@"com.creaturesurvive.fastdel.prefschanged")
#define _bundleID (@"com.creaturesurvive.fastdel")

#define _accentTintColor [UIColor colorWithRed:0.2905 green:0.5632 blue:0.8872 alpha:1.0000]

@interface FDPrefs_RootListController : PSListController <UITableViewDelegate>{
    NSMutableDictionary *_settings;
    UIColor *_prefsTintColor;
}
@end
