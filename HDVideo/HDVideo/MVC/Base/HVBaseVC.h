//
//  HVBaseVC.h
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVNetworkManager.h"
#import "HVUtil.h"
@interface HVBaseVC : UIViewController
@property (nonatomic, strong, readonly) HVNetworkManager *networkManager;
@property (nonatomic, strong, readonly) HVUtil *util;
@end
