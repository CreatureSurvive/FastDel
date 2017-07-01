/**
 * @Author: Dana Buehre <creaturesurvive>
 * @Date:   28-01-2017 12:51:15
 * @Email:  dbuehre@me.com
 * @Project: motuumLS
 * @Filename: FDPrefs_RootListController.m
 * @Last modified by:   creaturesurvive
 * @Last modified time: 01-07-2017 2:43:00
 * @Copyright: Copyright © 2014-2017 CreatureSurvive
 */


#include "FDPrefs_RootListController.h"

@implementation FDPrefs_RootListController

#pragma mark Initialize
// Initialize the settings dictionary
- (id)init {
    if ((self = [super init]) != nil) {
        _settings = [NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ? : [NSMutableDictionary dictionary];
    }

    return self;
}

// return the specifiers from .plist
- (id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

    return _specifiers;
}

#pragma mark Load View

// tint the view after it loads
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTintEnabled:YES];
    [self setupHeader];
}

// remove tint wen leaving the view
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setTintEnabled:NO];
}

// sets the tint colors for the view
- (void)setTintEnabled:(BOOL)enabled {
    if (enabled) {
        // Color the navbar
        self.navigationController.navigationController.navigationBar.tintColor = _accentTintColor;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : _accentTintColor};

        // set specific cell colors
        [UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = _accentTintColor;
        [UITableView appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _accentTintColor;
        [UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = _accentTintColor;

        // set the view tint
        self.view.tintColor = _accentTintColor;
    } else {
        // Un-Color the navbar when leaving the view
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

    }
}

// adds the header to the view
- (void)setupHeader {

    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.table.bounds), 128);

    NSString *titleString = @"FastDel", *subString = @"by: CreatureSurvive";

    UITextView *headerView = [[UITextView alloc] initWithFrame:frame];
    NSMutableAttributedString *headerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", titleString, subString]];

    // sets the font for the titleString
    [headerString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:60.0]
                         range:NSMakeRange(0, [titleString length])];
    // sets the font for the subString
    [headerString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:20.0]
                         range:NSMakeRange([titleString length], [subString length]+1)];

    headerView.attributedText = headerString;
    headerView.textContainerInset = UIEdgeInsetsMake(20.0, 10.0, 44.0, 10.0);
    headerView.textColor = _accentTintColor;
    headerView.textAlignment = 1;
    headerView.backgroundColor = [UIColor clearColor];
    headerView.userInteractionEnabled = NO;
    headerView.contentMode = UIViewContentModeScaleAspectFit;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.table.tableHeaderView = headerView;
}

#pragma mark UITableView

// Adjust labels when loading the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    cell.textLabel.textColor = _accentTintColor;
    return cell;
}

// make sure that the control for the cell is enabled/disabled when the cell is enabled/disabled
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

// dismiss keyboard when scrolling begins
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:NO];

}

#pragma mark Preferences

// writes the preferences to disk after setting additionally posts a notification
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    _settings = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ? : [NSMutableDictionary dictionary]);
    [_settings setObject:value forKey:key];
    [_settings writeToFile:_plistfile atomically:YES];

    [self setCellsEnabled:[value boolValue] forKey:key];

    NSString *post = [specifier propertyForKey:@"PostNotification"];
    if (post) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge CFStringRef)post, NULL, NULL, TRUE);
    }
}

// returns the settings from disk when loading else reads default
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSString *key = [specifier propertyForKey:@"key"];
    id defaultValue = [specifier propertyForKey:@"default"];
    id plistValue = [_settings objectForKey:key];
    if (!plistValue) plistValue = defaultValue;

    [self setCellsEnabled:[plistValue boolValue] forKey:key];

    return plistValue;
}

// enable/disable cells
- (void)setCellsEnabled:(BOOL)enabled forKey:(NSString *)key {
    if ([key isEqualToString:@"enabled"]) {
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] enabled:enabled];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] enabled:enabled];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] enabled:enabled];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] enabled:enabled];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] enabled:enabled];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] enabled:enabled];
    }
}

#pragma mark PSSpecifier Actions
// respring action
- (void)respring {
    UIAlertAction *cancelAction, *okAction;
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"FastDel"
                                                          message:@"Are you sure you want to respring?"
                                                   preferredStyle:UIAlertControllerStyleActionSheet];

    cancelAction = [UIAlertAction
                    actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                            handler:nil];

    okAction = [UIAlertAction
                actionWithTitle:@"Respring"
                          style:UIAlertActionStyleDestructive
                        handler:^(UIAlertAction *action) {
        pid_t pid;
        int status;
        const char *args[] = {"killall", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
        waitpid(pid, &status, WEXITED);
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// email action
- (void)contact {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:support@creaturecoding.com?subject=FastDel%20v0.3"]];
}

// launch github
- (void)github {
    [self openURLInBrowser:@"https://github.com/CreatureSurvive/FastDel"];
}

// launch paypal
- (void)paypal {
    [self openURLInBrowser:@"https://paypal.me/creaturesurvive"];
}

// launch twitter
- (void)twitter {
    [self openURLInBrowser:@"https://mobile.twitter.com/creaturesurvive"];
}

#pragma mark Utility

// opens the specified url in SFSafariViewController
- (void)openURLInBrowser:(NSString *)url {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:NO];
    [self presentViewController:safari animated:YES completion:nil];
}

@end
