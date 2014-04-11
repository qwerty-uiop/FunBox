//
//  FavouriteViewController.h
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface FavouriteViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *fav_view;
@property (strong, nonatomic) IBOutlet UIView *displayView;
- (IBAction)back_bttnclk:(id)sender;
- (IBAction)remove_fav:(id)sender;
- (IBAction)prv_fact:(id)sender;
- (IBAction)next_fact:(id)sender;
- (void)parsefunct;
@end
