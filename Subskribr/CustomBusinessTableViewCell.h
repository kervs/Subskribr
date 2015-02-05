//
//  CustomBusinessTableViewCell.h
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *businessRating;
@property (weak, nonatomic) IBOutlet UILabel *numberOfSubscribers;
@property (weak, nonatomic) IBOutlet UILabel *businessType;
@property (weak, nonatomic) IBOutlet UIImageView *businessLogo;
@property (weak, nonatomic) IBOutlet UIImageView *ownersAvatar;

@end
