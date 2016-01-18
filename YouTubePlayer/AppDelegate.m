//
//  AppDelegate.m
//  YouTubePlayer
//
//  Created by Derek Doherty on 30/09/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:YES];
    
    UISplitViewController * svc = (UISplitViewController *)self.window.rootViewController;
    svc.delegate = self;
    
    //self.window.backgroundColor = [UIColor blueColor];
    self.window.layer.backgroundColor = [[UIColor blackColor] CGColor];
    
    if ( [ UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        svc.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        //svc.preferredPrimaryColumnWidthFraction = 0.33;
        //svc.maximumPrimaryColumnWidth = 512;
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UISplitViewControllerDelegate

//
// Handle the splitviewcontroller collapse behaviour
//
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    
    if ( [ secondaryViewController isKindOfClass:[UINavigationController class] ]  )
    {
        DetailViewController * dvc = (DetailViewController *)((UINavigationController *)secondaryViewController).topViewController ;
        if (dvc.songData != nil) // A selection has been made
        {
            if ( [ primaryViewController isKindOfClass:[UINavigationController class] ]  )
            {
                [ (UINavigationController * )primaryViewController setNavigationBarHidden:NO animated:NO ];
                return NO;
            }
        }
        else // ( dvc.songData == nil) // No selection Made
        {
            return YES; // Override the default behaviour as songData is nil, will show master on collapse
        }
    }
    return NO;  // Don't Override the default behaviour as the secondary view controller songData has already been initialized
}

@end
