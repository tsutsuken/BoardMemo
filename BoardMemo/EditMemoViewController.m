//
//  EditMemoViewController.m
//  BoardMemo
//
//  Created by 堤 健 on 11/09/10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EditMemoViewController.h"

@implementation EditMemoViewController

@synthesize textViewForMemo;
@synthesize memo;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    //[textViewForMemo setNeedsDisplay];//textViewForMemoに引いた罫線を、一緒にスクロールさせるため
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"Edit Memo", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                            target:self action:@selector(finish:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                           target:self action:@selector(cancel:)];
    self.textViewForMemo.autoresizingMask = UIViewAutoresizingFlexibleHeight;//親ビューの高さが変更された時に追従するようにする
    
    self.textViewForMemo.text = memo.text;
    self.navigationItem.rightBarButtonItem.enabled = NO;//TextViewが編集されるまで、保存ボタンは押せない様にする
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //キーボード表示・非表示の通知の開始。参考URL:http://www.lancard.com/blog/2010/04/06/dont-want-hide-uitextview-behind-keyboard/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //キーボード表示・非表示の通知を終了
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - TextViewDelegate

//キーボードが表示された場合
- (void)keyboardWillShow:(NSNotification *)aNotification 
{
    
    //キーボードのCGRectを取得
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [[self.view superview] convertRect:keyboardRect fromView:nil];
    
    //キーボードのanimationDurationを取得
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //メインビューの高さをキーボードの高さ分マイナスしたframe
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardRect.size.height;
    
    //キーボードアニメーションと同じ間隔でメインビューの高さをアニメーションしつつ変更する。
    //これでUITextViewも追従して高さが変わる。
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textViewForMemo.frame = frame;
    [UIView commitAnimations];
    
}

//キーボードが非表示にされた場合（keyboardWillShowと同じことを高さを+してやっているだけ）
- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [[self.view superview] convertRect:keyboardRect fromView:nil];
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect frame = self.view.frame;
    frame.size.height += keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textViewForMemo.frame = frame;
    [UIView commitAnimations];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (self.navigationItem.rightBarButtonItem.enabled == NO) 
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;//TextViewが編集されるまで、保存ボタンは押せない様にする
    }
    
}


#pragma mark - CloseAddPromiseView

- (void)finish:(id)sender 
{
    memo.text = textViewForMemo.text;
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setMemoToNotificationCenter];
    
    NSLog(@"textViewから挿入されたメモ:%@",textViewForMemo.text);
    
    NSError *error = nil;
    if (![memo.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender 
{
    if (self.navigationItem.rightBarButtonItem.enabled == YES) {
        [self showConfirmAlert];
    }
    else{
        [self closeViewByCancel];
    }
    
}

- (void)closeViewByCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertView

- (void)showConfirmAlert
{
    NSString *message = NSLocalizedString(@"Really discard changes?",nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Discard changes?", nil) message:message
                                                   delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
	[alert show];	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self closeViewByCancel];
    }
}

@end
