//
//  FirstViewController.m
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // check if we can connect to our repo
    NSURL *dURL = [NSURL URLWithString:@"https://ethanrdoesmc.github.io/gandalf/app/online.txt"];
    NSData *data = [NSData dataWithContentsOfURL:dURL];
    if (data){
        _offlineTitle.hidden = YES; // hide offline title
        _offlineText.hidden = YES; // hide offline text
        NSLog(@"Online: can contact repo");
        NSString *urlString = @"https://ethanrdoesmc.github.io/gandalf/app/firstview.html";
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        [_firstWebView loadRequest:urlRequest];

    }
    else {
        NSLog(@"Offline: can´t contact repo");
        
        _firstWebView.hidden = YES; // hide webview
        _offlineTitle.hidden = NO; // show offline title
        _offlineText.hidden = NO; // show offline text
        
    }
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
