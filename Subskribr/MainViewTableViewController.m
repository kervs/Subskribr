//
//  MainViewTableViewController.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "MainViewTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataSource.h"
#import "business.h"
#import "CustomBusinessTableViewCell.h"

@interface MainViewTableViewController ()
@property (nonatomic,strong)UIView *refreshLoadingView;
@property (nonatomic,strong)UIView *refreshColorView;
@property (nonatomic,strong)UIImageView *compass_background;
@property (nonatomic,strong)UIImageView *compass_spinner;
@property (nonatomic,strong)NSArray *businessArray;
@property (assign)BOOL isRefreshIconsOverlap;
@property (assign)BOOL isRefreshAnimating;
@property (nonatomic,assign)NSUInteger refreshPoint;

@end
 static NSString *CellIdentifier = @"BizCell";
@implementation MainViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([DataSource sharedInstance].businessItems.count != 0) {
        [self reloadBizList];
    }
    [DataSource sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"NewBizNotification"
                                               object:nil];
    [self setupRefreshControl];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"NewBizNotification"])
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (Business *biz in [DataSource sharedInstance].businessItems) {
            [tempArray addObject:biz];
            
        }
        
        self.businessArray = tempArray;
        self.refreshPoint = floor(self.businessArray.count/2);
    }
    [self.tableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)loadView {
    [super loadView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadBizList {
    [[DataSource sharedInstance] pullDataFromServer];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (Business *biz in [DataSource sharedInstance].businessItems) {
        [tempArray addObject:biz];
        
    }
    
    self.businessArray = tempArray;
    [self.tableView reloadData];
   
}

- (void)setupRefreshControl
{
    // TODO: Programmatically inserting a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
    // Create the graphic image views
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_background.png"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_spinner.png"]];
    
    // Add the graphics to the loading view
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor clearColor];
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender{
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    [self reloadBizList];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self reloadBizList];
        [self.refreshControl endRefreshing];
    });
    // -- FINISHED SOMETHING AWESOME, WOO! --
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.tableView.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabsf(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
    
   
}

- (void)animateRefreshView
{
    // Background color to loop through for our color view
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
    static int colorIndex = 0;
    
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                         
                         // Change the background color
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (self.refreshControl.isRefreshing) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation
{
    // Reset our flags and background color
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.businessArray count];
}

- (CustomBusinessTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    CustomBusinessTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(CustomBusinessTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Business *biz = self.businessArray[indexPath.row];
    [self setBizLogoForCell:cell item:biz];
    [self setBizNameForCell:cell item:biz];
    [self setBizRatingForCell:cell item:biz];
    [self setBizNumberOfSubcribersForCell:cell item:biz];
    [self setBizOwnerAvatarForCell:cell item:biz];
    [self setBizTypeForCell:cell item:biz];
    
}

- (void)setBizLogoForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    [cell.businessLogo sd_setImageWithURL:[NSURL URLWithString:biz.logoURL]
                      placeholderImage:[UIImage imageNamed:@"placeholder_user.png"]];
}

- (void)setBizNameForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    NSString *name = biz.name ?: NSLocalizedString(@"[No name]", nil);
    [cell.businessName setText:name];
}

- (void)setBizRatingForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    NSString *rating = [biz.totalRating stringValue] ?: NSLocalizedString(@"[No Title]", nil);
    [cell.businessRating setText:[NSString stringWithFormat:@"%@ stars",rating]];
}

- (void)setBizOwnerAvatarForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    [cell.ownersAvatar sd_setImageWithURL:[NSURL URLWithString:biz.logoURL]
                         placeholderImage:[UIImage imageNamed:@"placeholder_user.png"]];
}

- (void)setBizTypeForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    NSString *type = biz.businessType ?: NSLocalizedString(@"[No Title]", nil);
    [cell.businessType setText:[NSString stringWithFormat:@"A %@",type]];
}

- (void)setBizNumberOfSubcribersForCell:(CustomBusinessTableViewCell *)cell item:(Business *)biz {
    NSString *subcribers = [biz.totalSubscribers stringValue] ?: NSLocalizedString(@"[No Title]", nil);
    [cell.numberOfSubscribers setText:[NSString stringWithFormat:@"%@ subcribers",subcribers]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%li",(long)indexPath.row);
    if (indexPath.row == self.refreshPoint) {
        [[DataSource sharedInstance]pullNextBizAndChangeLastArray];
    }
    return [self basicCellAtIndexPath:indexPath];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static CustomBusinessTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 100.0f;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

