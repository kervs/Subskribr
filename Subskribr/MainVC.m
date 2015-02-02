//
//  MainVC.m
//  Subskribr
//
//  Created by Kervins Valcourt on 1/31/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "MainVC.h"

@implementation MainVC



- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"home";
            break;
        case 1:
            identifier = @"profile";
            break;
        case 2:
            identifier = @"subscriptions";
            break;
        case 3:
            identifier = @"browse";
            break;
        case 4:
            identifier = @"suggestion";
            break;
        case 5:
            identifier = @"setting";
            break;
    }
    return identifier;
}

@end
