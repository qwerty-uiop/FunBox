//
//  FactsViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import "FactsViewController.h"
#import "HomeViewController.h"
#import "GHContextMenuView.h"
NSMutableArray *fps;
NSString *temp_txt;
@interface FactsViewController ()<GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *joke_displyView;
@property (weak, nonatomic) IBOutlet UILabel *fact_countLbl;
@property (weak, nonatomic) IBOutlet UITextView *fact_text;
@end

@implementation FactsViewController
@synthesize fact_text,category_name,fact_countLbl;
HomeViewController * home_view;
NSInteger count,j=0,k=0,n=0,m=1;
NSMutableArray *temp_factArray;
bool c=YES;
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
    [self.fact_text setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:_longPressRecognizer];

    
    
    // Do any additional setup after loading the view from its nib.
    count=0;
    k=0;
    j=0;
    n=0;
    m=1;
    c=YES;
    // Do any additional setup after loading the view from its nib.
    temp_factArray=fps;
   
    
    // NSLog(@"At: %@",fps);
    
    for(id counter in temp_factArray)
    {
        if ([[[temp_factArray objectAtIndex:n]objectAtIndex:2]isEqualToString: category_name])
        {
            
            k++;
        }
        n++;
    }
    
    //NSLog(@"At: %d",k);
    
    for(id factitem in temp_factArray)
    {
        
        if ([[[temp_factArray objectAtIndex:j]objectAtIndex:2]isEqualToString: category_name])
        {
            
            temp_txt=[[temp_factArray objectAtIndex:j]objectAtIndex:1] ;
            
            NSString *factcount = [NSString stringWithFormat:@"%d",m];
            factcount = [factcount stringByAppendingString:[NSString stringWithFormat:@"/%d ", k]];
            fact_countLbl.text=factcount;
           fact_text.text=temp_txt;
            j++;
            break;
        }   j++;    }
    
    m++;

    
    
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];


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
- (IBAction)prvfact:(id)sender{
    if(c)
    {
        j=j-2;
        c=NO;
        m=m-2;
    }
    if(j<0)
    {
        j=temp_factArray.count;
        j--;
    }
    
    for(id factitem in temp_factArray)
    {
        
        if ([[[temp_factArray objectAtIndex:j]objectAtIndex:2]isEqualToString: category_name])
        {
            //  NSLog(@"Arrayprev: %d",j);
            temp_txt=[[temp_factArray objectAtIndex:j]objectAtIndex:1] ;
            j--;
            
            if(m<=0)
            {
                m=k;
            }
            NSString *factcount = [NSString stringWithFormat:@"%d",m];
            factcount = [factcount stringByAppendingString:[NSString stringWithFormat:@"/%d ", k]];
        [UIView beginAnimations: @ "animationID" context: nil];
        [UIView setAnimationDuration: 0.7f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses: NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView: self.joke_displyView cache: YES];
        [UIView commitAnimations  ];
            fact_text.text=[NSString stringWithFormat:@"%@", temp_txt];

            fact_countLbl.text=factcount;
            m--;
            break;
        }
        
        j--;
        
        if(j<0)
        {
            j=temp_factArray.count;
            j--;
        }

    }
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];
}

- (IBAction)nextfact:(id)sender{
    if(!c)
    {
        j=j+2;
        c=YES;
        m= m+2;
    }
    
    if(j>=temp_factArray.count)
    {
        j=0;  }
    
    for(id factitem in temp_factArray)
    {
        
        if ([[[temp_factArray objectAtIndex:j]objectAtIndex:2]isEqualToString: category_name])
        {
            
            if(m>k)
            {
                m=1;
            }
            // NSLog(@"Araaynext: %d",j);
            temp_txt=[[temp_factArray objectAtIndex:j]objectAtIndex:1] ;
            
            NSString *factcount = [NSString stringWithFormat:@"%d",m];
            factcount = [factcount stringByAppendingString:[NSString stringWithFormat:@"/%d ", k]];
            
            j++;
        
        
        [UIView beginAnimations: @ "animationID" context: nil];
        [UIView setAnimationDuration: 0.7f];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses: NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView: self.joke_displyView cache: YES];
        [UIView commitAnimations  ];
            
          
           // fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
             fact_countLbl.text=factcount;
            fact_text.text=temp_txt;
            m++;
            
            break;
        }
        
        j++;
        
        if(j>=temp_factArray.count)
        {
            j=0;
            
        }
    }
    fact_text.textColor=[UIColor whiteColor];
    fact_text.TextAlignment=NSTextAlignmentCenter;
    fact_text.font=[UIFont fontWithName:@"MarkerFelt-Thin" size:k_DeviceTypeIsIpad?30.0:20.0];

}

- (IBAction)favourite_bttnClkd:(id)sender {
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
    NSArray *fav_array=[fdata objectForKey:@"fact_id"];
    if(c==YES){
        
        
        if(![fav_array containsObject:[[temp_factArray objectAtIndex:j-1]objectAtIndex:0]])
        {
            
            
            [[fdata valueForKey:@"fact_id"]  addObject:[[temp_factArray objectAtIndex:j-1]objectAtIndex:0]];
            
            [fdata writeToFile:path atomically:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                  
                                                            message:@"Added to favorites"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
                   }
        else{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                             message:@"Already added to favorites"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            
            [alert show];
            
            
        }
    }
    else{
        if(![fav_array containsObject:[[temp_factArray objectAtIndex:j+1]objectAtIndex:0]])
        {
            
            
            [[fdata valueForKey:@"fact_id"]  addObject:[[temp_factArray objectAtIndex:j+1]objectAtIndex:0]];
            
            [fdata writeToFile:path atomically:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                  
                                                            message:@"Added to favorites"
                                  
                                                           delegate:self
                                  
                                                  cancelButtonTitle:@"OK"
                                  
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            
        }
        else{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                   
                                                             message:@"Already added to favorites"
                                   
                                                            delegate:self
                                   
                                                   cancelButtonTitle:@"OK"
                                   
                                                   otherButtonTitles:nil];
            
            [alert show];
         
            
        }
        
        
    }
    

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
    NSString * message = fact_text.text ;
    
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
    [messageController setMessageBody:fact_text.text isHTML:NO ];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)ShareViaFbFn {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[NSString stringWithFormat:@"FubBox-%@",fact_text.text]];
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
