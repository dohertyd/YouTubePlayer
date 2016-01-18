//
//  DetailViewController.m
//  YouTubePlayer
//
//  Created by Derek Doherty on 02/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "DetailViewController.h"
#import "YTPlayerView.h"

@interface DetailViewController () <YTPlayerViewDelegate>

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *curtainView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSPinner;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (strong, nonatomic) UIImageView * playPauseButtonView;

//
// Track the player state
//
typedef NS_ENUM(NSInteger, VideoPlayerState)
{
    VPSTOPPED,
    VPSTARTED,
    VPPAUSED
};

@property (assign) VideoPlayerState videoPlayerState;

@end


@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Setup left bar button depending on split view controllers wish
    //
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;    
    self.navigationItem.leftItemsSupplementBackButton = YES;  // Don't blank out normal back button on Iphone in collapsed mode
    
    
    [self.navigationController.navigationBar setBarTintColor:UICOLORFROMRGB(0x1A1A1A)];
    
    
    
    
    //    UIButton *customButton = nil;
    //    UIImage  *buttonImage = nil;
    //    UIImage  *pressedButtonImage = nil;
    //
    //    buttonImage = [UIImage imageNamed:@"button_image"];
    //    pressedButtonImage = [UIImage imageNamed:@"button_pressed_image"];
    //    customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [customButton setImage : buttonImage forState : UIControlStateNormal];
    //    [customButton setImage : pressedButtonImage forState : UIControlStateHighlighted];
    //    [customButton addTarget : self action : @selector(buttonTapped) forControlEvents : UIControlEventTouchUpInside];
    //    customButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    //
    //    UIView *container = [[UIView alloc] initWithFrame:(CGRect){0.0, 0.0, buttonImage.size.width, buttonImage.size.height}];
    //    container.backgroundColor = [UIColor clearColor];
    //    [container addSubview:customButton];
    //
    //    UIBarButtonItem *customToolbarButton = [[UIBarButtonItem alloc] initWithCustomView:container];
    //
    //    // add the custom button to the toolbar
    //    self.navigationBar.topItem.rightBarButtonItem = self.addButtonItem;
    
    
    // NEW could have used a UiButton here as above and have features easily, placing it in a container view before adding to UiBarButtonItem
    //
    // Setup a Play/Pause button in the RHS of the Nav bar
    //
    self.playPauseButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
    self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.playPauseButtonView];
    self.playPauseButtonView.hidden = YES;
    
    [[self navigationItem] setRightBarButtonItem:barButton];
    self.videoPlayerState = VPSTOPPED;
    
    // NEW - could use appearance proxy with traits here
    //
    // Adjust Nav bar title text attributes
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
    // Set the song title in the Nav bar
    //
    self.navigationItem.title = self.songData.title;
    
    self.playerView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.curtainView.hidden = NO;
    
    self.loadingSPinner.hidden = YES;
    self.errorLabel.hidden = YES;

    //
    // Setup Play/Pause button Image to recieve and handle taps
    //
    UITapGestureRecognizer *playPauseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseTap)];
    
    [self.playPauseButtonView setUserInteractionEnabled:YES];
    
    [self.playPauseButtonView addGestureRecognizer:playPauseTap];
}

-(void)playPauseTap
{
    if (self.videoPlayerState == VPSTARTED)
    {
        [self.playerView pauseVideo];
    }
    else
    {
        [self.playerView playVideo];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.songData) // If this is nil then no selection has been made in this case
    {
        //
        // Only start a spinner if we have selected a song
        //
        self.loadingSPinner.hidden = NO;
        [self.loadingSPinner startAnimating];
        NSDictionary *playerVars = @{ @"playsinline" : @1 , @"controls" : @0 , @"modestbranding" : @1, @"showinfo" : @0, @"rel" : @0 , @"origin" : @"http://www.example.com/"};
        
        [self.playerView loadWithVideoId:self.songData.youtube_id playerVars:playerVars];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.playerView stopVideo];
    [self.playerView loadWithVideoId:@""];

}


#pragma  mark - YTPlayerViewDelegate

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    //NSLog(@"playerViewDidBecomeReady");
    [self.playerView playVideo];
}


- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality
{
    //NSLog(@"didChangeToQuality : %ld", (long)quality);
}

- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    
    switch (error) {
        case kYTPlayerErrorInvalidParam:
            break;
        case kYTPlayerErrorHTML5Error:
        case kYTPlayerErrorVideoNotFound:
        case kYTPlayerErrorNotEmbeddable:
            [self.loadingSPinner stopAnimating];
            self.loadingSPinner.hidden = YES;
            
            self.playPauseButtonView.hidden = YES;
            self.curtainView.hidden = NO;
            
            self.errorLabel.hidden = NO;
            self.errorLabel.text = @"There was a problem loading the selected video, please return to the search results and select a different video";
        case kYTPlayerErrorUnknown:
            break;
        default:
            break;
    };
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime
{
    //NSLog(@"didPlayTime: %.3f", playTime);
    
    if ( self.videoPlayerState != VPSTARTED)
    {
        [self.loadingSPinner stopAnimating];
        self.loadingSPinner.hidden = YES;
        
        self.curtainView.hidden = YES;
        
        self.playPauseButtonView.hidden = NO;
        self.playPauseButtonView.image = [UIImage imageNamed:@"PauseButtonBlue.png"];
        self.videoPlayerState = VPSTARTED;
    }
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            //NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            //NSLog(@"Paused playback");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];
            self.videoPlayerState = VPPAUSED;
            break;
        case kYTPlayerStateUnstarted:
            //NSLog(@"kYTPlayerStateUnstarted");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];

            [self.loadingSPinner stopAnimating];
            self.loadingSPinner.hidden = YES;
            
            self.playPauseButtonView.hidden = YES;
            self.curtainView.hidden = NO;
            
            self.videoPlayerState = VPSTOPPED;
            break;
        case kYTPlayerStateEnded:
            //NSLog(@"kYTPlayerStateEnded");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];

            self.videoPlayerState = VPSTOPPED;
            break;
        case kYTPlayerStateBuffering:
            //NSLog(@"kYTPlayerStateBuffering");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PauseButtonBlue.png"];
            self.videoPlayerState = VPSTOPPED;
            break;
        case kYTPlayerStateQueued:
            //NSLog(@"kYTPlayerStateQueued");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];

            self.videoPlayerState = VPSTOPPED;
            break;
        case kYTPlayerStateUnknown:
            //NSLog(@"kYTPlayerStateUnknown");
            self.playPauseButtonView.image = [UIImage imageNamed:@"PlayButtonBlue.png"];

            self.videoPlayerState = VPSTOPPED;
            break;
        default:
            break;
    }
}

@end
