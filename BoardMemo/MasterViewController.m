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
        self.title = NSLocalizedString(@"Memo List", nil);
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
    
    [self.infoButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddMemoView)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.masterTableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.masterTableView.bounces = YES;

#warning test
    /*
    if ([self isFirstLaunch]) {
        [self showStartGuideView];
    }
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     
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

- (void)setAddMemoButton
{
    if (self.editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else{
        int countOfMemo = [[self.fetchedResultsController fetchedObjects]  count];
        if (countOfMemo >= 10){
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

- (NSString *)titleOfToolBar
{
    int maxCountOfMemo = 10;
    int countOfMemo = [[self.fetchedResultsController fetchedObjects] count];
    
    int remainingNumberOfMemo = maxCountOfMemo - countOfMemo;
    
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"You can add %d more memos", nil), remainingNumberOfMemo];
        
    return title;
}

#pragma mark - TableView

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
    UIFont* font = [UIFont boldSystemFontOfSize:13];//CustomCell.xibと合わせる  
    CGSize size = CGSizeMake(280, 1000);//(label.size.width, 1000)
    CGSize textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];//CustomCell.xibと合わせる  
    
    float height;
    float minHeight = 44.0f;
    float maxHeight = 76;
    float space = 12;
    if (textSize.height <= minHeight) {
        
        height = minHeight;
        
    }
    else {
        if (textSize.height <= maxHeight) {
            
            height = textSize.height+space;
            
        }
        else{
            
            height = maxHeight+space;
            
        }
    }
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
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    
        [self viewWillAppear:NO];//ToolBarと、追加ボタンを更新するため、Viewを再読み込み
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditMemoViewController *controller = [[EditMemoViewController alloc] initWithNibName:@"EditMemoViewController" bundle:nil];
    Memo *memo = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    controller.memo = memo;    
    [self.navigationController pushViewController:controller animated:YES];
    
    [masterTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark  Edit

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    //削除した時に、追加可能になってしまう
    //setAddMemoに統合する？？
    [super setEditing:editing animated:animated];
    [self.masterTableView setEditing:editing animated:YES];
    [self setAddMemoButton];
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath 
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    //http://stackoverflow.com/questions/1648223/how-can-i-maintain-display-order-in-uitableview-using-core-data
    //セルを移動した時に影響を受けたセルの、displayOrderを変更（+1もしくは-1）
    NSUInteger fromRow = fromIndexPath.row;
    NSUInteger toRow = toIndexPath.row;
    
    Memo *movingMemo = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromRow];  
    movingMemo.displayOrder =  [[NSNumber alloc] initWithInteger:toRow];;
    
    NSInteger start,end;
    int delta;
    
    if (fromRow == toRow) {//セルを移動させなかった場合
        return;
    }
    else if (fromRow < toRow){//セルを下に移動させた場合
        delta = -1;
        start = fromRow + 1;
        end = toRow;
    }
    else {//セルを上に移動させた場合
        delta = 1;
        start = toRow;
        end = fromRow - 1;
    }
    NSLog(@"Change Displey Order from cellAtIndex:%i to cellAtIndex:%i", start, end);  
    
    for (NSUInteger i = start; i <= end; i++) {
        Memo *aMemo = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];  
        NSLog(@"Displey Order changed from %i to %i", [aMemo.displayOrder intValue], [aMemo.displayOrder intValue]+delta); 
        
        int newdisplayOrderInt = [aMemo.displayOrder intValue] + delta;
        aMemo.displayOrder =  [[NSNumber alloc] initWithInt:newdisplayOrderInt];
        
    }
}

- (void)refreshDisplayOrder 
{      
    //Memo.displayOrderに空白があった場合に、空白を埋める
    //通知センターに変更を反映する前に、呼び出される    
    NSLog(@"Refresh display order because of deleting of cell");
    NSUInteger index = 0;
    NSArray * fetchedObjects = [self.fetchedResultsController fetchedObjects];
    
    Memo * aMemo = nil;           
    for (aMemo in fetchedObjects) 
    {
        aMemo.displayOrder = [NSNumber numberWithInt:index];
        index++;
    }
    
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
    
    int countOfMemo = [[self.fetchedResultsController fetchedObjects] count];
    controller.memo.displayOrder = [[NSNumber alloc] initWithInt:countOfMemo];
    NSLog(@"Display Order = %i",countOfMemo);
    //controller.memo.timeStamp = [NSDate date];
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
- (void)addControllerContextDidSave:(NSNotification*)saveNotification 
{	
	// Merging changes causes the fetched results controller to update its results
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
}

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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
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
            [self refreshDisplayOrder];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.masterTableView endUpdates];
#warning sendmemo
    
     //メモの変更を通知センターに反映
    id appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate setMemoToNotificationCenter];
}


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

#pragma mark - ShowStartGuide

- (void)showStartGuideView
{
    StartGuideViewController *controller = [[StartGuideViewController alloc] initWithNibName:@"StartGuideViewController" bundle:nil];
    controller.isFirstLaunch = YES;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:NO];
    
}

#pragma mark - isFirstLaunch

- (BOOL)isFirstLaunch
{
    BOOL isLaunchedPast = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLaunchedPast"];
    
    if(isLaunchedPast) {
        return NO;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLaunchedPast"];
        return YES;
    }
    
}


@end
