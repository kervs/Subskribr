//
//  business.h
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Business : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
@property(retain) NSString *businessType;
@property(retain) NSString *logoURL;
@property(retain) NSString *name;
@property(retain) NSArray *phoneNumbers;
@property(retain) NSNumber *totalRating;
@property(retain) NSNumber *totalSubscribers;

@end
