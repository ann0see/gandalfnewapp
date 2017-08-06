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
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)holdButton:(id)sender {
    pid_t pid;
    int status;
    const char* args[] = {"gandalf", "hold", NULL};
    posix_spawn(&pid, "/usr/bin/gandalf", NULL, NULL, (char* const*)args, NULL);
    waitpid(pid, &status, WEXITED);//wait untill the process completes (only if you need to do that) (yes, we need that)
    // system("/usr/bin/gandalf hold"); // execute gandalf hold command //is deprecated
}


@end
