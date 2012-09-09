//
//  EditAlertViewController.m
//  BoardMemo
//
//  Created by Tsutsumi Ken on 12/09/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditAlertViewController.h"

@interface EditAlertViewController ()

@end

@implementation EditAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"EditAlertView_Title", nil);
    
    alertTime = [[NSUserDefaults standardUserDefaults] objectForKey:kAlertTime];
}

- (void)saveAlertSetting
{
    NSLog(@"%s",__FUNCTION__);
    [[NSUserDefaults standardUserDefaults] setObject:alertTime forKey:kAlertTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(alertTime)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *SwitchCellIdentifier = @"SwitchCell";
    
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
        
        if (cell == nil) {		
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 90, 24)];
            if (alertTime) {
                aSwitch.on = YES;
            }
            
            [aSwitch addTarget:self action:@selector(valueChangedOnSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = aSwitch;
        }
        cell.textLabel.text = NSLocalizedString(@"EditAlertView_Cell_Alert", nil);
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = [alertTime timeString];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
    
    if (indexPath.row == 0) 
    {
        
    }
    else 
    {
        [self showDatePicker];
    }
}
#pragma mark - Picker

- (void)showDatePicker
{
    // アクションシートの作成
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                              delegate:self 
                                     cancelButtonTitle:nil 
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    // ツールバーの作成
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
	[toolBar sizeToFit];
    
	// ピッカーの作成
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [datePicker addTarget:self action:@selector(valueChangedOnDatePicker:) forControlEvents:UIControlEventValueChanged];
    datePicker.date = alertTime;
	
	// フレキシブルスペースの作成
	UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                                            target:self 
                                                                            action:nil];
    
	// Doneボタンの作成
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                          target:self 
                                                                          action:@selector(didPushDoneButton)];
	
	NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
	[toolBar setItems:items animated:YES];
	
	// アクションシートへの埋め込みと表示
	[actionSheet addSubview:toolBar];
	[actionSheet addSubview:datePicker];
	[actionSheet showInView:self.view];
	[actionSheet setBounds:CGRectMake(0, 0, 320, 464)];
}

- (void)didPushDoneButton
{
    [self.tableView reloadData];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self saveAlertSetting];
}

#pragma mark - UIDatePicker delegate

- (void)valueChangedOnDatePicker:(UIDatePicker *)datePicker
{
    alertTime = datePicker.date;
    NSLog(@"AlertTime:%@",[alertTime description]);
    NSLog(@"Hour:%i",[alertTime hour]);
    NSLog(@"Minute:%i",[alertTime minute]);
}

#pragma mark - UISwitch delegate

- (void)valueChangedOnSwitch:(UISwitch *)aSwitch
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];

    if ([aSwitch isOn])
    {
        alertTime = [NSDate date];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        alertTime = nil;
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self saveAlertSetting];
}

@end
