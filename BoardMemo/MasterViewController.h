//
//  MasterViewController.h
//  BoardMemo
//
//  Created by 堤 健 on 11/08/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditMemoViewController.h"
#import "AddMemoViewController.h"
#import "Memo.h"
#import "CustomCell.h"
#import "SettingViewController.h"
#import "AdMakerView.h"
#import "StartGuideViewController.h"

#define kSiteIDForAdMaker @"1644"
#define kZoneIDForAdMaker @"4158"
#define kURLForAdMaker @"http://images.ad-maker.info/apps/fi3t9wof983z.html"

@class Memo;

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate,UITableViewDelegate, UITableViewDataSource,AddMemoViewControllerDelegate,SettingViewControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *masterTableView;
    IBOutlet UILabel *labelForToolBar;
    IBOutlet UIButton *infoButton;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *masterTableView;
@property (nonatomic, assign) IBOutlet CustomCell *customCell;
@property (nonatomic, retain) IBOutlet UILabel *labelForToolBar;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) AdMakerView *AdMaker;

- (void)setTitleOfNavigationBar;
- (void)setAddMemoButton;
- (NSString *)titleOfToolBar;
- (void)setAdMaker;
- (void)showStartGuideView;
- (BOOL)isFirstLaunch;
- (void)refreshDisplayOrder;

@end
