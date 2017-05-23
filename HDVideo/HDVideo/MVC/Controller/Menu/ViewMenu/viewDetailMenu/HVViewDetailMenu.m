//
//  HVViewDetailMenu.m
//  HDVideo
//
//  Created by Vu Van Tien on 5/16/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVViewDetailMenu.h"
#import "HVCollectionViewCellDetailMenu.h"
#import "HVCollectionHeaderView.h"
#import "HVMovieModel.h"
#import "UIImageView+AFNetworking.h"
#import "HVHomeDetail.h"
#import "HVMovieByCatgoryModel.h"

@interface HVViewDetailMenu () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation HVViewDetailMenu
{
    NSArray *_arrCategory;
    NSArray *_arrMovie;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getDataFromServerWithCategortID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) getDataFromServerWithCategortID{
    if ([_categoryID  isEqual: @"-1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Can not find category" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:btnOk];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        [self.util showLoadingInView:self.view];
        [self.networkManager getMovieWithCategoryID:_categoryID completion:^(HVResponseObject *responseObject) {
            [self.util dismissLoadingInView:self.view];
            
            if (!responseObject.responseCode.boolValue) {
                _arrMovie = [NSArray array];
                _arrCategory = [NSArray array];
                NSDictionary *dic = (NSDictionary *)responseObject.responseData;
                
                _arrCategory = [dic objectForKey:@"Category"];
                _arrMovie = [dic objectForKey:@"Movies"];
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:btnOk];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            [_myCollectionView reloadData];
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrMovie.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat itemWidth = (collectionView.frame.size.width - margin * 2)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 1.6);
    
    return itemSize;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HVCollectionViewCellDetailMenu *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemMenu" forIndexPath:indexPath];
    
    HVMovieModel *movieModel = [_arrMovie objectAtIndex:indexPath.item];
    
    cell.lblNameMovieDetail.text = [movieModel valueForKey:@"MovieName"];
    [cell.imgMovieDetail setImageWithURL:[NSURL URLWithString:[movieModel valueForKey:@"Poster100x149"]] placeholderImage:cell.imgMovieDetail.image];
    return  cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HVCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderMenu" forIndexPath:indexPath];
    
    NSString *stringName = [NSString stringWithFormat:@"  phim %@",[_arrCategory valueForKey:@"CategoryName"]];
    header.lblHeaderMenuDetai.text = stringName;
    return header;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HVHomeDetail *homeDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetail"];
    HVMovieModel *movieModel = [_arrMovie objectAtIndex:indexPath.item];
    homeDetail.movieByCateMenu = movieModel;
    [self.navigationController pushViewController:homeDetail animated:YES];
}


@end
