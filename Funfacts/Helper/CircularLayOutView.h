//
//  CircularLayOutView.h
//  DrectViewProject
//
//  Created by joser on 13-6-21.
//  Copyright (c) 2013年 joser. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircularLayOutViewDelegate <NSObject>

-(void)buttonClick:(NSString *)buttonName;
@end
@class XYPoint;
@interface CircularLayOutView : UIView
{
    float cos_a;
    NSMutableArray *pointArray;
    NSTimer *annimationTimer;
    int count;
    int current;
    float animationTime;
    UIView *currentView;
    UIButton *currentButton;
    int currentIndex;
    
}
@property (nonatomic,unsafe_unretained)id <CircularLayOutViewDelegate>MyDelegate;
@property (nonatomic,assign) int buttonCount;
@property (nonatomic,retain) id tager;
@property (nonatomic,retain) XYPoint *centerPoint;
@property (nonatomic,assign) float radius;
@property (nonatomic,retain) XYPoint *buttonWeightAndHeight;
-(void)creatUIToView:(UIView *)view target:(id)target;
@property (nonatomic,retain) NSArray *buttonIndexNameArray;
@property (nonatomic,retain) NSArray *buttonIndexBackGroundArray;
@end
