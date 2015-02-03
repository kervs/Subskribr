//
//  business.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "business.h"
#import <Parse/PFObject+Subclass.h>

@implementation Business
+ (void)load {
    [self registerSubclass];
}

@dynamic businessType;
@dynamic logoURL;
@dynamic name;
@dynamic phoneNumbers;
@dynamic totalRating;
@dynamic totalSubscribers;

+ (NSString *)parseClassName {
    return @"Business";
}
@end
