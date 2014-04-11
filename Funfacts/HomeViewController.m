//
//  HomeViewController.m
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import "HomeViewController.h"
#import "AboutViewController.h"
#import "JokesViewController.h"
#import "FactsViewController.h"
#import "FavouriteViewController.h"
#import "FactClass.h"
#import "FactsListViewController.h"
#import "XMLReader.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
AboutViewController * about_view;
JokesViewController * jokes_view;
FactsViewController * facts_view;
FavouriteViewController * favourite_view;
FactsListViewController * factsListView;
@synthesize parser,fun_facts;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    Versioning
    NSString *versionNumberStr = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *) kCFBundleVersionKey];
    
    NSString *displayVersionNumber = [NSString stringWithFormat:@"Version "];
    displayVersionNumber = [displayVersionNumber stringByAppendingFormat: @"%@",versionNumberStr];
    
   _version.text = displayVersionNumber;
    
//    NSLog(@"Value %f",CGRectGetMaxX(self.view.frame));
//    NSLog(@"Value %f",CGRectGetMaxY(self.view.frame));
    
    [self InitializeBannerView];
    fun_facts= [[NSMutableArray alloc] initWithCapacity:3 ];
	// Do any additional setup after loading the view, typically from a nib.
    if(fps==nil)
    {
        [self parse_xml];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSData *data = [NSData dataWithContentsOfFile:xmlPath];
//    parser = [[NSXMLParser alloc] initWithData:data];
//    parser.delegate=self;
//    [parser setShouldResolveExternalEntities:YES];
//    
//    BOOL success =  [parser parse];
//    if(success){
//          NSLog(@"No Errors");
//        fps=fun_facts;
////        NSLog(@"Atghggg: %@",fps);
//    }
//    else{
//          NSLog(@"Error Error Error!!!");
//    }
//
//
//   // funDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
////
    NSError *parseError = nil;
    master_data = [XMLReader dictionaryForXMLData:data error:&parseError];
    
    NSDictionary* aaaa=[[NSDictionary alloc]initWithDictionary:master_data];
    
    
    
    
    
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
//            bannerView_.frame = CGRectMake(0.0, self.view.frame.size.height- bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
 
    bannerView_.adUnitID = adMobID;
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [bannerView_ loadRequest:request];
}
//#pragma mark - Parser Delegates
//
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
//    attributes:(NSDictionary *)attributeDict {
//    
//    if([elementName isEqualToString:@"head"]){
//        
//    }
//    
//    else if([elementName isEqualToString:@"jokes"]){
//        
////        facts=[[FactClass alloc]init];
////        facts.factid=[attributeDict objectForKey:@"A"];
////        facts.factid=[attributeDict valueForKey:@"record"];
////        facts.fact=[attributeDict objectForKey:@"B"];
////        facts.category=[attributeDict objectForKey:@"C"];
////        [ fun_facts addObject:[NSMutableArray arrayWithObjects:facts.factid ,facts.fact,facts.category,nil]] ;
//        // i++;
//        
////        NSLog(@"didStartElement %@",);
//        
//        
//        
//    }
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
////    if([elementName isEqualToString:@"Records"])
////        
////        return;
////    
////    if([elementName isEqualToString:@"Row"]){
////       // [books addObject:aBook];
////        facts=nil;
////    }
////    else
////        [facts setValue:currentElementValue forKey:elementName];
////    currentElementValue=nil;
//}

@end
