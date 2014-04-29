//
//  CircularLayOutView.m
//  DrectViewProject
//
//  Created by joser on 13-6-21.
//  Copyright (c) 2013年 joser. All rights reserved.
//

#import "CircularLayOutView.h"
#import "XYPoint.h"
@implementation CircularLayOutView
@synthesize buttonCount;
@synthesize tager;
@synthesize centerPoint;
@synthesize radius;
@synthesize buttonWeightAndHeight;
@synthesize buttonIndexNameArray;
@synthesize buttonIndexBackGroundArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//-(id)creatUIToView:(UIView *)view
//{
//    self =[super init];
//    if(self )
//    {
//    
//    
//    }
//    return self;
//}
-(void)creatUIToView:(UIView *)view target:(id)target
{
    currentView=view;
    //self.buttonCount=12;
    for (int i=0;i<self.buttonCount+1;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame=CGRectMake(self.centerPoint.xPoint-self.buttonWeightAndHeight.xPoint/2, self.centerPoint.yPoint-self.buttonWeightAndHeight.yPoint/2, 0, 0);
        btn.tag=100+i;
        
        if(self.buttonIndexNameArray.count>i)
        {
            [btn setTitle:[self.buttonIndexNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor clearColor ] forState:UIControlStateNormal];
        }
        if(self.buttonIndexBackGroundArray.count>i)
        {
        
        [btn setBackgroundImage:[self.buttonIndexBackGroundArray objectAtIndex:i] forState:UIControlStateNormal];
        
        }
//        [btn setBackgroundColor:[UIColor greenColor]];
       // [btn setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        
            //UIViewController *viewController=(UIViewController *)[self getResponser];
        //        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(<#selector#>)]
        [btn addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
      
        //        [btn performSelector:@selector(buttonClick2:) withObject:nil withObject:nil];
        [view addSubview:btn];
        
    }
    cos_a=(360/self.buttonCount)*0.5/180;
    
    pointArray=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.buttonCount; i++)
    {
        XYPoint *firstPoint;
        if(!firstPoint)
        {
            firstPoint=[[XYPoint alloc] init];
            firstPoint.xPoint=self.centerPoint.xPoint;
            firstPoint.yPoint=self.centerPoint.yPoint;
            
        }
        XYPoint *lasterPoint=[self returnRect:firstPoint other:i];
        [pointArray addObject:lasterPoint];
        // firstPoint=lasterPoint;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    for (int i=0; i<self.buttonCount+1; i++)
    {
        UIButton *btn=(UIButton *)[view viewWithTag:100+i];
        
        
        [btn setBounds:CGRectMake(0, 0, self.buttonWeightAndHeight.xPoint, self.buttonWeightAndHeight.yPoint)];
        if(i<self.buttonCount)
        {
        XYPoint *btnPoint=(XYPoint *)[pointArray objectAtIndex:i];
        [btn setCenter:CGPointMake(btnPoint.xPoint, btnPoint.yPoint)];
        }
        else
        {
            [btn setCenter:CGPointMake(self.centerPoint.xPoint, self.centerPoint.yPoint)];
        }
    }
    [UIView commitAnimations];
    [self performSelector:@selector(changeColor) withObject:nil afterDelay:0.5];
    
    
}
-(void)changeColor
{
    for(int i=0;i<self.buttonCount+1;i++)
    {
        UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
       // [btn setTitle:[NSString stringWithFormat:@"%d",btn.tag] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor ] forState:UIControlStateNormal];
    }

    
    [self reloadViewUI];
}
-(UIViewController *)getResponser
{
    for (UIView *view =[self superview];view;view=view.superview)
    {
        UIResponder *re=[view nextResponder];
        if([re isKindOfClass:[UIViewController class]])
        {
        
            return (UIViewController *)re;
        }
        
    }
    return nil;
}
-(XYPoint *)returnRect:(XYPoint *)point other:(int)other
{
    int r = self.radius;
    //    float  nextPointX;
    //    float nextPointY;
    float y = point.yPoint - r * sin(M_PI/2+ M_PI * 2 / self.buttonCount * other );
    float x = point.xPoint + r* cos(M_PI/2+ M_PI * 2 / self.buttonCount * other );
    
    //    float a=cos_a*other+M_PI_2;
    //
    //
    //    NSLog(@"%lf", cos(a)*100.0);
    //     NSLog(@"%lf",sin(a)*100.0);
    //    nextPointX=cos(a)*100.0+160;
    //    nextPointY=230-sin(a)*100.0;
    XYPoint *point1 =[[XYPoint alloc] init];
    point1.xPoint=x;
    point1.yPoint=y;
    return point1;
    
    
}
-(void)buttonClick2:(id)sender
{
    
     UIButton *btn=(UIButton *)sender;
    if(btn.tag==100)
    {
        [self.MyDelegate buttonClick:currentButton.titleLabel.text];
        return;
    }
    else if (btn.tag==100+self.buttonCount)
    {
    
        [self.MyDelegate buttonClick:btn.titleLabel.text];
        return;
    }
    UIButton *hidenButton=(UIButton *)[currentView viewWithTag:self.buttonCount+100];
    hidenButton.hidden=YES;
    UIButton *firstButton=(UIButton *)[currentView viewWithTag:100];
   // [firstButton setBounds:CGRectMake(0, 0, self.buttonWeightAndHeight.xPoint, self.buttonWeightAndHeight.yPoint)];
    currentButton=btn;
    currentIndex=btn.tag-100;
    XYPoint *buttonPoint=[[XYPoint alloc] init];
    buttonPoint.xPoint=btn.frame.origin.x;
    buttonPoint.yPoint=btn.frame.origin.y;
    BOOL  Left=[self isLeft:buttonPoint];
    [self moveAnimation:Left point:buttonPoint index:btn.tag-100];
       

//    [self.MyDelegate buttonClick:btn.titleLabel.text];
    
}
-(void)moveAnimation:(BOOL)isLeft point:(XYPoint *)point  index:(int)index
{
    NSLog(@"Value %f",point.xPoint);
    NSLog(@"Value %d",index);
    float time=cos_a*(index)*180;
    count=time;
    time=5/time;
    animationTime=time;
      if(isLeft)
      {
          NSTimer *annimationTimer1=[NSTimer scheduledTimerWithTimeInterval:0.5/180 target:self selector:@selector(leftMove:) userInfo:self repeats:YES];
          [annimationTimer1 fire];
        
          
      }
    else
    {
        
        NSTimer *annimationTimer1=[NSTimer scheduledTimerWithTimeInterval:0.5/180 target:self selector:@selector(rightMove:) userInfo:self repeats:YES];
        [annimationTimer1 fire];
    
    }


}
-(void)reloadViewUI
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    NSString *name;
    UIImage *img;
    for (int i=0; i<self.buttonCount+1; i++)
    {
        UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
        if(btn.tag==100)
        {
            name=btn.titleLabel.text;
            img=[btn backgroundImageForState:UIControlStateNormal];
        }

        if( btn.tag==self.buttonCount+100)
        {
            [btn setBounds:CGRectMake(0, 0, 60, 60)];
            if(btn.tag==self.buttonCount+100)
            {
                [btn setTitle:name forState:UIControlStateNormal];
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                btn.hidden=YES;
            }
        
        }
        else
        {
            [btn setBounds:CGRectMake(0, 0, self.buttonWeightAndHeight.xPoint, self.buttonWeightAndHeight.yPoint)];
        
        }
    }
    [UIView commitAnimations];
    
   
  if(currentButton)
  {
//      [UIView animateWithDuration:2 animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>]
      [UIView animateWithDuration:0.2
                       animations:^{
                           currentButton.frame = CGRectMake(currentButton.frame.origin.x-25,currentButton.frame.origin.y-25,currentButton.frame.size.width+50, currentButton.frame.size.height+50);
                       }
                       completion:^(BOOL finished) {
                           [UIView animateWithDuration:0.2
                                            animations:^{
                                                currentButton.frame = CGRectMake(currentButton.frame.origin.x+25,currentButton.frame.origin.y+25,currentButton.frame.size.width-50, currentButton.frame.size.height-50);
                                            }
                                            completion:^(BOOL finished) {
                                                [self.MyDelegate buttonClick:currentButton.titleLabel.text];
                                            }];

                       }];
      
//
    }

}
-(void)leftMove:(NSTimer*)timer
{
    current++;
    //NSLog(@"x=%d y=%d",currentButton.center.x,currentButton.center.y);
    int currentButtonCenterX=currentButton.center.x;
    int currentButtonCenterY=currentButton.center.x;
    //NSLog(@"%ld==%ld",lroundf(1.4),lroundf(1.6));
    
    if(currentButtonCenterX >k_DeviceWidth/2   && currentButtonCenterY>130)
    {
        [timer invalidate];
        UIButton *hidenButton=(UIButton *)[currentView viewWithTag:self.buttonCount+100];
        hidenButton.hidden=NO;
        current=0;
        NSMutableArray *tagArray=[[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *btnArray=[[NSMutableArray alloc] initWithCapacity:0];
        NSLog(@"Value %d",self.buttonCount);
        for (int i=0; i<self.buttonCount; i++)
        {
            UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
            int a=currentIndex;
            int tagCount=btn.tag-a;
            
            if(tagCount<100)
            {
                tagCount=tagCount+self.buttonCount;
            
            }
            [tagArray addObject:[NSNumber numberWithInt:tagCount]];
            [btnArray addObject:btn];
            
        }
        for (int i=0; i<btnArray.count; i++)
        {
            UIButton *btn=(UIButton *)[btnArray objectAtIndex:i];
            [btn setTag:[[tagArray objectAtIndex:i] intValue]];
//            [btn setTitle:[NSString stringWithFormat:@"%d",btn.tag
//                           ] forState:UIControlStateNormal];
            
        }
        [self reloadViewUI];
        return;
    }
    for (int i=0; i<self.buttonCount; i++)
    {
        UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
        XYPoint *point=[[XYPoint alloc] init];
        point.xPoint=btn.center.x;
        point.yPoint=btn.center.y;
       [self moveThePoint:YES point:point btn:btn];
    }
   // NSLog(@"%d",current);

}
-(void)rightMove:(NSTimer *)timer
{
    current++;
    int currentButtonCenterX=currentButton.center.x;
    int currentButtonCenterY=currentButton.center.x;
        if(currentButtonCenterX<=k_DeviceWidth/2)
    {
        [timer invalidate];
        UIButton *hidenButton=(UIButton *)[currentView viewWithTag:self.buttonCount+100];
        hidenButton.hidden=NO;
        current=0;
        NSMutableArray *tagArray=[[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *btnArray=[[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<self.buttonCount; i++)
        {
            UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
            int a=currentIndex;
            int tagCount=btn.tag-a;
            
            if(tagCount<100)
            {
                tagCount=tagCount+self.buttonCount;
                
            }
            [tagArray addObject:[NSNumber numberWithInt:tagCount]];
            [btnArray addObject:btn];
            
        }
        for (int i=0; i<btnArray.count; i++)
        {
            UIButton *btn=(UIButton *)[btnArray objectAtIndex:i];
            [btn setTag:[[tagArray objectAtIndex:i] intValue]];
//            [btn setTitle:[NSString stringWithFormat:@"%d",btn.tag
//                           ] forState:UIControlStateNormal];
            
        }
        [self reloadViewUI];
        return;
    }
    for (int i=0; i<self.buttonCount; i++)
    {
        UIButton *btn=(UIButton *)[currentView viewWithTag:100+i];
        XYPoint *point=[[XYPoint alloc] init];
        point.xPoint=btn.center.x;
        point.yPoint=btn.center.y;
        [self moveThePoint:NO point:point btn:btn];
    }
   // NSLog(@"222222");


}
#define rad2deg(x)  ( (x) * 180 / 3.14159265358979323846264338327950288 )
#define deg2rad(x)  ( (x) * 3.14159265358979323846264338327950288 / 180 )

-(XYPoint *)moveThePoint:(BOOL)isLeft point:(XYPoint *)point btn:(UIButton *)btn
{
    XYPoint *resoult;
     if(isLeft)
     {
         int number=[self returnNumber:point];
         XYPoint *newPoint=[[XYPoint alloc] init];
//         NSLog(@"%")
         double cos_A1=acos((point.xPoint-self.centerPoint.xPoint)/self.radius);
         //double sin_A1=asin((230-point.yPoint)/100);
         switch (number) {
             case 1:
             {
                 cos_A1=cos_A1;
             }
                 break;
             case 2:
             {
                 cos_A1=cos_A1;
             }
                 break;
             case 3:
             {
                 cos_A1=2*M_PI- cos_A1;
             }
                 break;
             case 4:
             {
                 cos_A1=2*M_PI- cos_A1;
             }
                 break;
                 
             default:
                 break;
         }
         double cos_A2=cos_A1-1.0/180;
         if(cos_A2<0)
         {
             cos_A2=2*M_PI- cos_A1-1.0/180;
         
         }
         //double sin_A2=sin_A1-1.0/180;
        //         NSLog(@"%f",sin(abc));
         newPoint.xPoint=cos(cos_A2)*self.radius+self.centerPoint.xPoint;
         newPoint.yPoint=self.centerPoint.yPoint-sin(cos_A2)*self.radius;
         resoult=newPoint;
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:animationTime];
         [btn setCenter:CGPointMake(resoult.xPoint, resoult.yPoint)];
         if( btn.tag==self.buttonCount+100)
         {
         
             [btn setBounds:CGRectMake(0, 0, 60, 60)];
         }
         else
         {
             [btn setBounds:CGRectMake(0, 0, self.buttonWeightAndHeight.xPoint, self.buttonWeightAndHeight.yPoint)];
         
         }
         
         // NSLog(@"%d=",current);
         [UIView commitAnimations];
         
     
     }
    else
    {
        int number=[self returnNumber:point];
        XYPoint *newPoint=[[XYPoint alloc] init];
        //         NSLog(@"%")
        double cos_A1=acos((point.xPoint-self.centerPoint.xPoint)/self.radius);
        //double sin_A1=asin((230-point.yPoint)/100);
        switch (number) {
            case 1:
            {
                cos_A1=cos_A1;
            }
                break;
            case 2:
            {
                cos_A1=cos_A1;
            }
                break;
            case 3:
            {
                cos_A1=2*M_PI- cos_A1;
            }
                break;
            case 4:
            {
                cos_A1=2*M_PI- cos_A1;
            }
                break;
                
            default:
                break;
        }
        double cos_A2=cos_A1+1.0/180;
        if(cos_A2<0)
        {
            cos_A2=2*M_PI- cos_A1+1.0/180;
            
        }
        //double sin_A2=sin_A1-1.0/180;
        //         NSLog(@"%f",sin(abc));
        newPoint.xPoint=cos(cos_A2)*self.radius+self.centerPoint.xPoint;
        newPoint.yPoint=self.centerPoint.yPoint-sin(cos_A2)*self.radius;
        resoult=newPoint;

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationTime];
       [btn setCenter:CGPointMake(resoult.xPoint, resoult.yPoint)];
       // NSLog(@"%d=",current);
        [UIView commitAnimations];
    
    }
    return resoult;
}
-(int)returnNumber:(XYPoint *)point
{
    int resoultNumber;
    float x=point.xPoint-self.centerPoint.xPoint;
    float y=self.centerPoint.yPoint-point.yPoint;
    if(x>=0 && y>=0)
    {
        resoultNumber=1;
    }
    else if (x<=0 && y>=0)
    {
    
        resoultNumber=2;
    }
    else if (x<=0 && y<=0)
    {
        
        resoultNumber=3;
    }
    else 
    {
        
        resoultNumber=4;
    }
    
    return resoultNumber;


}
-(BOOL)isLeft:(XYPoint *)point
{
    BOOL isLeft=NO;
    if(point.xPoint<=self.centerPoint.xPoint)
    {
        isLeft=YES;
        
    }
    
    return isLeft;

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
