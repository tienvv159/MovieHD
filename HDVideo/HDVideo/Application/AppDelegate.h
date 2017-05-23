//
//  AppDelegate.h
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMDrawerController *drawerController;
//+ (id) appDelegate;
- (void) gotoCategoryDetailForCategory:(NSString*)categoryID;
@end

