//
//  RectButtonView.m
//  DrectViewProject
//
//  Created by joser on 13-6-25.
//  Copyright (c) 2013年 joser. All rights reserved.
//

#import "RectButtonView.h"

@implementation RectButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self drawView];
    }
    return self;
}
-(void)drawView
{
    CGContextRef ref=UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ref, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextStrokePath(ref);
    CGContextFillPath(ref);


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
