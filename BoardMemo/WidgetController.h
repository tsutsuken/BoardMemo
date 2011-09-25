//
//  WidgetController.h
//  BoardMemo
//
//  Created by 堤 健 on 11/09/22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBWeeAppController-Protocol.h"

@interface WidgetController : NSObject<BBWeeAppController>

@property (nonatomic, retain) UIView *_view;
- (UIView *)view;
@end
