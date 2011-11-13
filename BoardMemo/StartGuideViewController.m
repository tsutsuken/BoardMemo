//
//  StartGuideViewController.m
//  BoardMemo
//
//  Created by 堤 健 on 11/10/09.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "StartGuideViewController.h"

@implementation StartGuideViewController

@synthesize myScrollView;
@synthesize myPageControl;
@synthesize nextButton;
@synthesize isFirstLaunch;

const int kNumberOfImages = 3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Start Guide", nil);
    [self setScrollView];
    
    if (isFirstLaunch) {
        [self setDoneButton];
    }
}

- (void)setDoneButton
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showAppSettingAlert)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setScrollView
{
    myScrollView.delegate = self;
    
    int i;
    CGFloat xPosition = 0;
	for (i = 1; i <= kNumberOfImages; i++)
	{
		//NSString *imageName = [NSString stringWithFormat:@"ImageForStartGuide_%d.png", i];
        NSString *imageName = [NSString stringWithFormat:NSLocalizedString(@"ImageForStartGuide_en_%d.png", nil), i];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect = imageView.frame;
        rect.origin = CGPointMake(xPosition, 0);
		imageView.frame = rect;
		[myScrollView addSubview:imageView];
        
        xPosition += myScrollView.frame.size.width;//次の画像の描画位置を、ScrollViewの幅だけ、横にずらす。
        
	}
    myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * kNumberOfImages, 372);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{  
    CGFloat pageWidth = myScrollView.frame.size.width;  
    myPageControl.currentPage = floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//よくわかってない
    
    if (myPageControl.currentPage == kNumberOfImages-1) {
        nextButton.enabled = NO;
    }
    else{
        nextButton.enabled = YES;
    }
}

- (IBAction)changeImage 
{ 
    CGRect frame = myScrollView.frame;  
    frame.origin.x = frame.size.width * myPageControl.currentPage;  
    frame.origin.y = 0;  
    [myScrollView scrollRectToVisible:frame animated:YES];  
    
}
- (IBAction)goToNextImage 
{ 
    CGRect frame = myScrollView.frame;  
    frame.origin.x = frame.size.width * (myPageControl.currentPage+1);  
    frame.origin.y = 0;  
    [myScrollView scrollRectToVisible:frame animated:YES];  
    
}
/*
 - (void)showAppSettingAlert
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知センターの設定", nil) 
 message:NSLocalizedString(@"通知センターに表示するメモの数を変更しますか？\n※初期設定では５件です。", nil)
 delegate:self 
 cancelButtonTitle:NSLocalizedString(@"後で変更", nil) 
 otherButtonTitles:NSLocalizedString(@"今すぐ変更", nil), nil];
 
 [alert show];
 }
 */
- (void)showAppSettingAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Setting of Notification Center", nil) 
                                                    message:NSLocalizedString(@"Do you change the number of notes displayed on Notification Center?\n※Default is 5", nil)
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Later", nil) 
                                          otherButtonTitles:NSLocalizedString(@"Change now", nil), nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//Cancel
        
    }
    else{//Yes
        [self showAppSettingView];
    }
    
    [self closeView];
    
}

- (void)showAppSettingView
{ 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID&path=BoardMemo"]];
}

@end
