//
//  HomeViewController.h
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
NSMutableArray *fps;
@class FactClass;
@interface HomeViewController : UIViewController<NSXMLParserDelegate>{
NSXMLParser *parser;
    GADBannerView *bannerView_;
    NSMutableArray *fun_facts;
    FactClass *facts;
    NSMutableString *currentElementValue;

}
@property(nonatomic,retain)NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *fun_facts;
@property (strong, nonatomic) IBOutlet UILabel *version;

- (IBAction)about_clkd:(id)sender;
- (IBAction)jokes_clkd:(id)sender;
- (IBAction)funfacts_clkd:(id)sender;
- (IBAction)favourites_clkd:(id)sender;

@end