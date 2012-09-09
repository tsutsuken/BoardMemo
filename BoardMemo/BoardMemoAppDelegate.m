//
//  BoardMemoAppDelegate.m
//  BoardMemo
//
//  Created by 堤 健 on 11/08/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BoardMemoAppDelegate.h"

#import "MasterViewController.h"

@implementation BoardMemoAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIApplication *app = [UIApplication sharedApplication];
    app.statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Appirater appLaunched:YES];

    MasterViewController *controller = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //http://cdn-ak.f.st-hatena.com/images/fotolife/g/glass-_-onion/20100702/20100702221856.png
    //通常起動時のみ
    NSLog(@"%s",__FUNCTION__);
    [Appirater appEnteredForeground:YES];
    
    [self cancelAlert];
    [self setMemoToNotificationCenter];
}
/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    //通常起動＆通知センターからの復帰時に呼ばれる
    NSLog(@"%s",__FUNCTION__);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //通常終了＆通知センター表示時にも呼ばれる
    NSLog(@"%s",__FUNCTION__);
}
*/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //通常終了時のみ
    NSLog(@"%s",__FUNCTION__);
    [self setAlertIfNeeded];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%s",__FUNCTION__);
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BoardMemo" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BoardMemo.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - SetMemoToNotificationCenter

- (void)setMemoToNotificationCenter
{
    [self deleteMemoFromNotificationCenter];//メモがダブらないように
    
    NSMutableArray *memoArray = [self memoArray];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    for (int i = 0; i< [memoArray count]; i++) 
    {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil){
            return;
        }
        NSString *message = [[memoArray objectAtIndex:i] valueForKey:@"text"];
        
        localNotif.alertBody = message;
        localNotif.hasAction = NO;
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        [app scheduleLocalNotification:localNotif];
        //[app presentLocalNotificationNow:localNotif];
    }
    
    app.applicationIconBadgeNumber = [memoArray count];
    NSLog(@"BadgeNumber = %i",app.applicationIconBadgeNumber);
}

- (void)deleteMemoFromNotificationCenter
{
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    NSLog(@"BadgeNumber = 0");
}

- (NSMutableArray *)memoArray
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder"
                                                                   ascending:NO];//MasterViewではYesにする。通知センターでの順番をそろえるため。
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    NSMutableArray *memoArray = [fetchedObjects mutableCopy];

    return memoArray;
}

#pragma mark - Alert

- (void)setAlertIfNeeded
{
    NSLog(@"%s",__FUNCTION__);
    
    if ([self shouldSetAlert])
    {
        [self setAlert];
    }
}

- (void)cancelAlert
{
    NSLog(@"%s",__FUNCTION__);
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (BOOL)shouldSetAlert
{
    NSLog(@"%s",__FUNCTION__);
    
    //アラームがオンになっているか？
    
    NSDate *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey:kAlertTime];
    
    if (!alertTime)
    {
        NSLog(@"NO:Alert is Off");
        return NO;
    }
    else
    {
        NSLog(@"YES");
        return YES;
    }
}

- (void)setAlert
{
    NSLog(@"%s",__FUNCTION__);
    
    NSMutableArray *memoArray = [self memoArray];
    NSDate *baseOfAlertDate = [self baseOfAlertDate];
    NSTimeInterval aDay = 60*60*24;
    int repeatTimesOfAlert = 5;
    
    //下記を、指定した間隔で繰り返す
    
    for (int i = 0; i < repeatTimesOfAlert; i++)
    {
        for (int j = 0; j< [memoArray count]; j++) 
        {
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil)
                return;
            
            NSString *message = [[memoArray objectAtIndex:j] valueForKey:@"text"];
            localNotif.alertBody = message;
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.hasAction = NO;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            localNotif.fireDate = [NSDate dateWithTimeInterval:(aDay*i) sinceDate:baseOfAlertDate];
            //localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            NSLog(@"FireDate_%i_%i:%@",i,j,[localNotif.fireDate description]);
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    }
    NSLog(@"ScheduledAlert:%i",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
}

- (NSDate *)baseOfAlertDate
{
    NSDate *baseOfAlertDate;
    
    NSDate *alertTime = [[NSUserDefaults standardUserDefaults] objectForKey:kAlertTime];
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *dateComp = [cal components:unitFlags fromDate:currentDate];
    
    [dateComp setHour:[alertTime hour]];
    [dateComp setMinute:[alertTime minute]];
    baseOfAlertDate = [cal dateFromComponents:dateComp];
    
    if ([baseOfAlertDate timeIntervalSinceDate:currentDate] < 0)//アラームの時間が過ぎていた場合
    {
        [dateComp setDay:[dateComp day] + 1];
        baseOfAlertDate = [cal dateFromComponents:dateComp];
    }
    
    NSLog(@"baseOfAlertDate:%@",[baseOfAlertDate description]);
    
    return baseOfAlertDate;
}

@end
