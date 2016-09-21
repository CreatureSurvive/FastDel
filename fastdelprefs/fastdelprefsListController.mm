@interface PSListController : NSObject {
    id _specifiers;
}

- (id)loadSpecifiersFromPlistName:(NSString *)name target:(id)target;
@end

@interface fastdelprefsListController: PSListController
@end

@implementation fastdelprefsListController
- (id)specifiers {
		if(_specifiers == nil) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"fastdelprefs" target:self] retain];
		}
		return _specifiers;
}

@end
