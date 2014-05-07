//
//  AboutViewController.h
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 QWERTYUIOP. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "GADBannerView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AboutViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    GADBannerView *bannerView_;
    SystemSoundID qwSoundObj;
}
- (IBAction)back_bttnclk:(id)sender;
- (IBAction)ShareViaFb:(id)sender;
- (IBAction)ShareViaTwitter:(id)sender;
- (IBAction)ShareViaSMS:(id)sender;
- (IBAction)ShareViaEmail:(id)sender;

@end
