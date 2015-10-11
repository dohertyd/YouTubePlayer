//
//  DetailViewController.h
//  YouTubePlayer
//
//  Created by Derek Doherty on 02/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongData.h"

@interface DetailViewController : UIViewController

// This is been set by the masterViewController, nil when no selection made
@property (strong, nonatomic) SongData * songData;

@end
