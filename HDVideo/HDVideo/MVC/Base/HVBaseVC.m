//
//  HVBaseVC.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVBaseVC.h"

@interface HVBaseVC ()
@property (nonatomic, strong) HVNetworkManager *networkManager;
@property (nonatomic, strong) HVUtil *util;
@end

@implementation HVBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (HVNetworkManager *) networkManager{
    if (!_networkManager) {
        _networkManager = [HVNetworkManager sharedService];
    }
    return _networkManager;
}

- (HVUtil *) util{
    if (!_util) {
        _util = [HVUtil shareUtil];
    }
    return _util;
}

@end
