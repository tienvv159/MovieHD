//
//  HVPlayMovie.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/9/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HVPlayMovie : JSONModel
@property (nonatomic, strong) NSString *linkPlay;
@property (nonatomic, strong) NSString *currentSeason;
@end
