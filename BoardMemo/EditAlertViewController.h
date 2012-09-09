//
//  EditAlertViewController.h
//  BoardMemo
//
//  Created by Tsutsumi Ken on 12/09/04.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAlertViewController : UITableViewController<UIActionSheetDelegate>
{
    UIActionSheet *actionSheet;
    NSDate *alertTime;
}

@end
