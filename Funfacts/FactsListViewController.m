//
//  FactsListViewController.m
//  Funfacts
//
//  Created by Vipin V on 05/04/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import "FactsListViewController.h"
#import "FactsViewController.h"
#import "HomeViewController.h"
@interface FactsListViewController ()

@end

@implementation FactsListViewController
@synthesize dataList,facts_displayView;
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
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Letter Facts",
                             @"Funny Letters", @"twisters", @"History", @"Other",@"People", @"Places", @"Sports", @"Strange Laws",  @"Words", @"World Records",  nil];
    self.dataList = array;
    
//    NSLog(@"Value %@",master_data);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return[self.dataList count]; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTableIdentifier"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"factsviewcell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [tableView flashScrollIndicators  ];
        
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image=[UIImage imageNamed:@"button_comment.png"];
    
    cell.imageView.contentMode=UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds=YES;
    cell.imageView.layer.cornerRadius=23;
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [dataList objectAtIndex:row];
    cell.textLabel.font=[UIFont fontWithName:@"TimesNewRomanPS-BoldMT"size:21.0f];
    
    
    //  NSLog(@"Atghggg: %d",indexPath.row);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
    
    
    facts_displayView.category_name=[dataList objectAtIndex:indexPath.row];
     [self presentViewController: facts_displayView animated: NO completion:nil];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    facts_displayView =[[FactsViewController alloc] initWithNibName:@"FactsViewController" bundle:nil ];
    
    
    facts_displayView.category_name=[dataList objectAtIndex:indexPath.row];
    [self presentViewController: facts_displayView animated: NO completion:nil];
    //[facts release];
}
@end
