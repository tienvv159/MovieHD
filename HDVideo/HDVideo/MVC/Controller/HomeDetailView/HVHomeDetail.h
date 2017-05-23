//
//  HVHomeDetail.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/8/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVBaseVC.h"
#import "HVMovieModel.h"
#import "HVMovieByCatgoryModel.h"

@interface HVHomeDetail : HVBaseVC
@property (nonatomic, strong) HVMovieModel *movieBanner;

@property (nonatomic, strong) HVMovieModel *movieByCate;
@property (nonatomic, strong) HVMovieByCatgoryModel *categoryModel;

@property (nonatomic, strong) HVMovieModel *movieByCateMenu;

@property (nonatomic, strong) HVMovieModel *movieBySearch;
@end
