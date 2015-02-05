//
//  CustomBusinessTableViewCell.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "CustomBusinessTableViewCell.h"

@implementation CustomBusinessTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ownersAvatar.layer.cornerRadius = self.ownersAvatar.frame.size.width / 2;
    self.ownersAvatar.clipsToBounds = YES;
    self.ownersAvatar.layer.borderWidth = 3.0f;
    self.ownersAvatar.layer.borderColor = [UIColor grayColor].CGColor;
    self.businessLogo.layer.cornerRadius = 10.0f;
    self.businessLogo.layer.borderWidth = 3.0f;
    self.businessLogo.clipsToBounds = YES;
    self.businessLogo.layer.borderColor = [UIColor grayColor].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
