//
//  FirstViewController.m
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import "FirstViewController.h"
#import "Reachability.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *firstWebView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) /*Check if offline*/
    {
        //connection unavailable
        _firstWebView.hidden = YES; // hide webview
        _offlineLabel.hidden = NO; // show offline label
        NSLog(@"Offline...");
    }
    else
    {
        //connection available
        _offlineLabel.hidden = YES; // hide offline label
        NSLog(@"Online");
        NSString *urlString = @"https://ethanrdoesmc.github.io/gandalf";
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_firstWebView loadRequest:urlRequest];
    }
   
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
