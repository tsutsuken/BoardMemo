//
//  SettingViewController.h
//  Maho
//
//  Created by 堤 健 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AAMFeedbackViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "CopyrightViewController.h"
#import "StartGuideViewController.h"
#import "EditAlertViewController.h"

#define kSupportEMailAddress @"support@ken22.me"
#define kOurEmailAddress @"support@vovv.me"
#define kEmailSubTitle @"Feedback for BoardMemo"
#define kSupportURLForJapanese @"http://www.facebook.com/pages/Board-Memo/286621484689683"
#define kSupportURLForEnglish @"http://www.facebook.com/pages/Board-Memo/286621484689683"

@protocol SettingViewControllerDelegate;
@interface SettingViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    id <SettingViewControllerDelegate> delegate;
    NSArray *timeIntervalArray;
}
@property (nonatomic, retain) id <SettingViewControllerDelegate> delegate;

-(void)showSupportSite;
-(BOOL)isJapanese;
-(void)showCopyrightView;
-(void)showStartGuideView;

@end

@protocol SettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(SettingViewController *)controller;
@end
