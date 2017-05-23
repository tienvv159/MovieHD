//
//  AppDelegate.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "HVHomeVC.h"
#import "HVViewDetailMenu.h"

@interface AppDelegate ()
@property (nonatomic, strong) HVHomeVC *homeVC;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;
@end

@implementation AppDelegate
//+ (id)appDelegate{
//    
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

     _mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *menuView = [_mainStoryboard instantiateViewControllerWithIdentifier:@"ViewMenu"];
    
    UIViewController *centerView = [_mainStoryboard instantiateViewControllerWithIdentifier:@"CenterView"];
    
    if ([centerView isKindOfClass:[HVHomeVC class]]) {
        _homeVC = (HVHomeVC *)centerView;
    }
    
    UINavigationController *naviMenu = [[UINavigationController alloc] initWithRootViewController:menuView];
    UINavigationController *naviCenter = [[UINavigationController alloc] initWithRootViewController:centerView];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:naviCenter leftDrawerViewController:naviMenu];

    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView;
    
    self.window.rootViewController = self.drawerController;
    [self.window makeKeyWindow];
    
    return YES;
}


- (void) gotoCategoryDetailForCategory:(NSString *)categoryID{
    [self.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        HVViewDetailMenu *detailVC = [_mainStoryboard instantiateViewControllerWithIdentifier:@"HomeDetailMenu"];
        
        detailVC.categoryID = categoryID;
        [_homeVC.navigationController pushViewController:detailVC animated:YES];
    }];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
