//
//  HVNetworkManager.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVNetworkManager.h"
#import "HVConfig.h"
#import "HVString.h"


@implementation HVNetworkManager

+ (instancetype)sharedService {
    static HVNetworkManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HVNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        AFHTTPResponseSerializer* responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // Add missing accept content types
        NSMutableSet *acceptableTypes = [NSMutableSet setWithSet:responseSerializer.acceptableContentTypes];
        [acceptableTypes addObject:@"text/html"];
        [acceptableTypes addObject:@"application/xml"];
        [acceptableTypes addObject:@"text/plain"];
        [acceptableTypes addObject:@"application/json"];
        [acceptableTypes addObject:@"text/xml"];
        [acceptableTypes addObject:@"text/json"];
        [acceptableTypes addObject:@"text/javascript"];
        
        [responseSerializer setAcceptableContentTypes:acceptableTypes];
        self.responseSerializer = responseSerializer;
        
        
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        [self.requestSerializer setTimeoutInterval:30];
        
    }
    
    
    return self;
}

#pragma mark - Base functions
- (NSURLSessionDataTask*)callWebserviceWithPath:(NSString *)path
                                         method:(NSString *)method
                                     parameters:(NSDictionary *)parameters
                                     completion:(void (^) (HVResponseObject *responseObject))completion {
    
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters path:path];
    NSLog(@"path = %@ --- Params = %@",request.URL,parameters);
    
    if (request) {
        NSURLSessionDataTask* task = [self dataTaskWithRequest:request completion:completion];
        [task resume];
        
        return task;
    }
    
    return nil;
}

- (void)callWebserviceWithPath:(NSString *)path
                        method:(NSString *)method
                    parameters:(NSDictionary *)parameters
                     filesData:(NSArray *)filesData
                     fileNames:(NSArray *)fileNames
          fileDescriptionNames:(NSArray *)descriptionNames
                    completion:(void (^) (HVResponseObject *responseObject))completion {
    
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters path:path filesData:filesData fileNames:fileNames fileDescriptionNames:descriptionNames];
    NSLog(@"path = %@ --- Params = %@",request.URL,parameters);
    if (request) {
               NSURLSessionDataTask* task = [self dataTaskWithRequest:request completion:completion];
        [task resume];
        
        //        return task;
    }
    else {
        completion(nil);
    }
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSDictionary *)parameters
                                      path:(NSString *)path {
    // 1
    NSError *error;
    NSURL *url;
    url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:[url absoluteString]
                                                                  parameters:parameters
                                                                       error:&error];
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSDictionary *)parameters
                                      path:(NSString *)path
                                 filesData:(NSArray *)filesData
                                 fileNames:(NSArray *)fileNames
                      fileDescriptionNames:(NSArray *)descriptionNames {
    // 1
    NSError *error;
    NSMutableURLRequest *request = nil;
    
    if (filesData != nil) { // Request with data file
        if (filesData.count != fileNames.count || fileNames.count != descriptionNames.count || descriptionNames.count != filesData.count) {
            //            return nil;
        }
        request = [self.requestSerializer multipartFormRequestWithMethod:method
                                                               URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                                              parameters:parameters
                                               constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
                                                   
                                                   for (int i = 0; i < filesData.count; i++) {
                                                       
                                                       [formData appendPartWithFileData:[filesData objectAtIndex:i]
                                                                                   name:[fileNames objectAtIndex:i]?:@""
                                                                               fileName:[descriptionNames objectAtIndex:i]?:@"image.png"
                                                                               mimeType:@"image/png"];
                                                   }
                                               }
                                                                   error:&error];
        
    }
    else { // Normal request
        [self.requestSerializer requestWithMethod:method
                                        URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString]
                                       parameters:parameters
                                            error:&error];
    }
    
    
    return request;
}


- (NSURLSessionDataTask*)dataTaskWithRequest:(NSURLRequest *)request completion:(void (^) (HVResponseObject *responseObject))completion {
    return [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        HVResponseObject* responseObj = [HVResponseObject responseObjectWithResponse:(NSHTTPURLResponse*)response responseObject:responseObject error:error];
        
        
        if (completion) {
            completion(responseObj);
        }
        
    }];
}

#pragma mark - Call API
- (void)getListVideoHomeCompletion:(HVResponseBlock)completion{
    [self callWebserviceWithPath:kPathListVideoHome method:kGET parameters:nil completion:completion];
}

- (void)getDetailOfVideo:(NSString *)videoID ep:(NSString *)ep completion:(HVResponseBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/movie?movieid=%@&ep=%@&sequence=0&accesstoken=null&sign=790657bff0963e6e0bf882a763633c7e", videoID, ep];
    [self callWebserviceWithPath:path method:kGET parameters:nil completion:completion];
}

- (void) getLinkPlayMovie: (NSString *)videoID ep:(NSString *)ep completion:(HVResponseBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/movie/play?movieid=%@&ep=%@&sequence=0&accesstoken=null&sign=790657bff0963e6e0bf882a763633c7e", videoID, ep];
    [self callWebserviceWithPath:path method:kGET parameters:nil completion:completion];
}

- (void) getAllCategoryCompletion:(HVResponseBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/category/menu?key=phim&sign=790657bff0963e6e0bf882a763633c7e"];
    [self callWebserviceWithPath:path method:kGET parameters:nil completion:completion];
}

- (void) getMovieWithCategoryID:(NSString *)categoryID completion:(HVResponseBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/movie/?categoryId=%@&key=phim&sign=790657bff0963e6e0bf882a763633c7e", categoryID];
    [self callWebserviceWithPath:path method:kGET parameters:nil completion:completion];
}

- (void) getMovieSearchWithKey:(NSString *)key completion:(HVResponseBlock)completion{
    NSString *path = [NSString stringWithFormat:@"/movie/search/?key=%@&sign=790657bff0963e6e0bf882a763633c7e", key];
    
    [self callWebserviceWithPath:path method:kGET parameters:nil completion:completion];
}
@end
