//
//  YouTubePlayerTests.m
//  YouTubePlayerTests
//
//  Created by Derek Doherty on 30/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterTableViewController.h"
#import "SongData.h"
#import "SongSearchApiManager.h"



@interface YouTubePlayerTests : XCTestCase <SongSearchApiManagerDelegate>

@property (strong, nonatomic) XCTestExpectation *expectation;

@end

@implementation YouTubePlayerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void)testIntialStateOfVarsAfterViewDidLoad
{
    SongData * sd = [[SongData alloc] init];
    
    XCTAssert((sd.chords == nil) , @"Chords variable not initialised correctly");
    XCTAssertEqual(sd.chords, nil, @"Chords variable not initialised correctly");
    XCTAssertNil(sd.chords, @"Chords variable not initialised correctly");
    
   // XCTAssertNotEqual(sd.chords, nil, @"Chords variable not initialised correctly");
}


// -----------------------------------------------------------------------------------------------------
-(void)testSongSearchCall
{
    self.expectation = [self expectationWithDescription:@"Expect Song Data to be returned"];
    
    SongSearchApiManager * client = [SongSearchApiManager sharedSongSearchApiManager];
    client.delegate = self;
    
    [client getSongDataWithSearchCriteria:@"online"]; // Use the newtwork here
    
    //[expectation fulfill];   //

    
    // Wait for the Semaphore to be released
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error)
    {
        if (error)
        {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}
-(void)SongSearchApiManager:(SongSearchApiManager *)client didRecieveSongSearchDataOk:(NSDictionary *)searchResultsJson
{
    [self.expectation fulfill];
}
// -----------------------------------------------------------------------------------------------------


-(void)testPerformance
{
    [self measureBlock:^{
       // [self testSongSearchCall];
        
    }];
}

@end
