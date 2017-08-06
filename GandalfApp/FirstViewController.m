//
//  FirstViewController.m
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *firstWebView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlString = @"https://ethanrdoesmc.github.io/gandalf";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_firstWebView loadRequest:urlRequest]; // and the app would crash
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
