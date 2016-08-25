@interface SBIconView : UIView
@end
@interface SBIconImageView : UIView
@end
@interface SBFolderBackgroundView : UIView
@end

#include <notify.h>

#import <QuartzCore/QuartzCore.h>

//Preferences

#define registerNotification(c, n) CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (c), CFSTR(n), NULL, CFNotificationSuspensionBehaviorCoalesce);

#define PREFS_DOMAIN @"com.gmoran.circa"
#define PREFS_CHANGED_NOTIF "com.gmoran.circa.prefs-changed"
#define PREFS_FILE_PATH @"/var/mobile/Library/Preferences/com.gmoran.circa.plist"

static NSDictionary *prefs = nil;

extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

static void prefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    // reload prefs
    [prefs release];
    
    //Delete old prefs file
    
    if ((prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFS_FILE_PATH]) == nil) {
        
        NSLog(@"CREATING PREFERENCE FILE");
        
        prefs = @{@"circaEnabled": @NO,
                  @"circaBorderColor": @0
                  };
        
        [prefs writeToFile:PREFS_FILE_PATH atomically:YES];
        prefs = [[NSDictionary alloc] initWithContentsOfFile:PREFS_FILE_PATH];
    }
}

static BOOL circaEnabled(void) {
    //return (prefs) ? [prefs[@"circaEnabled"] boolValue] : NO;
    return YES;

}

static UIColor* borderColor(void) {
    int number = [[prefs objectForKey:@"circaBorderColor"] intValue];
    
    if (number == 0) {
        return [UIColor whiteColor];
    }
    
    else if (number == 1) {
        return [UIColor blackColor];
    }
    
    else {
        return [UIColor whiteColor];
    }
    
}


%hook SBIconView

-(void)setFrame:(CGRect)arg1 {

    %orig;
    if (circaEnabled()) {
        SBIconImageView* imageView =  MSHookIvar<SBIconImageView*>(self, "_iconImageView");
        imageView.layer.cornerRadius = self.frame.size.width / 2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.borderColor = borderColor().CGColor;
    }
}

%end

%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    prefsChanged(NULL, NULL, NULL, NULL, NULL); // initialize prefs
    // register to receive changed notifications
    registerNotification(prefsChanged, PREFS_CHANGED_NOTIF);
    [pool release];
}

