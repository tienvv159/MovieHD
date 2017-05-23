//
//  HVHomeDetail.m
//  HDVideo
//
//  Created by Vu Van Tien on 5/8/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVHomeDetail.h"
#import "HVPlayMovie.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIImageView+AFNetworking.h"
#import "HVCollectionViewCellDeatail.h"
#import "HVMovieRelativeModel.h"

@interface HVHomeDetail () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBigView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSmallView;
@property (weak, nonatomic) IBOutlet UILabel *lblNameEnglish;
@property (weak, nonatomic) IBOutlet UILabel *lblNameVietNam;
@property (weak, nonatomic) IBOutlet UITextView *lblIntroduce;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end

@implementation HVHomeDetail
{
    NSString *linkImgBannerDetail, *linkImgCateDetail;
    NSString *linkMovie;
    NSString *epMovie;
    NSString *introduce;
    NSMutableArray *_arrListRelative;
    NSString *movieIDRelative;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataDetail];
}

- (void) viewDidAppear:(BOOL)animated{
    self.myScrollView.contentSize = CGSizeMake(_myScrollView.frame.size.width, _myScrollView.frame.size.height + 200);
}


- (void) getDataDetail{
    if (_movieBanner) {
        [self.util showLoadingInView:self.view];
        [self.networkManager getDetailOfVideo:_movieBanner.MovieID ep:@"0" completion:^(HVResponseObject *responseObject) {
            [self.util dismissLoadingInView:self.view];
            if (!responseObject.responseCode.boolValue) {
                // Success
                _arrListRelative = [NSMutableArray array];
                NSDictionary *dic = (NSDictionary *)responseObject.responseData;
                NSString *string = [dic objectForKey:@"Poster214x321"];
                linkImgBannerDetail = [NSString stringWithFormat:@"%@", string];
                introduce = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PlotVI"]];
                [self getModelRelativeMovie:dic];
            }else{
                //error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:btnOk];
                [self presentViewController:alert animated:YES completion:nil];

            }
            
            [self handlingMovieBanner];
            [_myCollectionView reloadData];
        }];

    }else if (_movieByCate){
        [self.util showLoadingInView:self.view];
        [self.networkManager getDetailOfVideo:[_movieByCate valueForKey:@"MovieID"] ep:@"0" completion:^(HVResponseObject *responseObject) {
            [self.util dismissLoadingInView:self.view];
            if (!responseObject.responseCode.boolValue) {
                // Success
                NSDictionary *dic = (NSDictionary *)responseObject.responseData;
                NSString *string = [dic objectForKey:@"Banner"];
                linkImgCateDetail = [NSString stringWithFormat:@"%@", string];
                introduce = [NSString stringWithFormat:@"%@", [dic objectForKey:@"PlotVI"]];
                [self getModelRelativeMovie:dic];
            }else{
                // Error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:btnOk];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self handlingMovieBycate];
            [_myCollectionView reloadData];

        }];

    }else if (_movieByCateMenu){
        [self.util showLoadingInView:self.view];
        [self.networkManager getDetailOfVideo:[_movieByCate valueForKey:@"MovieID"] ep:@"0" completion:^(HVResponseObject *responseObject) {
            [self.util dismissLoadingInView:self.view];
            if (!responseObject.responseCode.boolValue) {
                // Success
                NSDictionary *dic = (NSDictionary *)responseObject.responseData;
                NSString *string = [dic objectForKey:@"Banner"];
                linkImgCateDetail = [NSString stringWithFormat:@"%@", string];
                [self getModelRelativeMovie:dic];
               // NSLog(@"%@", _arrListRelative);
            }else{
                // Error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:btnOk];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            [self hendlingMovieBycateMenu];
            [_myCollectionView reloadData];

        }];

    }else if (_movieBySearch){
        [self.util showLoadingInView:self.view];
        [self.networkManager getDetailOfVideo:_movieBySearch.MovieID ep:@"0" completion:^(HVResponseObject *responseObject) {
            [self.util dismissLoadingInView:self.view];
            if (!responseObject.responseCode.boolValue) {
                // Success
                NSDictionary *dic = (NSDictionary *)responseObject.responseData;
                NSString *string = [dic objectForKey:@"Poster100x149"];
                linkImgCateDetail = [NSString stringWithFormat:@"%@", string];
                introduce = [NSString stringWithFormat:@"%@", [dic objectForKey:@"PlotVI"]];
                [self getModelRelativeMovie:dic];
                NSLog(@"%@", _arrListRelative);
            }else{
                // Error
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:btnOk];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self hendlingMovieSearch];
            [_myCollectionView reloadData];

        }];

    }
}


- (void) hendlingMovieSearch{
    _lblNameEnglish.text = _movieBySearch.MovieName;
    _lblNameVietNam.text = _movieBySearch.KnownAs;
    _lblIntroduce.text = introduce;
    
    [_imgBigView setImageWithURL:[NSURL URLWithString:_movieBySearch.Cover] placeholderImage:_imgBigView.image];
    
    [_imgSmallView setImageWithURL:[NSURL URLWithString:linkImgCateDetail] placeholderImage:_imgSmallView.image];

}

- (void) handlingMovieBanner{
    _lblNameEnglish.text = _movieBanner.MovieName;
    _lblNameVietNam.text = _movieBanner.KnownAs;
    _lblIntroduce.text = introduce;
    
    [_imgBigView setImageWithURL:[NSURL URLWithString:_movieBanner.Cover] placeholderImage:_imgBigView.image];
    
    [_imgSmallView setImageWithURL:[NSURL URLWithString:linkImgBannerDetail] placeholderImage:_imgSmallView.image];
    
}


- (void) handlingMovieBycate{
    _lblNameEnglish.text = [_movieByCate valueForKey:@"MovieName"];
    _lblNameVietNam.text = [_movieByCate valueForKey:@"KnownAs"];
    _lblIntroduce.text = introduce;
    [_imgBigView setImageWithURL:[NSURL URLWithString:linkImgCateDetail] placeholderImage:_imgBigView.image];
    [_imgSmallView setImageWithURL:[NSURL URLWithString:[_movieByCate valueForKey:@"Poster100x149"]] placeholderImage:_imgSmallView.image];
}

- (void) hendlingMovieBycateMenu{
    _lblNameEnglish.text = [_movieByCateMenu valueForKey:@"MovieName"];
    _lblNameVietNam.text = [_movieByCateMenu valueForKey:@"KnownAs"];
    _lblIntroduce.text = [_movieByCateMenu valueForKey:@"PlotVI"];
    [_imgBigView setImageWithURL:[NSURL URLWithString:linkImgCateDetail] placeholderImage:_imgBigView.image];
    [_imgSmallView setImageWithURL:[NSURL URLWithString:[_movieByCateMenu valueForKey:@"Poster100x149"]] placeholderImage:_imgSmallView.image];
}


- (IBAction)btnListEpisode:(id)sender {
}
- (IBAction)btnPlayMovie:(id)sender {
    
    if (_movieBanner) {
        [self getLinkPlayAndPlayMovie:_movieBanner.MovieID];
    }else if (_movieByCate){
        [self getLinkPlayAndPlayMovie:[_movieByCate valueForKey:@"MovieID"]];
    }else if (_movieByCateMenu){
        [self getLinkPlayAndPlayMovie:[_movieByCateMenu valueForKey:@"MovieID"]];
    }else if (_movieBySearch){
        [self getLinkPlayAndPlayMovie:_movieBySearch.MovieID];
    }else if (_arrListRelative){
        [self getLinkPlayAndPlayMovie:movieIDRelative];
    }
}

- (void) getLinkPlayAndPlayMovie:(NSString*) idMovie{
    [self.util showLoadingInView:self.view];
    [self.networkManager getLinkPlayMovie:idMovie ep:@"0" completion:^(HVResponseObject *responseObject) {
        [self.util dismissLoadingInView:self.view];
        
        if (!responseObject.responseCode.boolValue) {
            //seccess;
            NSDictionary *dic = (NSDictionary *)responseObject.responseData;
            linkMovie = [NSString stringWithFormat:@"%@", [dic objectForKey:@"LinkPlay"]];
            epMovie = [NSString stringWithFormat:@"0"];
            
            
            NSURL *urlVideo = [NSURL URLWithString:linkMovie];
            AVPlayer *playerV = [AVPlayer playerWithURL:urlVideo];
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            playerViewController.player = playerV;
            [self presentViewController:playerViewController animated:YES completion:^{
                [playerV play];
            }];
        }else{
            // error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:btnOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

- (void) getModelRelativeMovie:(NSDictionary*)dic{
    _arrListRelative = [dic objectForKey:@"Relative"];
}
#pragma scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"123");
}



#pragma collection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat itemWidth = (collectionView.frame.size.width - margin * 2)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 1.6);
    
    return itemSize;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrListRelative.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HVCollectionViewCellDeatail *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemInDetail" forIndexPath:indexPath];
    
    NSMutableArray *arrNameAllMovieRelative = [NSMutableArray array];
    NSMutableArray *arrLinkPoster100x149MovieRelative = [NSMutableArray array];

    for (NSDictionary *dicModel in _arrListRelative) {
        HVMovieRelativeModel *movieModel = [[HVMovieRelativeModel alloc] initWithDictionary:dicModel error:nil];
        [arrNameAllMovieRelative addObject:movieModel.Name];
        [arrLinkPoster100x149MovieRelative addObject:movieModel.Poster100x149];
    }
    
    cell.lblNameMovie.text = arrNameAllMovieRelative[indexPath.item];
    NSString *stringLink = arrLinkPoster100x149MovieRelative[indexPath.item];
    [cell.imgMovie setImageWithURL:[NSURL URLWithString:stringLink] placeholderImage:cell.imgMovie.image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arrNameELRelative = [NSMutableArray array];
    NSMutableArray *arrNameVNRelative = [NSMutableArray array];
    NSMutableArray *arrPosterRelative = [NSMutableArray array];
    NSMutableArray *arrPoster100x149Relative = [NSMutableArray array];
    NSMutableArray *arrIDMovieRelative = [NSMutableArray array];
    for (NSDictionary *dicModel in _arrListRelative) {
        HVMovieRelativeModel *movieModel = [[HVMovieRelativeModel alloc] initWithDictionary:dicModel error:nil];
        [arrNameELRelative addObject:movieModel.Name];
        [arrNameVNRelative addObject:movieModel.KnownAs];
        [arrPosterRelative addObject:movieModel.Poster];
        [arrPoster100x149Relative addObject:movieModel.Poster100x149];
        [arrIDMovieRelative addObject:movieModel.MovieID];
    }
    movieIDRelative = arrIDMovieRelative[indexPath.item];
    _lblNameEnglish.text = arrNameELRelative[indexPath.item];
    _lblNameVietNam.text = arrNameVNRelative[indexPath.item];
    
    [_imgBigView setImageWithURL:[NSURL URLWithString:arrPosterRelative[indexPath.item]] placeholderImage:_imgBigView.image];
    
    [_imgSmallView setImageWithURL:[NSURL URLWithString:arrPoster100x149Relative[indexPath.item]] placeholderImage:_imgSmallView.image];
    
    // sau khi lấy đc MovieID lại load lại phim liên quan theo id đó
    [self.util showLoadingInView:self.view];
    [self.networkManager getDetailOfVideo:arrIDMovieRelative[indexPath.item] ep:@"0" completion:^(HVResponseObject *responseObject) {
        [self.util dismissLoadingInView:self.view];
        if (!responseObject.responseCode.boolValue) {
            // Success
            _arrListRelative = [NSMutableArray array];
            NSDictionary *dic = (NSDictionary *)responseObject.responseData;
            introduce = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PlotVI"]];
            [self getModelRelativeMovie:dic];
        }else{
            //error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:btnOk];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        _lblIntroduce.text = introduce;
        
        [_myCollectionView reloadData];
    }];

    
}

@end
