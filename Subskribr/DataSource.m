//
//  DataSource.m
//  CelebDuel
//
//  Created by Kervins Valcourt on 12/30/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "DataSource.h"
#import <Parse/Parse.h>
#import "Business.h"

@interface DataSource ()
@property (nonatomic, strong)NSArray *businessItems;
@property (nonatomic,assign)NSUInteger countOflastArray;
@property (nonatomic,assign)NSUInteger skip;
@end

@implementation DataSource

+(instancetype)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once,^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;    
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self pullDataFromServer];
    }
    return self;
}

- (void)displayAlertView:(NSString *)message{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message: message
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert show];
}

-(void)pullDataFromServer {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Business"];
    NSMutableArray *mutableBusinessArray = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if(!error)
        {
            
            for(Business *object in objects) {
                [mutableBusinessArray addObject:object];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self displayAlertView:[NSString stringWithFormat: @"%@",[error userInfo]]];
            
        }
        self.businessItems = mutableBusinessArray;
        self.countOflastArray = mutableBusinessArray.count;
        NSLog(@"count %lu",(unsigned long)self.countOflastArray);
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"NewBizNotification"
         object:self];
    }];
}


- (void)pullNextBizAndChangeLastArray {
    NSUInteger limit = 100;
    NSMutableArray *oldarry = [[NSMutableArray alloc]initWithArray:self.businessItems];
    self.skip += self.countOflastArray;
     PFQuery *query = [PFQuery queryWithClassName:@"Business"];
    if (self.countOflastArray % limit == 0) {
        [query setSkip:limit];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if(!error)
            {   self.countOflastArray = objects.count;
                
                for(Business *object in objects) {
                    [oldarry addObject:object];
                }
            }
            else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [self displayAlertView:[NSString stringWithFormat: @"%@",[error userInfo]]];
                
            }
            self.businessItems = oldarry;
            NSLog(@"count %lu",(unsigned long)self.countOflastArray);

            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"NewBizNotification"
             object:self];
        }];
        
    }
    
}


@end
