//
//  HVUtil.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVUtil.h"
#import "MBProgressHUD.h"

@implementation HVUtil
+ (instancetype)shareUtil {
    static HVUtil *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HVUtil alloc] init];
    });
    return _sharedClient;
}

#pragma mark - Loading
- (void)showLoadingInView:(UIView *)view{
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)dismissLoadingInView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
