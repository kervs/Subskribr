//
//  PageContentViewController.m
//  Subskribr
//
//  Created by Kervins Valcourt on 11/15/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "PageContentViewController.h"


@interface PageContentViewController ()

@end

@implementation PageContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
