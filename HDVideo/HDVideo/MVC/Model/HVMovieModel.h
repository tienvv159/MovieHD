//
//  HVMovieModel.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/5/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HVMovieModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *MovieID;
@property (nonatomic, strong) NSString <Optional> *MovieName;
@property (nonatomic, strong) NSString <Optional> *KnownAs;
@property (nonatomic, strong) NSString <Optional> *CategoryID;
@property (nonatomic, strong) NSString <Optional> *Poster100x149;
@property (nonatomic, strong) NSString <Optional> *CategoryName;
@property (nonatomic, strong) NSString <Optional> *Cover;
@property (nonatomic, strong) NSString <Optional> *Movielink;
@property (nonatomic, strong) NSString <Optional> *Slug;
@property (nonatomic, strong) NSString <Optional> *PlotVI;

@end
