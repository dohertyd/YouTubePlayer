//
//  MasterTableViewController.m
//  YouTubePlayer
//
//  Created by Derek Doherty on 02/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "MasterTableViewController.h"
#import "DetailViewController.h"
#import "SongSearchApiManager.h"
#import "SongData.h"
#import "SongSearchResultTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "MGSwipeButton.h"



@interface MasterTableViewController () <SongSearchApiManagerDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) SongSearchApiManager * songSearchApiManager;

//
// This is our non persistent model for the TableView
//
@property (strong, nonatomic) NSMutableArray * songArrayModelData;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

//
// Track the networking  state
//
typedef NS_ENUM(NSInteger, NetworkState)
{
    NWOK,
    NWDOWN,
    NWUNKNOWN
};
@property (assign) NetworkState networkState;

@end



@implementation MasterTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.networkState = NWUNKNOWN;
    
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar setBarTintColor:UICOLORFROMRGB(0x1A1A1A)];

    //
    //  Setting up text for Nav bar title on iphone and Ipad
    //
    if ( [ UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIFont fontWithName:@"Avenir" size:18],
          NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
    else
    {
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIFont fontWithName:@"Avenir" size:17],
          NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
    
    //
    // Need a refresh on coming back into foreground, add observer
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    self.songArrayModelData = [NSMutableArray array];
    
    //
    // Setup activity indicator as a right bar button
    //
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    [[self navigationItem] setRightBarButtonItem:barButton];
    [self.activityIndicator startAnimating];
    self.navigationItem.title = @"Loading ...";
    
    //
    // Setup up our AFNetworking Session Manager
    //
    self.songSearchApiManager = [SongSearchApiManager sharedSongSearchApiManager];
    self.songSearchApiManager.delegate = self;
    //
    // Make the AFNetworking call to get the SongSearch results
    //
    [self.songSearchApiManager getSongDataWithSearchCriteria:@""];

    //
    // Keep an eye on the network, handle network going up and down
    //
    NSOperationQueue *operationQueue = self.songSearchApiManager.operationQueue;
    //__weak MasterTableViewController * weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         //NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
         switch (status) {
             case AFNetworkReachabilityStatusReachableViaWWAN:
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 [operationQueue setSuspended:NO];
                 //
                 // Make the AFNetworking call to get the SongSearch results
                 //
                 if (self.networkState == NWDOWN) // Prevent multiple calls
                 {
                     self.networkState = NWOK;
                     [self.activityIndicator startAnimating];
                     self.navigationItem.title = @"Loading ...";
                    [self.songSearchApiManager getSongDataWithSearchCriteria:@""];
                 }
                 
                 break;
             case AFNetworkReachabilityStatusNotReachable:
             default:
                 [operationQueue setSuspended:YES];
                 self.networkState = NWDOWN;
                 break;
         }
     }];
    
    [self.songSearchApiManager.reachabilityManager  startMonitoring];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTable];
}

-(void)reloadTable
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songArrayModelData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    // Using our custom TableViewCell class here
    //
    SongSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songSearchResultCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[SongSearchResultTableViewCell alloc] init];
    }
    
    //
    // Get the Relevant Song Data from the model
    //
    SongData * sd = (SongData *)(self.songArrayModelData[indexPath.row]);
    
    cell.songTitleLabel.text = sd.title;
    cell.songChordsLabel.text = [[sd.chords valueForKey:@"description"] componentsJoinedByString:@"  "];
    
    NSString * videoThunbNailImageUrlString = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/mqdefault.jpg", sd.youtube_id];
    
    //
    // This AFNetworking Category caches to disk
    //
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:videoThunbNailImageUrlString]
                                                                     cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                 timeoutInterval:60];
    
    [cell.songThumbnailImageView setImageWithURLRequest:urlRequest placeholderImage:[UIImage imageNamed:@"ThumbnailPlaceholder.png"] success:nil failure:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    // Give the thumbnails a slight grey border
    //
    cell.songThumbnailImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.songThumbnailImageView.layer.borderWidth = 1.0;
    
    //
    // Configure the favourite button with an icon
    //
    cell.rightButtons = @[ [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"favBig.png"] backgroundColor:[UIColor blueColor] ] ];
    cell.rightSwipeSettings.transition = MGSwipeTransitionRotate3D;
    
    cell.delegate = self;
    

    // IPAD needs this for seperator inset bleed
    cell.backgroundColor = UICOLORFROMRGB(0x2C2C2C);

    return cell;
}


#pragma mark - Favourite button handling

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    return YES;
}

//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction * favouriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Favourite" handler:^(UITableViewRowAction * ra, NSIndexPath * ip)
//                                              {
//                                                  NSLog(@"Favourite button pressed at row %ld", (long)ip.row);
//                                                  [self.tableView setEditing:NO]; // closes the slide out
//                                              }];
//    
//    favouriteAction.backgroundColor = [UIColor lightGrayColor];
//    
//    return [NSArray arrayWithObject:favouriteAction];
//
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
////
//// Need this for IOS 8 as required to make custom accessory work
////
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([ [segue identifier] isEqualToString:@"showSongSearchItemDetail"])
    {
        UINavigationController * nc = [segue destinationViewController];
        
        DetailViewController *dvc = (DetailViewController *)nc.topViewController;
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        dvc.songData = self.songArrayModelData[ip.row];
    }
}


#pragma mark - SongSearchApiManagerDelegate

//
// Read the returned JSON into our tableView Data Model excluding images
//
-(void)SongSearchApiManager:(SongSearchApiManager *)client didRecieveSongSearchDataOk:(NSDictionary *)searchResultsJson
{
    self.navigationItem.title = @"Search:";
    [self.activityIndicator stopAnimating];
    //
    // Clear out the model first
    //
    [self.songArrayModelData removeAllObjects];
    
    NSArray * jsonSongs = searchResultsJson[@"songs"];
    
    for (NSDictionary * jsonSong in jsonSongs)
    {
        SongData * sd = [[SongData alloc] init];
        
        sd.id = [jsonSong[@"id"] intValue];
        sd.youtube_id = jsonSong[@"youtube_id"];
        sd.title = jsonSong[@"title"];
        sd.status = jsonSong[@"status"];
        sd.duration = [ jsonSong[@"duration"] intValue];
        sd.chords = jsonSong[@"chords"];
        
        [self.songArrayModelData addObject:sd];
    }
    
    // Need to refresh the table with the latest model data
    [self.tableView reloadData];
    
}

-(void)SongSearchApiManager:(SongSearchApiManager *)client didFailToRecieveSongSearchData:(NSError *)error withTask:(NSURLSessionDataTask *)task
{
    self.navigationItem.title = @"Search:";
    [self.activityIndicator stopAnimating];
    
    //
    // Need an alert here in case network is offline
    //
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem Retrieving Search Results"
                                                        message:[NSString stringWithFormat:@"%@",[error localizedDescription]]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

}

@end
