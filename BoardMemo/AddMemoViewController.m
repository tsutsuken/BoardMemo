//
//  AddMemoViewController.m
//  BoardMemo
//
//  Created by 堤 健 on 11/09/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AddMemoViewController.h"

@implementation AddMemoViewController
@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"New Memo", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                           target:self action:@selector(finish:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                          target:self action:@selector(cancel:)];
    self.textViewForMemo.text = self.memo.text;
    self.navigationItem.rightBarButtonItem.enabled = NO;//TextViewが編集されるまで、保存ボタンは押せない様にする
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textViewForMemo becomeFirstResponder];
}


#pragma mark - CloseAddPromiseView

- (void)finish:(id)sender {
    
    //AddMemoの時だけ、MemoのセットはMasterViewで行う（このタイミングでは、MemoがManagedObjectContextに反映されていないため）
    self.memo.text = textViewForMemo.text;
    
    [delegate addMemoViewController:self didFinishWithSave:YES];
    
}

- (void)closeViewByCancel
{
    [delegate addMemoViewController:self didFinishWithSave:NO];
}


@end
