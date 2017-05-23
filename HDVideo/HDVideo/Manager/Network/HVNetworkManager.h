//
//  HVNetworkManager.h
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "HVResponseObject.h"

typedef void(^HVResponseBlock)(HVResponseObject* responseObject);

@interface HVNetworkManager : AFHTTPSessionManager
+ (instancetype)sharedService;

- (void) getListVideoHomeCompletion:(HVResponseBlock) completion;
- (void) getDetailOfVideo:(NSString *)videoID
                       ep:(NSString *)ep
               completion:(HVResponseBlock) completion;

- (void) getLinkPlayMovie:(NSString *)videoID
                       ep:(NSString *)ep
               completion:(HVResponseBlock)completion;

- (void) getAllCategoryCompletion:(HVResponseBlock) completion;

- (void) getMovieWithCategoryID:(NSString *)categoryID
                     completion:(HVResponseBlock)completion;

- (void) getMovieSearchWithKey:(NSString *)key
                    completion:(HVResponseBlock) completion;

@end
