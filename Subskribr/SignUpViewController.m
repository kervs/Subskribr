//
//  SignUpViewController.m
//  CelebDuel
//
//  Created by Kervins Valcourt on 11/26/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface SignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastName;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastName.delegate = self;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.passwordField.returnKeyType = UIReturnKeyNext;
    self.firstNameField.returnKeyType = UIReturnKeyNext;

}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            
        } else {
            [self updateUserInformation];
            [self sendWelcomeEmail];
            
        }
    }];
}



- (IBAction)signUpFired:(UIButton *)sender {
    [ self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self checkFieldsComplete];
}

- (void) checkFieldsComplete {
    //check user has completed all fields
    if ([self.emailField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]|| [self.firstNameField.text isEqualToString:@""] || [self.lastName.text isEqualToString:@""]) {
        NSString *message = @"You need to complete all fields";
        [self displayAlertView:message];
    }
    else {
        [self registerNewUser];
    }
}


- (void) registerNewUser {
    NSLog(@"registering....");
    PFUser *newUser = [PFUser user];
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    newUser.username = self.emailField.text;
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",self.firstNameField.text,self.lastName.text];
    newUser[@"fullName"]= fullName;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Registration success!");
            
            [self sendWelcomeEmail];

            }
        else {
             [self displayAlertView:[error description]];
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
  if (textField == self.emailField) {
        [self.passwordField becomeFirstResponder];
    } else if(textField == self.passwordField){
        [self.firstNameField becomeFirstResponder];
    } else if(textField == self.firstNameField){
        [self.lastName becomeFirstResponder];
    }
    else{
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
