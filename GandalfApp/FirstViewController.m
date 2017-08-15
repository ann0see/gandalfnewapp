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

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable) /*Check if offline*/
    {
        //connection unavailable
        
        _firstWebView.hidden = YES; // hide webview
        _offlineTitle.hidden = NO; // show offline title
        _offlineText.hidden = NO; // show offline text

        NSLog(@"Offline...");
    }
    else
    {
        //connection available
        _offlineTitle.hidden = YES; // hide offline title
        _offlineText.hidden = YES; // hide offline text
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
