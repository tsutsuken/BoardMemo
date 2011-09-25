//
//  UITextViewForMemo.m
//  BoardMemo
//
//  Created by 堤 健 on 11/09/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UITextViewForMemo.h"

@implementation UITextViewForMemo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    /*
	CGContextRef context = UIGraphicsGetCurrentContext();
	NSUInteger contentHeight = rect.size.height; 
	
	CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1);
	CGContextSetLineWidth(context, 0.5);

    CGContextStrokeLineSegments(context, lpoints, 1);

    */
    
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    CGContextMoveToPoint(context, 0, 80);  // 始点
    CGContextAddLineToPoint(context, 320, 80);  // 終点
    CGContextStrokePath(context);  // 描画！
     
}

@end
