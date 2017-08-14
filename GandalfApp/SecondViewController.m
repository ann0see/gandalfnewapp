//
//  SecondViewController.m
//  GandalfApp
//
//  Created by jonisc on 12.07.17.
//  Copyright © 2017 Gandalf. All rights reserved.
//

#import "SecondViewController.h"
#import "Reachability.h"
@interface SecondViewController ()


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (getuid() != 0 ) // Check if running not as root and give error
    {
        NSLog(@"App is not running as root!");
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
        
        
        NSString* messageString = [NSString stringWithFormat: @"Something went wrong. Please contact us.\nDebug: posix_spawn exit code: \"%i\"", gafExitCode];
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
    NSString *onlineVersion; //Version from Packages file + online repo
    
    //get the installed version and bundle identifier from the file located in /etc/gandalf/properties
      // Check if file exists
    NSFileManager *fileManagerCheckProp = [NSFileManager defaultManager];
    if (![fileManagerCheckProp isReadableFileAtPath:@"/etc/gandalf/properties"]){
        NSLog(@"ERROR: /etc/gandalf/properties is not readable or does not exist.");
        
        UIAlertController* propertiesNoExistAlert = [UIAlertController alertControllerWithTitle:@"File doesn´t exist or not readable"
                                                                       message:@"Couldn´t read file \"/etc/gandalf/properties\".\n Does this file exist, do you have removed Gandalf or is this app running in a sandbox?\nIf you think this is an error, please contact us."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            NSURL *contactUrl = [NSURL URLWithString:@"https://github.com/ethanrdoesmc/gandalf/issues"];
                                            if (![[UIApplication sharedApplication] openURL:contactUrl]) {
                                                NSLog(@"%@%@",@"Failed to open url:",[contactUrl description]); // If failed goes here
                                            }
                                        }]; //Contact Button; Opens issues tab on GitHub repo
        
        [propertiesNoExistAlert addAction:defaultAction];
        [propertiesNoExistAlert addAction:contactAction];
        [self presentViewController:propertiesNoExistAlert animated:YES completion:nil];
        return; // quit IBAction because we can´t get content of file /etc/gandalf/properties

        
        
    }
    
    NSString *propertiesFileContent = [NSString stringWithContentsOfFile:@"/etc/gandalf/properties" encoding:NSUTF8StringEncoding error:nil]; //Load content of this file into a string
    NSArray *propertiesFileArray = [propertiesFileContent componentsSeparatedByString:@"\n"]; // and now into array so we can work with the lines of the file
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // IMPORTANT: THE FOLLOWING WILL FAIL IF YOU CHANGE THE FORMAT OF THE PROPERTIES FILE !!//
    //////////////////////////////////////////////////////////////////////////////////////////
    
    NSString *gandalfIdentifier = [propertiesFileArray objectAtIndex:0]; //get the content of first line (at array index 0) and save it into gandalfIdentifier variable
    NSString *instVersion = [propertiesFileArray objectAtIndex:1]; //get the content of the second line (at array index 1) and save it into instVersion variable
    gandalfIdentifier = [gandalfIdentifier stringByReplacingOccurrencesOfString:@"BUNDLEID: " withString:@""]; // get rid of "BUNDLEID: "
    NSLog(@"Identifier: %@", gandalfIdentifier); // output identifier to the log
    instVersion = [instVersion stringByReplacingOccurrencesOfString:@"BUILD: " withString:@""];
    NSLog(@"InstalledVersion: %@", instVersion); // output version number to the log
    __block NSString *packagesFile = @"//EMPTY/";
    
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
          packagesFile = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      }] resume];
     //Prevent infinite loops...

    for (long double Timeout = 0; Timeout < 9999999999999999; Timeout++) {
        if (![packagesFile isEqualToString:@"//EMPTY/"]) {
            break;
        
        }
    } // wait till block is finished
    NSLog(@"Content DL:\n%@", packagesFile);
    NSArray *packagesFileArray = [packagesFile componentsSeparatedByString:@"\n"]; // Save it in an array
    
    // get all the properties of the gandalf Version from the array
    NSString *packageLine = [NSString stringWithFormat:@"Package: %@", gandalfIdentifier]; // merge the 2 strings
    NSUInteger indexOfGandalfBundleIdentifier = [packagesFileArray indexOfObject:packageLine]; //get the index of them
    NSUInteger arrayCounter = indexOfGandalfBundleIdentifier; //Set where it should start searching
    if (indexOfGandalfBundleIdentifier > [packagesFileArray count]) { // get here if index of bundleidentifier is greater than the actual array. this can happen if the bundleidentifier in the properties file is not found online.
        NSLog(@"Something went wrong. Maybe we couldn´t find your bundle identifier online? Your properties file might be corrupted.");
        UIAlertController* indexToBigAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                                            message:@"Something went wrong. Maybe we couldn´t find your bundle identifier online? Your properties file might be corrupted. Please contact us, and check the content after \"BUNDLEID:\" in the file \"/etc/gandalf/properties\"\nDebug: \"indexOfBundleIdentifier > packagesFileArray count\""
                                                                                                                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Contact" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            NSURL *contactUrl = [NSURL URLWithString:@"https://github.com/ethanrdoesmc/gandalf/issues"];
                                            if (![[UIApplication sharedApplication] openURL:contactUrl]) {
                                                NSLog(@"%@%@",@"Failed to open url:",[contactUrl description]); // If failed goes here
                                            }
                                        }]; //Contact Button; Opens issues tab on GitHub repo
        
        [indexToBigAlert addAction:defaultAction];
        [indexToBigAlert addAction:contactAction];
        [self presentViewController:indexToBigAlert animated:YES completion:nil];

        
        
        return;
        
    }
    NSLog(@"Line: %lu", (unsigned long)indexOfGandalfBundleIdentifier); //output it to the log
    do {
        NSString *arrayLine = packagesFileArray[arrayCounter]; // Save content of array line...
        if ([arrayLine containsString:(@"Version:")]){ //And check if it contains Version:
            NSLog(@"L: %@", arrayLine);
            onlineVersion = [arrayLine stringByReplacingOccurrencesOfString:@"Version: " withString:@""]; // Remove Version: from this string
            NSLog(@"%@", onlineVersion);
            break; //Now it´s done, so we can stop the loop
        }
        arrayCounter++;
    }
    while (arrayCounter < 20000000);
    
    if ([instVersion compare:onlineVersion options:NSNumericSearch] == NSOrderedAscending){ //if there´s an update show a message... // Like https://stackoverflow.com/questions/1978456/compare-version-numbers-in-objective-c#1990854
        NSLog(@"Update available");
        
        NSString* messageString = [NSString stringWithFormat: @"You have installed version: %@\nand the latest version is: %@", instVersion, onlineVersion];
        UIAlertController* updateAlert = [UIAlertController alertControllerWithTitle:@"Update available" message:messageString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Open Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            NSURL *cydiaUrl = [NSURL URLWithString:@"cydia://"];
                                            if (![[UIApplication sharedApplication] openURL:cydiaUrl]) {
                                                NSLog(@"%@%@",@"Failed to open cydia:",[cydiaUrl description]); // If failed goes here
                                            }
                                        }]; //Opens Cydia
        
        [updateAlert addAction:defaultAction];
        [updateAlert addAction:contactAction];
        [self presentViewController:updateAlert animated:YES completion:nil]; // Show message if update available
        
    } else {
        NSLog(@"No update available");
        
        NSString* messageString = [NSString stringWithFormat: @"You have installed version: %@\nand the latest version is: %@", instVersion, onlineVersion];
        UIAlertController* updateAlert = [UIAlertController alertControllerWithTitle:@"No update available" message:messageString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}]; // Dismiss button
        UIAlertAction* contactAction = [UIAlertAction actionWithTitle:@"Open Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            NSURL *cydiaUrl = [NSURL URLWithString:@"cydia://"];
                                            if (![[UIApplication sharedApplication] openURL:cydiaUrl]) {
                                                NSLog(@"%@%@",@"Failed to open cydia:",[cydiaUrl description]); // If failed goes here
                                            }
                                        }]; //Opens Cydia
        
        [updateAlert addAction:defaultAction];
        [updateAlert addAction:contactAction];
        [self presentViewController:updateAlert animated:YES completion:nil]; // Show message if update available
    }
}
@end
