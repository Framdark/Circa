#import <Preferences/Preferences.h>
#import <UIKit/UITableViewCell+Private.h>

@interface circaprefsListController: PSListController {
}
@end

@implementation circaprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"circaprefs" target:self] retain];
	}
	return _specifiers;
}

-(void)respring {
    system("killall -9 backboardd SpringBoard");
}

-(void)twitter {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=fr0st"]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=fr0st"]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/fr0st"]];
    }
}

-(void)mail {
    NSString *url = @"mailto:guillermo@gmoran.me?&subject=Eclipse%20Support";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && [cell respondsToSelector:@selector(_setDrawsSeparatorAtTopOfSection:)]) {
        cell._drawsSeparatorAtTopOfSection = NO;
        cell._drawsSeparatorAtBottomOfSection = NO;
    }
}

@end


