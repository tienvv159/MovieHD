//
//  HVUtil.h
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HVUtil : NSObject
+ (instancetype) shareUtil;

#pragma mark - Loading
- (void) showLoadingInView:(UIView *)view;
- (void) dismissLoadingInView:(UIView *)view;
@end
