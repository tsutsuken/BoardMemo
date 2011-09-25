//
//  BoardMemoAppDelegate.h
//  BoardMemo
//
//  Created by 堤 健 on 11/08/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"

#define kObjectIdForNotification @"objectId"

@interface BoardMemoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setMemoToNotificationCenter;
- (void)deleteMemoFromNotificationCenter;
- (NSMutableArray *)memoArray;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
