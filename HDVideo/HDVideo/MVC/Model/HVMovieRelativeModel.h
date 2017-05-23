//
//  HVMovieRelativeModel.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/20/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HVMovieRelativeModel : JSONModel
@property (nonatomic, strong) NSString *Poster;
@property (nonatomic, strong) NSString *Poster100x149;
@property (nonatomic, strong) NSString *MovieID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *KnownAs;

@end
