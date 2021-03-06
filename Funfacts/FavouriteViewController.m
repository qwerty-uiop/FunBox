//
//  FavouriteViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 QWERTYUIOP. All rights reserved.
//

#import "FavouriteViewController.h"
#import "HomeViewController.h"
#import "GHContextMenuView.h"
#import "UIView+Toast.h"

BOOL pub,ip,bol=YES;
NSString *pub_fact,*fav_txt;
NSArray *fav_array;
NSMutableArray *fav_temparray1,*fav_temparray2,*fps;
;
NSInteger p=0,fc=0;
@interface FavouriteViewController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@end

@implementation UITextView (DisableCopyPaste)

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end

@implementation FavouriteViewController
@synthesize fav_view;
HomeViewController * home_view;
NSArray *fav_index_array;
NSMutableArray *fav_index_message_array;
int current_index;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSInteger) numberOfMenuItems
{
    if(fav_index_message_array.count==0)
    {
        return 0;
    }
    else
    {
        return 4;
    }
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    current_index=0;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self RefreshView];
    
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    [fav_view setUserInteractionEnabled:YES];
    [fav_view addGestureRecognizer:_longPressRecognizer];
    
    
    
}
-(void)RefreshView
{
    [self parsefunct];
    [self getFavValuesInDict];
    
    if(current_index>=[fav_index_message_array count])
    {
        current_index=0;
    }
    if([fav_index_message_array count]<=0)
    {
        _countLabel.hidden=YES;
    }
    else
    {
        _countLabel.hidden=NO;
    }
    
    
    if(fav_index_message_array.count==0)
    {
        
        fav_view.text=@"Add facts to favorites";
        
        
        [fav_view setUserInteractionEnabled:NO];
    }
    else{
        
        fav_view.text=[[fav_index_message_array objectAtIndex:current_index]objectAtIndex:1];
    }
    
    _countLabel.text=[NSString stringWithFormat:@"%d/%d",current_index+1,[fav_index_message_array count]];
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}
-(void)getFavValuesInDict
{
    fav_index_message_array=[[NSMutableArray alloc]init];
    
    NSArray* tagValuesArray=[[NSArray alloc]initWithObjects:@"jokes",@"facts",@"twisters", nil];
    for(int i=0;i<3;i++)
    {
        NSDictionary* tmp1=[[master_data objectForKey:@"head"] objectForKey:[tagValuesArray objectAtIndex:i]];
        for(int j=0;j<[[tmp1 objectForKey:@"record"] count];j++)
        {
            
            if([fav_index_array containsObject:[[[[tmp1 objectForKey:@"record"] objectAtIndex:j]objectForKey:@"index"]valueForKey:@"text"]])
            {
                NSArray* tArray=[[NSArray alloc]initWithObjects:[[[[tmp1 objectForKey:@"record"] objectAtIndex:j]objectForKey:@"index"]valueForKey:@"text"],[[[[tmp1 objectForKey:@"record"] objectAtIndex:j]objectForKey:@"message"]valueForKey:@"text"], nil];
                [fav_index_message_array addObject:tArray];
            }
        }
    }
}
-(void)parsefunct{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"favorites" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *fdata=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    fav_index_array=[fdata objectForKey:@"fact_id"];
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back_bttnclk:(id)sender {
    home_view =[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil ];
    
    [self presentViewController: home_view animated: NO completion:nil];
}

- (IBAction)prv_fact:(id)sender {
    if([fav_index_message_array count]>0)
    {
        current_index--;
        if(current_index<0)
        {
            current_index=[fav_index_message_array count]-1;
        }
        
        [UIView beginAnimations: @ "animationID" context: nil];
        [UIView setAnimationDuration: 0.7f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses: NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.displayView cache: YES];
        [UIView commitAnimations  ];
        
        
        
        _countLabel.text=[NSString stringWithFormat:@"%d/%d",current_index+1,[fav_index_message_array count]];
        fav_view.text=[[fav_index_message_array objectAtIndex:current_index]objectAtIndex:1];
    }
    
    
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}

- (IBAction)next_fact:(id)sender {
    
    if([fav_index_message_array count]>0)
    {
        current_index++;
        if(current_index>=[fav_index_message_array count])
        {
            current_index=0;
        }
        [UIView beginAnimations: @ "animationID" context: nil];
        [UIView setAnimationDuration: 0.7f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses: NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.displayView cache: YES];
        [UIView commitAnimations  ];
        _countLabel.text=[NSString stringWithFormat:@"%d/%d",current_index+1,[fav_index_message_array count]];
        fav_view.text=[[fav_index_message_array objectAtIndex:current_index]objectAtIndex:1];
    }
    
    
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}

- (IBAction)remove_fav:(id)sender {
    
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"favorites.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"favorites" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *fdata=[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if([fav_index_message_array count]>0)
    {
        
        [[fdata valueForKey:@"fact_id"]  removeObject:[[fav_index_message_array objectAtIndex:current_index]objectAtIndex:0]];
        
        [fdata writeToFile:path atomically:YES];
        [self.view makeToast:@"Sucesfully removed from favourites"
                    duration:0.5
                    position:@"center"];
        
        [self RefreshView];
        
    }
    
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}


- (void)SendSmsFn {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString * message = fav_view.text ;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
    
}

- (void)SendMailFn {
    //check if the device can send text messages
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString * message = @"FunBox";
    
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    //    [messageController setRecipients:recipients];
    [messageController setSubject:message];
    [messageController setMessageBody:fav_view.text isHTML:NO ];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)ShareViaFbFn {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"FubBox-%@",fav_view.text]];
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
        [tweetSheet setInitialText:[NSString stringWithFormat:@"FubBox-%@",fav_view.text]];
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
