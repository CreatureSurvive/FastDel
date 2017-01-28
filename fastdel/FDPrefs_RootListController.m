#include "FDPrefs_RootListController.h"

@implementation FDPrefs_RootListController
// static UIColor *_prefsTintColor;

- (id)init {
    if ((self = [super init]) != nil) {
        _settings = [NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ? : [NSMutableDictionary dictionary];
    }

    return self;
}

// gets the specifiers from Root.plist
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    return _specifiers;
}

- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled {
    UITableViewCell *cell = [self tableView:self.table cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.userInteractionEnabled = enabled;
        cell.textLabel.enabled = enabled;
        cell.detailTextLabel.enabled = enabled;

        if ([cell isKindOfClass:[PSControlTableCell class]]) {
            PSControlTableCell *controlCell = (PSControlTableCell *)cell;
            if (controlCell.control) {
                controlCell.control.enabled = enabled;
            }
        }
    }
}

- (void)setViewTintColors {
    //sets the tintcolors for the settings pane
    _prefsTintColor = [UIColor colorWithRed:0.2905 green:0.5632 blue:0.8872 alpha:1.0000];

    self.view.tintColor = _prefsTintColor;
    self.navigationController.navigationBar.tintColor = _prefsTintColor;
    // [[self.UIView appearance] setTintColor:_prefsTintColor];

    [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = _prefsTintColor;
    // [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _prefsTintColor;
    // [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _prefsTintColor;
    // [[UINavigationBar appearance] setBarTintColor:_prefsTintColor];
    // [[UINavigationBar appearance] setTranslucent:NO];

    self.edgesForExtendedLayout = UIRectEdgeAll;                                                             //UIRectEdgeNone

    self.view.tintColor = _prefsTintColor;
}

- (void)setViewBanner {

    CGRect frame = CGRectMake(0, 0, self.table.bounds.size.width, 128);
    UIColor *bannerBackgroundColor = [UIColor clearColor];
    NSString *bannerLGString = @"FastDel";
    NSString *bannerSMString = @"by: CreatureSurvive";

    UITextView *bannerTitleText = [[UITextView alloc] initWithFrame:frame];
    NSMutableAttributedString *bannerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", bannerLGString, bannerSMString]];

    [bannerString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:60.0]
                         range:NSMakeRange(0, [bannerLGString length])];

    [bannerString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:20.0]
                         range:NSMakeRange([bannerLGString length], [bannerSMString length]+1)];

    bannerTitleText.attributedText = bannerString;
    bannerTitleText.textContainerInset = UIEdgeInsetsMake(20.0, 10.0, 44.0, 10.0);
    bannerTitleText.textColor = _prefsTintColor;
    bannerTitleText.textAlignment = 1;
    bannerTitleText.backgroundColor = bannerBackgroundColor;
    [bannerTitleText setUserInteractionEnabled:NO];
    [bannerTitleText setContentMode:UIViewContentModeScaleAspectFit];
    [bannerTitleText setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    self.table.tableHeaderView = bannerTitleText;
}

- (void)viewWillAppear:(BOOL)animated {
    _settings = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ? : [NSMutableDictionary dictionary]);
    [super viewWillAppear:animated];
    [self reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewTintColors];
    [self setViewBanner];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];

    // if ([cell isKindOfClass:[PSSwitchTableCell class]]) {
    //  UISwitch *contactSwitch = (UISwitch *)((PSControlTableCell *)cell).control;
    //  contactSwitch.onTintColor = self.navigationController.navigationBar.tintColor;
    // }
    cell.textLabel.textColor = _prefsTintColor;
    return cell;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    _settings = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ? : [NSMutableDictionary dictionary]);
    [_settings setObject:value forKey:key];
    [_settings writeToFile:_plistfile atomically:YES];

    if ([key isEqualToString:@"enabled"]) {
        BOOL enableCell = [value boolValue];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] enabled:enableCell];
    }

    NSString *post = [specifier propertyForKey:@"PostNotification"];
    if (post) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)post, NULL, NULL, TRUE);
    }
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    id defaultValue = [specifier propertyForKey:@"default"];
    id plistValue = [_settings objectForKey:key];
    if (!plistValue) plistValue = defaultValue;

    if ([key isEqualToString:@"enabled"]) {
        BOOL enableCell = plistValue && [plistValue boolValue];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] enabled:enableCell];
    }

    return plistValue;
}

// Respring methon
- (void)respring {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FastDel"
                                                                             message:@"Do you want to respring now?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                             style:UIAlertActionStyleCancel
                                           handler:nil];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Respring"
                                         style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction *action) {
                                                                                                                                                                                                                                                                                                                                                                        #pragma GCC diagnostic push
                                                                                                                                                                                                                                                                                                                                                                        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        system("killall -9 SpringBoard");
                                                                                                                                                                                                                                                                                                                                                                        #pragma GCC diagnostic pop
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];

    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];

    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];

    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];

    else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
}

@end
