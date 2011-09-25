//
//  WidgetController.m
//  BoardMemo
//
//  Created by 堤 健 on 11/09/22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WidgetController.h"

@implementation WidgetController

@synthesize _view;

- (UIView *)view
{
    if (_view == nil)
    {
        _view = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316, 71)];
        
        //UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeAppTest.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:71];
        UIImage *bg = [UIImage imageNamed:@"Icon.png"];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
        bgView.frame = CGRectMake(0, 0, 316, 71);
        [_view addSubview:bgView];
        //[bgView release];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 316, 71)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.text = @"Hello World";
        lbl.textAlignment = UITextAlignmentCenter;
        [_view addSubview:lbl];
        //[lbl release];
    }
    
    return _view;
}

- (float)viewHeight
{
    return 71.0f;
}

@end
