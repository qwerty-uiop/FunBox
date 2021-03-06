//
//  FactsViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 QWERTYUIOP. All rights reserved.
//

#import "FactsViewController.h"
#import "HomeViewController.h"
#import "GHContextMenuView.h"
#import "UIView+Toast.h"
NSMutableArray *fps;
NSString *temp_txt;
@interface FactsViewController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *joke_displyView;
@property (weak, nonatomic) IBOutlet UILabel *fact_countLbl;
@property (weak, nonatomic) IBOutlet UITextView *fact_text;
@end


@implementation UITextView (DisableCopyPaste)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end


@implementation FactsViewController
@synthesize fact_text,fact_countLbl;
HomeViewController * home_view;
NSDictionary *temp_dict;
int currentIndex,totCount;
NSMutableDictionary *fdata;
NSArray *fav_array;
NSString *path;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path])
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"favorites" ofType:@"plist"];
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        fdata=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
        fav_array=[fdata objectForKey:@"fact_id"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![[[NSUserDefaults standardUserDefaults]
          stringForKey:@"firststart"] isEqualToString:@"true"])
    {
        [[NSUserDefaults standardUserDefaults]
         setObject:@"true" forKey:@"firststart"];
        
        [self.view addSubview:_helpView];
    }
    
    
    
    //    Context menu Init
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    [self.fact_text setUserInteractionEnabled:YES];
    [fact_text addGestureRecognizer:_longPressRecognizer];
    currentIndex=0;
    temp_dict=[[NSDictionary alloc]initWithDictionary:[[master_data objectForKey:@"head"] objectForKey:g_category] ];
    
    totCount=[[temp_dict objectForKey:@"record" ]count];
    fact_countLbl.text=[NSString stringWithFormat:@"1/%d",totCount];
    fact_text.text=[self getMessageAtIndex:currentIndex];
    [_favBtn setImage:[self isAlreadyInFavourites]?[UIImage imageNamed:@"heart_minus"]:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
    
    
}
-(NSString*)getMessageAtIndex:(int)index
{
    NSString* message=[NSString stringWithFormat:@"%@",[[[[temp_dict objectForKey:@"record"]  objectAtIndex:index]objectForKey:@"message"]valueForKey:@"text"]];
    return message;
}
-(NSString*)getMessageIndexAtIndex:(int)index
{
    NSString* message=[NSString stringWithFormat:@"%@",[[[[temp_dict objectForKey:@"record"]  objectAtIndex:index]objectForKey:@"index"]valueForKey:@"text"]];
    return message;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)DismissHelpFn:(id)sender {
    [_helpView removeFromSuperview];
}

- (IBAction)back_bttnclk:(id)sender {
    home_view =[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil ];
    
    [self presentViewController: home_view animated: NO completion:nil];
}
- (IBAction)prvfact:(id)sender{
    
    currentIndex--;
    if(currentIndex<0)
    {
        currentIndex=totCount-1;
    }
    [UIView beginAnimations: @ "animationID" context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.joke_displyView cache: YES];
    [UIView commitAnimations  ];
    fact_countLbl.text=[NSString stringWithFormat:@"%d/%d",currentIndex+1,totCount];
    fact_text.text=[self getMessageAtIndex:currentIndex];
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
    [_favBtn setImage:[self isAlreadyInFavourites]?[UIImage imageNamed:@"heart_minus"]:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
}

- (IBAction)nextfact:(id)sender{
    
    currentIndex++;
    if(currentIndex==totCount)
    {
        currentIndex=0;
    }
    [UIView beginAnimations: @ "animationID" context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses: NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.joke_displyView cache: YES];
    [UIView commitAnimations  ];
    fact_countLbl.text=[NSString stringWithFormat:@"%d/%d",currentIndex+1,totCount];
    fact_text.text=[self getMessageAtIndex:currentIndex];
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
    [_favBtn setImage:[self isAlreadyInFavourites]?[UIImage imageNamed:@"heart_minus"]:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    
}

- (IBAction)favourite_bttnClkd:(id)sender {
    
    
    
    if(![self isAlreadyInFavourites])
    {
        [[fdata valueForKey:@"fact_id"]  addObject:[self getMessageIndexAtIndex:currentIndex]];
        
        [fdata writeToFile:path atomically:YES];
        
        [self.view makeToast:@"Added to favourites"
                    duration:0.5
                    position:@"center"];
        
        [_favBtn setImage:[self isAlreadyInFavourites]?[UIImage imageNamed:@"heart_minus"]:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        
    }
    else{
        
        [[fdata valueForKey:@"fact_id"]  removeObject:[self getMessageIndexAtIndex:currentIndex]];
        
        [fdata writeToFile:path atomically:YES];
        //        [fav_temparray2 removeObject:[fav_temparray2 objectAtIndex:p]] ;
        [self.view makeToast:@"Sucesfully removed from favourites"
                    duration:0.5
                    position:@"center"];
        [_favBtn setImage:[self isAlreadyInFavourites]?[UIImage imageNamed:@"heart_minus"]:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
}


-(BOOL)isAlreadyInFavourites
{
    
    fdata=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    fav_array=[fdata objectForKey:@"fact_id"];
    
    if(![fav_array containsObject:[self getMessageIndexAtIndex:currentIndex]])
    {
        return false;
        
    }
    else{
        return true;
    }
    
    
}
#pragma mark - Initialize context methods
- (NSInteger) numberOfMenuItems
{
    return 4;
}
-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"facebook";
            break;
        case 1:
            imageName = @"twitter";
            break;
        case 2:
            imageName = @"SmsBtn";
            break;
        case 3:
            imageName = @"EmailBtn";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    //    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            [self ShareViaFbFn];
            break;
        case 1:
            [self ShareViaTwitterFn];
            break;
        case 2:
            [self SendSmsFn];
            break;
        case 3:
            [self SendMailFn];
            
        default:
            break;
    }
    
    
}
#pragma mark - Share methods
- (void)SendSmsFn {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSString * message = fact_text.text ;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    
    [self presentViewController:messageController animated:YES completion:nil];
    
    
}

- (void)SendMailFn {
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString * message = @"FunBox";
    
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    [messageController setSubject:message];
    [messageController setMessageBody:fact_text.text isHTML:NO ];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)ShareViaFbFn {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"FubBox-%@",fact_text.text]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Service not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)ShareViaTwitterFn {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"FubBox-%@",fact_text.text]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Service not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    switch (result) {
        case MessageComposeResultCancelled: break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oups, error while sendind SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
            break;
            
        case MessageComposeResultSent: break;
            
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MessageComposeResultCancelled: break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oups, error while sendind Mail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
            break;
            
        case MessageComposeResultSent: break;
            
        default: break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
