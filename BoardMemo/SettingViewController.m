//
//  SettingViewController.m
//  Maho
//
//  Created by 堤 健 on 11/03/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"


@implementation SettingViewController

@synthesize delegate;

#pragma mark - Memory management

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Information", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                                            target:self action:@selector(closeSettingView:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSString *titleForHeader;
    
    if (section == 0)
    {
        titleForHeader = NSLocalizedString(@"SettingView_SectionHeader_Setting", nil);
    }
    else
    {
        titleForHeader = NSLocalizedString(@"SettingView_SectionHeader_Support", nil);
    }
    
    return titleForHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {		
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"SettingView_Cell_Alert", nil);
    }
    else
    {
        cell.textLabel.text = NSLocalizedString(@"Email Us", nil);
    }
    
       return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self showEditAlertView];
    }
    else
    {
        [self showFeedbackView];
    }
}

#pragma mark - CloseSettingView

- (void)closeSettingView:(id)sender
{
    [self.delegate settingViewControllerDidFinish:self];
}

#pragma mark - Support

-(void)showSupportSite
{
    if ([self isJapanese]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSupportURLForJapanese]];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kSupportURLForEnglish]];
    }
}

-(void)showEditAlertView
{
    EditAlertViewController *controller = [[EditAlertViewController alloc] initWithNibName:@"EditAlertViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)showCopyrightView
{
    CopyrightViewController *controller = [[CopyrightViewController alloc] initWithNibName:@"CopyrightViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)showStartGuideView
{
    StartGuideViewController *controller = [[StartGuideViewController alloc] initWithNibName:@"StartGuideViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)showFeedbackView
{
    AAMFeedbackViewController *vc = [[AAMFeedbackViewController alloc]init];
    vc.toRecipients = [NSArray arrayWithObject:kSupportEMailAddress];
    vc.ccRecipients = nil;
    vc.bccRecipients = nil;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentModalViewController:nvc animated:YES];
}

-(BOOL)isJapanese
{
    BOOL isJapanese;
    NSUserDefaults *defs = [NSUserDefaults  standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"ja"]) {
        isJapanese = YES;
    } else {
        isJapanese = NO;
    }
    return isJapanese;
}

@end
