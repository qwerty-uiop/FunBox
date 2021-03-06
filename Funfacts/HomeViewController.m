//
//  HomeViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 QWERTYUIOP. All rights reserved.
//

#import "HomeViewController.h"
#import "AboutViewController.h"
#import "FactsViewController.h"
#import "FavouriteViewController.h"
#import "XMLReader.h"
#import "Reachability.h"
#import "XYPoint.h"
#import "CircularLayOutView.h"
#import "RectButtonView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
AboutViewController * about_view;
FactsViewController * facts_view;
FavouriteViewController * favourite_view;
@synthesize parser,fun_facts;


-(void)buttonClick:(NSString *)buttonName
{
    NSLog(@"Button name = %@",buttonName);
   if([buttonName isEqualToString:@"twister"])
    {
        
        g_category=k_n_twisters;
        FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
        
        [self presentViewController: facts_displayView animated: NO completion:nil];
       
    }
    else if([buttonName isEqualToString:@"joke"])
    {
        g_category=k_n_jokes;
        FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
        
        [self presentViewController: facts_displayView animated: NO completion:nil];
    }
    else
        {
            
            g_category=k_n_facts;
            FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
            
            [self presentViewController: facts_displayView animated: NO completion:nil];
        }
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    Versioning
    NSString *versionNumberStr = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *) kCFBundleVersionKey];
    
    NSString *displayVersionNumber = [NSString stringWithFormat:@"Version "];
    displayVersionNumber = [displayVersionNumber stringByAppendingFormat: @"%@",versionNumberStr];
    
   _version.text = displayVersionNumber;
    
    
  
    
    if([self IsNetworkAvailable])
    {
          [self InitializeBannerView];
    }
    else
    {
        [self setCustomAd];
    }
    fun_facts= [[NSMutableArray alloc] initWithCapacity:3 ];
    if(master_data==nil)
    {
        [self parse_xml];
    }
    
    
//    Circular Button Implementation
    CircularLayOutView *manger=[[CircularLayOutView alloc] init];
    //manger.tager=self;
    manger.MyDelegate=self;
    XYPoint *centerPoint=[[XYPoint alloc] init];
    centerPoint.xPoint=self.view.frame.size.width/2;
    centerPoint.yPoint=self.view.frame.size.height/1.8;
    manger.centerPoint=centerPoint;
    XYPoint *buttonWeightAndHeight=[[XYPoint alloc] init];
    buttonWeightAndHeight.xPoint=self.view.frame.size.width/4;
    buttonWeightAndHeight.yPoint=self.view.frame.size.width/4;
    manger.buttonWeightAndHeight=buttonWeightAndHeight;
    manger.radius=self.view.frame.size.width/3;
    NSArray *buttonNameArray=@[@"fact",@"joke",@"twister",@"fact",@"joke",@"twister"];
    NSArray *buttonImageArray=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"bubble_facts"],[UIImage imageNamed:@"bubble_jokes"],[UIImage imageNamed:@"bubble_twisters"],[UIImage imageNamed:@"bubble_facts"],[UIImage imageNamed:@"bubble_jokes"],[UIImage imageNamed:@"bubble_twisters"], nil];
    manger.buttonIndexBackGroundArray=buttonImageArray;
    manger.buttonCount=6;
    manger.buttonIndexNameArray=buttonNameArray;
    
    [manger creatUIToView:self.view target:nil];
    
    [self.view addSubview:manger];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)twisters_clkd:(id)sender {
    g_category=k_n_twisters;
    FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
    
    [self presentViewController: facts_displayView animated: NO completion:nil];
}

- (IBAction)about_clkd:(id)sender {
    about_view =[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil ];
    
    [self presentViewController: about_view animated: NO completion:nil];
    
    
}

-(void)parse_xml{
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"funboxmaster" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:xmlPath];    NSError *parseError = nil;
    master_data = [XMLReader dictionaryForXMLData:data error:&parseError];

}

- (IBAction)jokes_clkd:(id)sender {
    g_category=k_n_jokes;
    FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
    
    [self presentViewController: facts_displayView animated: NO completion:nil];
}

- (IBAction)funfacts_clkd:(id)sender {
    g_category=k_n_facts;
    FactsViewController* facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
    
    [self presentViewController: facts_displayView animated: NO completion:nil];
}

- (IBAction)favourites_clkd:(id)sender {
    favourite_view =[[FavouriteViewController alloc] initWithNibName:@"FavouriteViewController" bundle:nil ];
    
    [self presentViewController: favourite_view animated: NO completion:nil];
}

-(void)InitializeBannerView
{
   
    bannerView_ = [[GADBannerView alloc] initWithAdSize:([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad)?kGADAdSizeLeaderboard:kGADAdSizeBanner];
    bannerView_.adUnitID = adMobID;
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [bannerView_ loadRequest:request];
}

-(BOOL)IsNetworkAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    } else {
        
        return true;
    }
}
-(void)setCustomAd
{
    UIImageView* adView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame), 50)];
    adView.image=[UIImage imageNamed:k_DeviceTypeIsIpad?@"AdiPad.jpg":@"Ad.jpg"];
    [self.view addSubview:adView];
}

@end
