//
//  HVMovieCategoryMenu.h
//  HDVideo
//
//  Created by Vu Van Tien on 5/17/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HVMovieCategoryMenu : JSONModel
@property (nonatomic, strong) NSString *CategoryName;
@property (nonatomic, strong) NSString *CategoryID;
@property (nonatomic, strong) NSString *Subcate;

@end
