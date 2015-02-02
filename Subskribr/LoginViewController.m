//
//  LoginViewController.m
//  CelebDuel
//
//  Created by Kervins Valcourt on 11/26/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "LoginViewController.h"
#import "MainVC.h"
#import <Parse/Parse.h>
#import <FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface LoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (strong,nonatomic) UINavigationController *navCon;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailLabel.delegate = self;
    self.emailLabel.returnKeyType = UIReturnKeyNext;
    self.passwordLabel.delegate = self;
}


- (IBAction)connectWithFB:(UIButton *)sender {
    NSArray *permissionArray = @[@"user_about_me",@"email",@"user_birthday"];
    [PFFacebookUtils logInWithPermissions:permissionArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSString *message = @"Facebook Log In was Canceled";
                [self displayAlertView:message];
            }
            else {
                
                [self displayAlertView:[error userInfo][@"error"]];
                NSLog(@"%@",error);
            }
            
        }
        else if (user.isNew) {
            [self updateUserInformation];
            [self sendWelcomeEmail];
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
        else {
            
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
            
        
        }
    }];

}


- (void)sendWelcomeEmail{
    [PFCloud callFunctionInBackground:@"sendWelcomeEmail"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@",result);
                                        
                                    } else {
                                        NSString *errorString = [error userInfo][@"error"];
                                        // Show the errorString somewhere and let the user try again.
                                        [self displayAlertView:[NSString stringWithFormat: @"%@",errorString]];
                                        
                                    }
                                }];
    
}


- (IBAction)loginFired:(UIButton *)sender {
    [self.view endEditing:YES];
    [PFUser logInWithUsernameInBackground:self.emailLabel.text password:self.passwordLabel.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            

                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            [self displayAlertView:[error description]];

                                        }
                                    }];

}

- (void)displayAlertView:(NSString *)message{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message: message
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert show];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailLabel) {
        [self.passwordLabel becomeFirstResponder];
    }
    
    if (textField == self.passwordLabel) {
        [self.passwordLabel resignFirstResponder];
    }
    
    else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - FB helper method
- (void) updateUserInformation {
    FBRequest *request = [FBRequest requestForMe];
    PFUser *currentUser = [PFUser currentUser];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            if (userDictionary[@"first_name"]) {
                currentUser[@"firstName"] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"last_name"]) {
                currentUser[@"lastName"] = userDictionary[@"last_name"];
            }
            if (userDictionary[@"email"]) {
                currentUser[@"email"] = userDictionary[@"email"];
            }
            if (userDictionary[@"gender"]) {
                currentUser[@"gender"] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"]) {
                currentUser[@"dob"] = userDictionary[@"birthday"];
            }
            
            [[PFUser currentUser]saveInBackground];
        }
        else {
            [self displayAlertView:[error description]];
        }
    }];
}



@end
