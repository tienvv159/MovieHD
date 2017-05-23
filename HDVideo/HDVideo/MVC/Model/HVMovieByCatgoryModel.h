//
//  HVMovieByCatgoryModel.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/5/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HVMovieModel.h"

@interface HVMovieByCatgoryModel : JSONModel
@property (nonatomic, strong) NSString *CategoryName;
@property (nonatomic, strong) NSArray *Movies;
@property (nonatomic, strong) NSString *CategoryID;
@end
