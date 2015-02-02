//
//  PageContentViewController.h
//  Subskribr
//
//  Created by Kervins Valcourt on 11/15/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
