//
//  FactsViewController.h
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 QWERTYUIOP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface FactsViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
}

- (IBAction)back_bttnclk:(id)sender;
- (IBAction)prvfact:(id)sender;
- (IBAction)nextfact:(id)sender;
- (IBAction)favourite_bttnClkd:(id)sender;
@end
