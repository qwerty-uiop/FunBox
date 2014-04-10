//
//  FactsListViewController.h
//  Funfacts
//
//  Created by Vipin V on 05/04/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FactsViewController;
@interface FactsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    FactsViewController * facts_displayView;
}
@property(strong,nonatomic)FactsViewController *facts_displayView;
@property (nonatomic, retain) NSMutableArray *dataList;
@end
