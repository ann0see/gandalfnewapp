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
// Check 4 updates
- (IBAction)updateButton:(id)sender {
    __block NSString *instVersion;
    __block NSString *onlineVersion;
    NSString *gandalfIdentifier = @"io.github.ethanrdoesmc.gandalf102"; //Bundle Identifier
    // Get latest version from repository
    
    NSString *Url = @"https://ethanrdoesmc.github.io/gandalf/Packages";
    NSMutableURLRequest *fileRequest = [[NSMutableURLRequest alloc] init];
    [fileRequest setHTTPMethod:@"GET"];
    [fileRequest setURL:[NSURL URLWithString:Url]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:fileRequest completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          // we should check if response was 200 (success)
          
          NSString *packagesFile = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSArray *packagesFileArray = [packagesFile componentsSeparatedByString:@"\n"]; // Save it in an array
          NSString *rawVersion;
          
          // get all the properties of the gandalf Version from the array
          NSString *packageLine = [NSString stringWithFormat:@"Package: %@", gandalfIdentifier]; // merge the 2 strings
          NSUInteger indexOfGandalfBundleIdentifier = [packagesFileArray indexOfObject:packageLine]; //get the index of them
          NSUInteger arrayCounter = indexOfGandalfBundleIdentifier; //Set where it should start searching
          NSLog(@"Line: %lu", (unsigned long)indexOfGandalfBundleIdentifier); //output it to the log
          do {
               NSString *arrayLine = packagesFileArray[arrayCounter]; // Save content of array line...
              if ([arrayLine containsString:(@"Version:")]){ //And check if it contains Version:
                  NSLog(@"L: %@", arrayLine);
                  rawVersion = [arrayLine stringByReplacingOccurrencesOfString:@"Version: " withString:@""]; // Remove Version: from this string
                  onlineVersion = rawVersion; //save it to onlineVersion
                  NSLog(@"%@", rawVersion);
                  break; //Now it´s done, so we can stop the loop
              }
              arrayCounter++;
          }
          while (TRUE);
          
          // let´s get the content of /var/lib/dpkg/status and search for gandalfIdentifier
          NSString *filepath = [[NSBundle mainBundle] pathForResource:@"/var/lib/dpkg/status" ofType:@"txt"];
          NSError *errordpkg;
          NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
          
          if (error)
              NSLog(@"Error reading file: %@", errordpkg.localizedDescription);
          
          // maybe for debugging...
          NSLog(@"contents: %@", fileContents);
          NSArray *dpkgStatusArray = [fileContents componentsSeparatedByString:@"\n"];

          packageLine = [NSString stringWithFormat:@"Package: %@", gandalfIdentifier]; // merge the 2 strings
          NSUInteger dpkgIndexOfGandalfBundleIdentifier = [dpkgStatusArray indexOfObject:packageLine]; //get the index of them
          arrayCounter = dpkgIndexOfGandalfBundleIdentifier; //Set where it should start searching
          do {
              NSString *arrayLine = dpkgStatusArray[arrayCounter]; // Save content of array line...
              if ([arrayLine containsString:(@"Version:")]){ //And check if it contains Version:
                  NSLog(@"L: %@", arrayLine);
                  rawVersion = [arrayLine stringByReplacingOccurrencesOfString:@"Version: " withString:@""]; // Remove Version: from this string
                  instVersion = rawVersion; //save it to instVersion
                  NSLog(@"%@", rawVersion);
                  break; //Now it´s done, so we can stop the loop
              }
              arrayCounter++;
          } while (TRUE);

      }] resume];

}



@end
