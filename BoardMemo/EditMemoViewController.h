//
//  EditMemoViewController.h
//  BoardMemo
//
//  Created by 堤 健 on 11/09/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <QuartzCore/QuartzCore.h>
#import "Memo.h"
#import "BoardMemoAppDelegate.h"

@class Memo;

@interface EditMemoViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *textViewForMemo;
}

@property (nonatomic, retain) UITextView *textViewForMemo;
@property (nonatomic, retain) Memo *memo;

- (void)closeViewByCancel;
- (void)showConfirmAlert;

@end
