//
//  ProfileViewController.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "ProfileViewController.h"
#import "PageViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *amountOfTotalSubscription;
@property (weak, nonatomic) IBOutlet UILabel *amountOfMonthlySubscriptionCost;
@property (weak, nonatomic) IBOutlet UILabel *joineDate;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (IBAction)logoutButtonPressed:(id)sender {
    [PFUser logOut];
     PFUser *currentUser = [PFUser currentUser];
    if (currentUser == nil) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"startview"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
