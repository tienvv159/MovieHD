//
//  HVResponseObject.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVResponseObject.h"

@implementation HVResponseObject
+ (JSONKeyMapper *)keyMapper {
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                        @"responseData":@"r",
                                        @"responseCode":@"e"
                                                                                    }];
    return mapper;
}

+ (HVResponseObject *)responseObjectWithResponse:(NSHTTPURLResponse *)response
                                  responseObject:(id)responseObject
                                           error:(NSError *)error {
    HVResponseObject *obj = nil;
    NSMutableDictionary* responseDict;
    //    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    //    if (str.length<10000) {
    //        NSLog(@"%s %@", __func__, str);
    //    }
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        responseDict = [HVResponseObject parseDictFromData:responseObject];
    }
    else if ([responseObject isKindOfClass:[NSString class]]) {
        responseDict = [HVResponseObject parseDictFromData:[responseObject dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([responseObject isKindOfClass:[NSDictionary class]]) {
        responseDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
    }
    
    if (responseDict) {
        NSMutableDictionary *mInfo = [[NSMutableDictionary alloc] initWithDictionary:responseDict];
        id resultData = [mInfo objectForKey:@"data"];
        if (resultData) {
            if ([resultData isKindOfClass:[NSArray class]]) {
                if (!((NSArray *)resultData).count) {
                    resultData = @{};
                    [mInfo setObject:resultData forKey:@"data"];
                }
            }
        }
        
        NSError *parserError = nil;
        obj = [[HVResponseObject alloc] initWithDictionary:mInfo error:&parserError];
        obj.errorException = error ? error : parserError;
        obj.statusCode = @(response.statusCode);
    }
    
    return obj;
}

+ (NSMutableDictionary*)parseDictFromData:(id)data {
    NSError* jsonError;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSMutableDictionary* responseDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    return responseDict;
}
@end
