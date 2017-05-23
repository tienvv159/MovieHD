//
//  HVResponseObject.h
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <AFNetworking/AFNetworking.h>

@interface HVResponseObject : JSONModel
@property (strong, nonatomic) NSNumber <Ignore> *statusCode;
@property (strong, nonatomic) NSError <Ignore>*errorException;
@property (strong, nonatomic) id <Optional> responseData;
@property (strong, nonatomic) NSString <Optional>* message;
@property (strong, nonatomic) NSNumber* responseCode;


+ (HVResponseObject *)responseObjectWithResponse:(NSHTTPURLResponse*)response
                                  responseObject:(id)responseObject
                                           error:(NSError *)error;
@end
