//
//  FirstViewController.h
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *offlineTitle;
@property (weak, nonatomic) IBOutlet UILabel *offlineText;
@property (weak, nonatomic) IBOutlet UIWebView *firstWebView;
@end
