//
//  SettingViewController.h
//  Maho
//
//  Created by 堤 健 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CopyrightViewController.h"

#define kOurEmailAddress @"support@vovv.me"
#define kEmailSubTitle @"Feedback for vow"
#define kSupportURLForJapanese @"http://www.facebook.com/pages/vow-%E4%BB%8A%E6%97%A5%E3%82%84%E3%82%8B%E3%81%93%E3%81%A8/189566011092003?sk=wall"
#define kSupportURLForEnglish @"http://www.facebook.com/pages/vow-To-Do-Today/212901032083791?sk=wall"
#define kNotificationReloadSecondView @"ReloadSecondView"
#define kTimeInterval @"TimeIntervalInt"

@protocol SettingViewControllerDelegate;
@interface SettingViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    id <SettingViewControllerDelegate> delegate;
    NSArray *timeIntervalArray;
}
@property (nonatomic, retain) id <SettingViewControllerDelegate> delegate;

-(void)showSupportSite;
-(void)setEmail;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(BOOL)isJapanese;
-(void)showCopyrightView;

@end

@protocol SettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(SettingViewController *)controller;
@end
