//
//  SuggestionBoxViewController.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/6/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "SuggestionBoxViewController.h"

@interface SuggestionBoxViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *suggestionBoxTextView;

@end

@implementation SuggestionBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendButtonDidFire:(id)sender {
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
