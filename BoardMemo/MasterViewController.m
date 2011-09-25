//
//  MasterViewController.m
//  BoardMemo2
//
//  Created by 堤 健 on 11/08/27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize addingManagedObjectContext;
@synthesize masterTableView;
@synthesize customCell;
@synthesize labelForToolBar;
@synthesize infoButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"Board Memo", nil);
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    /*
    UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[button addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    */
    [self.infoButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddMemoView)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.masterTableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.masterTableView.bounces = YES;
    /*
    CGRect viewRect = CGRectMake(0, 0, 100, 100);
    UIView* headerView = [[UIView alloc] initWithFrame:viewRect];
    self.masterTableView.tableHeaderView = headerView;
     */
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     
    [self setTitleOfNavigationBar];
    [self setAddMemoButton];
    self.labelForToolBar.text = [self titleOfToolBar];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)setTitleOfNavigationBar
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"↑下にスワイプしてメモを表示", nil);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor darkGrayColor];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)setAddMemoButton
{
    int countOfMemo = [[self.fetchedResultsController fetchedObjects]  count];
    if (countOfMemo >= 10)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (NSString *)titleOfToolBar
{
    int maxCountOfMemo = 10;
    int countOfMemo = [[self.fetchedResultsController fetchedObjects]  count];
    
    int remainingNumberOfMemo = maxCountOfMemo - countOfMemo;
    
    NSString *title = [NSString localizedStringWithFormat:@"あと%d個、メモを追加できます", remainingNumberOfMemo];//NSLocalizedString(@"あと%d個、メモを追加できます", nil);

    //title = [preMessage stringByAppendingString:actionString];
        
    return title;
}

#pragma mark - TableView

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCell";
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     */
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {		
        [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = self.customCell;
        self.customCell = nil;
        cell.myLabel.numberOfLines = 0;//行数の制限をなしにするため
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.myLabel.text = [managedObject valueForKey:@"text"];
    //cell.textLabel.text = [managedObject valueForKey:@"text"];

    [cell.myLabel sizeToFit];
    CGRect newFrame = cell.myLabel.frame;
    newFrame.size.height = [self tableView:self.masterTableView heightForRowAtIndexPath:indexPath];
    newFrame.size.width = 280;
    cell.myLabel.frame = newFrame;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    //参考URL　http://blog.syuhari.jp/archives/2097
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString* text = [managedObject valueForKey:@"text"];
    UIFont* font = [UIFont systemFontOfSize:13];//CustomCell.xibと合わせる  
    CGSize size = CGSizeMake(280, 1000);//(label.size.width, 1000)
    CGSize textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];//CustomCell.xibと合わせる  
    
    float height;
    float minHeight = 44.0f;
    float maxHeight = 76;
    if (textSize.height <= minHeight) {
        
        height = minHeight;
        
    }
    else {
        if (textSize.height <= maxHeight) {
            
            height = textSize.height;
            
        }
        else{
            
            height = maxHeight;
            
        }
    }
    //NSLog(@"heightForCell:%f",height);
    return height;
    
}  

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //メモの変更を通知センターに反映
        id appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate setMemoToNotificationCenter];

        [self viewWillAppear:NO];//ToolBarと、追加ボタンを更新するため、Viewを再読み込み
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditMemoViewController *controller = [[EditMemoViewController alloc] initWithNibName:@"EditMemoViewController" bundle:nil];
    Memo *memo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    controller.memo = memo;    
    [self.navigationController pushViewController:controller animated:YES];
    
    [masterTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Add New Memo

- (void)showAddMemoView
{
    AddMemoViewController *controller = [[AddMemoViewController alloc] initWithNibName:@"EditMemoViewController" bundle:nil];
    controller.delegate = self;
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
    
	[addingManagedObjectContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    
    controller.memo = (Memo *)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext:addingContext];
    
    controller.memo.timeStamp = [NSDate date];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self presentModalViewController:navController animated:YES];
    
}

- (void)addMemoViewController:(AddMemoViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
        
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];

        [self.masterTableView reloadData];
        
	}
	self.addingManagedObjectContext = nil;
    
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	// Merging changes causes the fetched results controller to update its results
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setMemoToNotificationCenter];//この状態のManagedObjectContextには、まだ新規メモは反映されていない
    
}

#pragma mark - SettingView

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.masterTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.masterTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.masterTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.masterTableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.masterTableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - SettingView

-(void)showSettingView
{
	
	SettingViewController *settingViewController = [[SettingViewController alloc] 
                                                    initWithNibName:@"SettingViewController" bundle:[NSBundle mainBundle]];
    settingViewController.delegate = self;
    settingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [self presentModalViewController:navController animated:YES];
	
}

- (void)settingViewControllerDidFinish:(SettingViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
