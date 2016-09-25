#include "FDPRootListController.h"

@implementation FDPRootListController

- (id)specifiers {
	if(_specifiers == nil) {
		//dlopen("/System/Library/PreferenceBundles/AccessibilitySettings.bundle/AccessibilitySettings", RTLD_LAZY | RTLD_NOLOAD);
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

@end
