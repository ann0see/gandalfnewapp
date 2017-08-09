//
//  SecondViewController.m
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (getuid() != 0 ) // Check if running not as root and give error
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not running as root"
            message:@"This app is currently not running as root user. Actions in this view will most likely fail. If you think this is an error, please contact us."
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
        {
            NSURL *contactUrl = [NSURL URLWithString:@"https://github.com/ethanrdoesmc/gandalf/issues"];
            if (![[UIApplication sharedApplication] openURL:contactUrl]) {
                NSLog(@"%@%@",@"Failed to open url:",[contactUrl description]); // If failed goes here
        }
        }]; //Contact Button; Opens issues tab on GitHub repo

        [alert addAction:defaultAction];
        [alert addAction:contactAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)holdButton:(id)sender {
    /*if (getuid() != 0) {
        UIButton *button = (UIButton *)sender;
        button.enabled = NO;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"FNO ROOT ERROR" forState:UIControlStateNormal];
    }*/
    
    pid_t pid;
    // int status;
    const char* args[] = {"gandalf", "hold", NULL};
    int gafExitCode = posix_spawn(&pid, "/usr/bin/gandalf", NULL, NULL, (char* const*)args, NULL);
    
    
    if (gafExitCode == 0) {
        UIButton *button = (UIButton *)sender;
        button.enabled = NO;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"SUCCESS" forState:UIControlStateNormal];
    }
    else {
        UIButton *button = (UIButton *)sender;
        button.enabled = NO;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button setTitle:@"ERROR" forState:UIControlStateNormal]; //Make button show "ERROR"
        
        
        NSString* messageString = [NSString stringWithFormat: @"Something went wrong. Please contact us.\nDebug: posix_spawn exit code: \"%i", gafExitCode];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:messageString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            NSURL *contactUrl = [NSURL URLWithString:@"https://github.com/ethanrdoesmc/gandalf/issues"];
                                            if (![[UIApplication sharedApplication] openURL:contactUrl]) {
                                                NSLog(@"%@%@",@"Failed to open url:",[contactUrl description]); // If failed goes here
                                            }
                                        }]; //Contact Button; Opens issues tab on GitHub repo
        
        [alert addAction:defaultAction];
        [alert addAction:contactAction];
        [self presentViewController:alert animated:YES completion:nil]; // Show message if fails
    }
    
    // waitpid(pid, &status, WEXITED); //wait until the process completes (only if you need to do that) (yes, we need that)
}


@end
