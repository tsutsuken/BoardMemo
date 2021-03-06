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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeView)];
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
        NSString *imageName = [NSString stringWithFormat:NSLocalizedString(@"ImageForStartGuide_en_%d.png", nil), i];//画像名を翻訳する
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

- (void)showAppSettingAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notification Center Settings", nil) 
                                                    message:NSLocalizedString(@"Do you want to change the number of items that appear in Notification Center?\n*The default setting is set to 5 entries.", nil)
                                                   delegate:self 
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeView];
}

- (void)showAppSettingView
{ 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID&path=BoardMemo"]];
}

@end
