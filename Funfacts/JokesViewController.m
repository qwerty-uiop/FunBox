//
//  JokesViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import "JokesViewController.h"
#import "HomeViewController.h"
NSMutableArray *fps;
@interface JokesViewController ()
@property (strong, nonatomic) IBOutlet UIView *joke_displyView;
@property (weak, nonatomic) IBOutlet UITextView *fact_text;
@end

@implementation JokesViewController
@synthesize fact_text;
HomeViewController * home_view;
NSInteger count;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    count=0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_bttnclk:(id)sender {
    home_view =[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil ];
    
    [self presentViewController: home_view animated: NO completion:nil];
}

- (IBAction)prvjoke:(id)sender{
    if (count>0) {
    NSString *fact_txt=[[fps objectAtIndex:count-1]objectAtIndex:1] ;
    fact_text.text=fact_txt;
    fact_text.font=[UIFont fontWithName:@"Georgia-Bold" size:22.0];
    [UIView beginAnimations: @ "animationID" context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.joke_displyView cache: YES];
    [UIView commitAnimations  ];
    count--;
    }
}

- (IBAction)nextjoke:(id)sender{
    if (count<fps.count) {
    
   NSString *fact_txt=[[fps objectAtIndex:count]objectAtIndex:1] ;
    fact_text.text=fact_txt;
    fact_text.font=[UIFont fontWithName:@"Georgia-Bold" size:22.0];
    [UIView beginAnimations: @ "animationID" context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.joke_displyView cache: YES];
    [UIView commitAnimations  ];
        count++;
    }
}

@end
