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
#import "StartGuideViewController.h"

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
-(void)setEmail;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(BOOL)isJapanese;
-(void)showAppSettingView;
-(void)showCopyrightView;
-(void)showStartGuideView;

@end

@protocol SettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(SettingViewController *)controller;
@end
