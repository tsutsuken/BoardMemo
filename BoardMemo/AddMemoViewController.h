//
//  AddMemoViewController.h
//  BoardMemo
//
//  Created by 堤 健 on 11/09/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EditMemoViewController.h"

@protocol AddMemoViewControllerDelegate;

@interface AddMemoViewController : EditMemoViewController

@property (nonatomic, assign) id <AddMemoViewControllerDelegate> delegate;

@end

@protocol AddMemoViewControllerDelegate
- (void)addMemoViewController:(AddMemoViewController *)controller didFinishWithSave:(BOOL)save;
@end