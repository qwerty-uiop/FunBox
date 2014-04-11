//
//  FavouriteViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import "FavouriteViewController.h"
#import "HomeViewController.h"
#import "GHContextMenuView.h"
BOOL pub,ip,bol=YES;
NSString *pub_fact,*fav_txt;
NSArray *fav_array;
NSMutableArray *fav_temparray1,*fav_temparray2,*fps;
;
NSInteger p=0,fc=0;
@interface FavouriteViewController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>

@end

@implementation FavouriteViewController
@synthesize fav_view;
HomeViewController * home_view;

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
    
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alertView show];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    Added by jeethu
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    [fav_view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:_longPressRecognizer];

    
    
    
    
    // Do any additional setup after loading the view from its nib.
    fav_temparray1=[[NSMutableArray alloc] initWithCapacity:3];
    fav_temparray2=[[NSMutableArray alloc] initWithCapacity:3];
    fav_array=[NSArray alloc] ;
    [fav_temparray1 addObjectsFromArray:fps];
    
    fc=p=0;
    
    [self parsefunct];
    if(fav_array.count==0)
    {
        
    }
    else{
        while (fc<fav_array.count)
        {
            for(id factitem in fav_temparray1)
            {
                NSString *favfac=[fav_array objectAtIndex:fc];
                
                //  NSLog(@"foavfare: %@",favfac) ;
                if ([[[fav_temparray1 objectAtIndex:p]objectAtIndex:0]isEqualToString:favfac])
                    
                {
                    [fav_temparray2 addObject:[fav_temparray1 objectAtIndex:p]] ;
                    
                    p++;
                    break;
                } p++;
            }fc++;p=0;
        }
//        fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
        fav_view.text=[[fav_temparray2 objectAtIndex:p]objectAtIndex:1];
        fav_txt= [[fav_temparray2 objectAtIndex:p]objectAtIndex:1];
        p++;
    }
    ip=NO;
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];

}

- (void)viewDidAppear:(BOOL)animated {
    [fav_temparray2 removeAllObjects];
    NSInteger pt=0,ps=0;
    
    [self parsefunct];
    
    if(fav_array.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                              
                                                        message:@"There are no favorite items"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"OK"
                              
                                              otherButtonTitles:nil];
        
        [alert show];
        
             fav_view.text=@"Add facts to favorites";
    }
    else{
        while (pt<fav_array.count)
        {
            for(id factitem in fav_temparray1)
            {
                NSString *favfac=[fav_array objectAtIndex:pt];
                
                //  NSLog(@"foavfare: %@",favfac) ;
                if ([[[fav_temparray1 objectAtIndex:ps]objectAtIndex:0]isEqualToString:favfac])
                    
                {
                    [fav_temparray2 addObject:[fav_temparray1 objectAtIndex:ps]] ;
                    
                    ps++;
                    break;
                } ps++;
            }pt++;ps=0;
        }
        if(fav_array.count==1){
            
            fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
            fav_view.text=[[fav_temparray2 objectAtIndex:0]objectAtIndex:1];
            fav_txt= [[fav_temparray2 objectAtIndex:0]objectAtIndex:1];
        }
        
    }
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
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
    fav_array=[fdata objectForKey:@"fact_id"];
    
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

- (IBAction)prv_fact:(id)sender {
    if(ip==YES)
    {
        p--;
    }
    ip=NO;
    if(fav_temparray2.count==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Only one favorite item"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
         }
    
    else
    {
        
        if(bol)
        {
            p=p-2;
            bol=NO;
        }
        for(id factitem in fav_temparray2)
        {if(p>=0){
            fav_txt=[[fav_temparray2 objectAtIndex:p]objectAtIndex:1] ;
            // NSString *rlabel=[[shuffle objectAtIndex:s]objectAtIndex:2] ;
            [UIView beginAnimations: @ "animationID" context: nil];
            [UIView setAnimationDuration: 0.7f];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationRepeatAutoreverses: NO];
//            [UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView: self.fav_view cache: YES];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.displayView cache: YES];
            [UIView commitAnimations  ];
            fav_view.text=fav_txt;
            //   ranlabel.text=rlabel;
            p--;
            break;
        }
        else{
            p=fav_temparray2.count-1;
        }} }
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}

- (IBAction)next_fact:(id)sender {
    if(ip==YES)
    {
        p++;
    }
    ip=NO;
    if(fav_temparray2.count==1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Only one favorite item"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
            }
    
    else
    {
        
        if(!bol)
        {
            p=p+2;
            bol=YES;
        }
        
        for(id factitem in fav_temparray2)
        {if(p<fav_temparray2.count)
        {
            fav_txt=[[fav_temparray2 objectAtIndex:p]objectAtIndex:1] ;
            [UIView beginAnimations: @ "animationID" context: nil];
            [UIView setAnimationDuration: 0.7f];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [UIView setAnimationRepeatAutoreverses: NO];
//            [UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView: self.fav_view cache: YES];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.displayView cache: YES];
            [UIView commitAnimations  ];
            
            fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
            fav_view.text=fav_txt;
            // ranlabel.text=rlabel;
            p++;
            break;
        }
        else{
            p=0;
        }
        }    }
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
    //   NSArray *fav_array=[fdata objectForKey:@"f_id"];
    if(ip==NO){
        if(bol==YES){
            p--;
            if(p<0){
                p=fav_temparray2.count-1;
                
            }
        }
        else{
            p++;
            if(p>=fav_temparray2.count){
                p=0;
            }
        }
    }
    if(fav_temparray2.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"No more favorites !"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"otherButtonTitles:nil];
        
        [alert show];
      
        fav_view.text=@"Add favorite facts";
    }
    else{
        // NSLog(@"Before: %@",[[test5 objectAtIndex:p]objectAtIndex:1]) ;
        [[fdata valueForKey:@"f_id"]  removeObject:[[fav_temparray2 objectAtIndex:p]objectAtIndex:0]];
        
        [fdata writeToFile:path atomically:YES];
        [fav_temparray2 removeObject:[fav_temparray2 objectAtIndex:p]] ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Removed from favorites"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        if(fav_temparray2.count==0){
            
            fav_view.text=@"Add favorite facts";
        }
        else{
            if(p>=fav_temparray2.count)
            {
                p=0;
            }
            fav_view.text=[[fav_temparray2 objectAtIndex:p]objectAtIndex:1];
            
            //   ffff=[[test5 objectAtIndex:p]objectAtIndex:1];
            
        }
        
    }
    ip=YES;
    
    fav_view.textColor=[UIColor whiteColor];
    fav_view.TextAlignment=NSTextAlignmentCenter;
    fav_view.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}


- (void)SendSmsFn {
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    //    NSArray *recipients = [NSArray arrayWithObjects:@"0650454323",@"0434320943",@"0560984122", nil];
    
    //set message text
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
    
    //set receipients
    //    NSArray *recipients = [NSArray arrayWithObjects:@"0650454323",@"0434320943",@"0560984122", nil];
    
    //set message text
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
        //        [controller addURL:[NSURL URLWithString:@"http://think-n-relax.blogspot.in"]];
        //        [controller addImage:[UIImage imageNamed:@"socialsharing-facebook-image.jpg"]];
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