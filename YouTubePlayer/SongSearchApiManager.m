//
//  SongSearchApiManager.m
//  YouTubePlayer
//
//  Created by Derek Doherty on 01/10/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "SongSearchApiManager.h"


static NSString * const songSearchServerUrlString = @"https://api.myjson.com/bins/yjym/";

@implementation SongSearchApiManager

//
// Use thread safety for creating the Singleton
//
+(instancetype)sharedSongSearchApiManager
{
    static SongSearchApiManager * sssam = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sssam = [[self alloc] initWithBaseURL:[NSURL URLWithString:songSearchServerUrlString]];
    });
    
    return sssam;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{
    if ( (self = [super initWithBaseURL:url]) )
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];  // Not needed for GET
    }
    return self;
}


//
// Here we call the API and pass on the data to the delegate
//
-(void)getSongDataWithSearchCriteria:(NSString *)searchCriteria
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    // parameters[@"SearchCriteria"] = searchCriteria;
    NSError *error = nil;
    
    // Just get the json locally rather than over the network for DEMO PURPOSES
    if ( [searchCriteria isEqualToString:@"offline"])
    {
        NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"json"];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile options:kNilOptions error:&error ];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        //NSLog(@"Returned JSON is = >%@", json );         //NSData *jsonData = [NSData dataWith
        
        if (json)
        {
           [self.delegate SongSearchApiManager:self didRecieveSongSearchDataOk:(NSDictionary *)json];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(SongSearchApiManager:didFailToRecieveSongSearchData:withTask:)])
            {
                [self.delegate SongSearchApiManager:self didFailToRecieveSongSearchData:nil withTask:nil];
            }
        }
        
        return;
    }
    
    
    
    
    [self GET:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [self.delegate SongSearchApiManager:self didRecieveSongSearchDataOk:(NSDictionary *)responseObject];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        //
        // This one is optional so need to check for it's existence in the delegate
        //
        if ([self.delegate respondsToSelector:@selector(SongSearchApiManager:didFailToRecieveSongSearchData:withTask:)])
        {
            [self.delegate SongSearchApiManager:self didFailToRecieveSongSearchData:error withTask:task];
        }
    }];
}


@end
