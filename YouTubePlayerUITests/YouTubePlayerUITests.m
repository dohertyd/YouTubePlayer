//
//  YouTubePlayerUITests.m
//  YouTubePlayerUITests
//
//  Created by Derek Doherty on 30/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YouTubePlayerUITests : XCTestCase

@property (strong, nonatomic) XCUIApplication * app;

@end

@implementation YouTubePlayerUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    [[XCUIDevice sharedDevice] setOrientation:UIDeviceOrientationPortrait];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCUIElement * titleQ  =  self.app.navigationBars.staticTexts[@"Loading ..."];
    XCUIElement * titleS  =  self.app.staticTexts[@"Search:"];
    
   // XCTAssertTrue(titleS.exists, @"Did'nt find Search title on this screen");
    //XCUIElement * tableRow =self.app.tables.staticTexts[@"One"];
    XCUIElement *tableRow = self.app.tables.staticTexts[@"U2 - Every Breaking Wave"];
    [tableRow tap];
}
-(void)testRecording
{
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    //[XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    
    //XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *u2EveryBreakingWaveStaticText = self.app.tables.staticTexts[@"U2 - Every Breaking Wave"];

    
    [u2EveryBreakingWaveStaticText tap];
    
}


-(void)testrecording2
{
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"Beautiful Day"] tap];
    
    XCUIElement *element = [[[[[[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];
    [element tap];
    [[app.navigationBars matchingIdentifier:@"Beautiful Day"].buttons[@" "] tap];
    
    
    
}

@end
