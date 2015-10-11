//
//  SongSearchResultTableViewCell.h
//  YouTubePlayer
//
//  Created by Derek Doherty on 04/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

//
// Custom Cell for the Table View
//
//@interface SongSearchResultTableViewCell : UITableViewCell

@interface SongSearchResultTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *songThumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *songChordsLabel;

@end
