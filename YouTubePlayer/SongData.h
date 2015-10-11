//
//  SongData.h
//  YouTubePlayer
//
//  Created by Derek Doherty on 02/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//
// Gives an easy macro using hexvalues in UIColor generation
//
#define UICOLORFROMRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface SongData : NSObject

//
// This for the most part represents the json returned from a search
//
@property (assign) NSInteger id;
@property (strong, nonatomic) NSString * youtube_id;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * status;
@property (assign) NSInteger duration;
@property (strong, nonatomic) NSArray * chords;


@end