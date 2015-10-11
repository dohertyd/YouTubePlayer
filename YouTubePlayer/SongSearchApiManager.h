//
//  SongSearchApiManager.h
//  YouTubePlayer
//
//  Created by Derek Doherty on 01/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

//
// This Class handles the Search API at https://api.myjson.com/bins/yjym/
//

#import "AFHTTPSessionManager.h"

@protocol SongSearchApiManagerDelegate;



@interface SongSearchApiManager : AFHTTPSessionManager

@property (nonatomic, weak) id<SongSearchApiManagerDelegate>delegate;

+(instancetype)sharedSongSearchApiManager;
-(instancetype)initWithBaseURL:(NSURL *)url;

-(void)getSongDataWithSearchCriteria:(NSString *)searchCriteria;

@end

//
// This allows users to have there callback functions called async when infois availabke
//
@protocol SongSearchApiManagerDelegate <NSObject>
@required
-(void)SongSearchApiManager:(SongSearchApiManager *)client didRecieveSongSearchDataOk:(NSDictionary *)searchResultsJson;
@optional
-(void)SongSearchApiManager:(SongSearchApiManager *)client didFailToRecieveSongSearchData:(NSError *)error withTask:(NSURLSessionDataTask *)task;
@end
