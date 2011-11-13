//
//  StartGuideViewController.h
//  BoardMemo
//
//  Created by 堤 健 on 11/10/09.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartGuideViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *myScrollView;
    IBOutlet UIPageControl *myPageControl; 
    IBOutlet UIBarButtonItem *nextButton; 
    
}

@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UIPageControl *myPageControl; 
@property (nonatomic, retain) UIBarButtonItem *nextButton;
@property (nonatomic, assign) BOOL isFirstLaunch;

- (void)setScrollView;
- (void)setDoneButton;
- (void)showAppSettingAlert;
- (void)showAppSettingView;

@end
