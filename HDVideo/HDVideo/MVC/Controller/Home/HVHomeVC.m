//
//  HVHomeVC.m
//  HDVideo
//
//  Created by Vu Van Tien on 4/26/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVHomeVC.h"
#import "HVCollectionViewCell.h"
#import "HVMovieByCatgoryModel.h"
#import "HVHomeDetail.h"
#import "HVMovieModel.h"
#import "HVCollectionReusableView.h"
#import "UIImageView+AFNetWorking.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
#import "HVSearchVC.h"

@interface HVHomeVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControlBanner;


@end

@implementation HVHomeVC{
    NSMutableArray *_listMovieByCate;
    NSMutableArray *_listMovieBanner;
    NSTimer *timer1, *timer2;
    NSInteger currentPage;
    UIView *viewMenu, *view;
    UIButton *buttonMenu;
    BOOL check;
    NSMutableArray *_arrNameCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    check = true;
    [self getDataFromServer];
    currentPage = 0;
    timer1 = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerUpdateImgBanner) userInfo:nil repeats:YES];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateCurrentPage) userInfo:nil repeats:YES];
}


- (void) getDataFromServer{
    [self.util showLoadingInView:self.view];
    [self.networkManager getListVideoHomeCompletion:^(HVResponseObject *responseObject) {
        [self.util dismissLoadingInView:self.view];
        
        if (!responseObject.responseCode.boolValue) {
            _listMovieByCate = [NSMutableArray array];
            _listMovieBanner = [NSMutableArray array];
            _arrNameCategory = [NSMutableArray array];
            NSDictionary *dic = (NSDictionary *)responseObject.responseData;
            NSArray *movieByCategory = [dic objectForKey:@"MoviesByCates"];
            for (NSDictionary *movieDict in movieByCategory) {
                HVMovieByCatgoryModel *movieByCateModel = [[HVMovieByCatgoryModel alloc] initWithDictionary:movieDict error:nil];
                [_listMovieByCate addObject:movieByCateModel];

                [_arrNameCategory addObject:movieByCateModel.CategoryName];
            }
            NSArray *movieBanner = [dic objectForKey:@"Movies_Banners"];
            for (NSDictionary *dictBanner in movieBanner) {
                HVMovieModel *movieModel = [[HVMovieModel alloc] initWithDictionary:dictBanner error:nil];
                [_listMovieBanner addObject:movieModel];
            }
            [_myCollection reloadData];
            
        }else{
            // Todo: handle error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:btnOk];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self showImageBanner];
    }];
    
}


- (void) showImageBanner{
    NSMutableArray *_arrImgBanner = [[NSMutableArray alloc] init];
    for (int i = 0; i < _listMovieBanner.count; i++) {
        HVMovieModel *movieModel = [_listMovieBanner objectAtIndex:i];
        [_arrImgBanner addObject:movieModel.Cover];
    }
    
    CGSize pageScroolViewSize = _scrollView.frame.size;
    
    _scrollView.contentSize = CGSizeMake(pageScroolViewSize.width * _arrImgBanner.count, 0);
    for (int i = 0 ; i < _arrImgBanner.count; i++) {
        NSString *stringImg = _arrImgBanner[i];
        NSURL *urlImg = [NSURL URLWithString:stringImg];
        NSData *dataImg = [[NSData alloc] initWithContentsOfURL:urlImg];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageWithData:dataImg]];
        img.frame = CGRectMake(pageScroolViewSize.width * i, 0, pageScroolViewSize.width, pageScroolViewSize.height);
        img.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:img];
    }
    _scrollView.pagingEnabled = true;
}

- (IBAction)pageTapChangerImg:(id)sender {
    
    _scrollView.contentOffset = CGPointMake(_pageControlBanner.currentPage * _scrollView.frame.size.width, 0);
    [self displayNumberCurrentPage];

}

- (void) timerUpdateImgBanner{
    if (currentPage == 4) {
        currentPage = 0;
    }
    float myPageWidth = _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(currentPage * myPageWidth, 0) animated:YES];
    currentPage++;
}

- (void) updateCurrentPage{
    _pageControlBanner.currentPage++;
    [self displayNumberCurrentPage];
}

- (void) displayNumberCurrentPage{
    if (_pageControlBanner.currentPage == 0) {
        _lblPage.text = @"Season 0";
    }else if (_pageControlBanner.currentPage == 1){
        _lblPage.text = @"Season 1";
    }else if (_pageControlBanner.currentPage == 2){
        _lblPage.text = @"Season 2";
    }else if (_pageControlBanner.currentPage == 3){
        _lblPage.text = @"Season 3";
    }else if (_pageControlBanner.currentPage == 4){
        _lblPage.text = @"Season 4";
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    _pageControlBanner.currentPage = page;
    [self displayNumberCurrentPage];
}

- (IBAction)tapScrollView:(UITapGestureRecognizer *)sender {
    HVMovieModel *movie = [_listMovieBanner objectAtIndex:_pageControlBanner.currentPage];
    HVHomeDetail *homeDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetail"];
    homeDetail.movieBanner = movie;
    [self.navigationController pushViewController:homeDetail animated:YES];
}



#pragma mark - Parse data


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _listMovieByCate.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    HVMovieByCatgoryModel *row = [_listMovieByCate objectAtIndex:section];
    return row.Movies.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat margin = 10;
    CGFloat itemWidth = (collectionView.frame.size.width - margin * 2)/3;
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 1.6);
    
    return itemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Item" forIndexPath:indexPath];
    
    HVMovieByCatgoryModel *categoryModel = [_listMovieByCate objectAtIndex:indexPath.section];
    NSArray *arrAllMovie = categoryModel.Movies;
    HVMovieModel *movieModel = [arrAllMovie objectAtIndex:indexPath.item];
    
    NSString *stringName = [movieModel valueForKey:@"MovieName"];
    cell.nameMovieByCates.text = stringName;
    
    NSString *stringUrlImg = [movieModel valueForKey:@"Poster100x149"];
    [cell.imgMovieByCates setImageWithURL:[NSURL URLWithString:stringUrlImg] placeholderImage:cell.imgMovieByCates.image];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    HVCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    HVMovieByCatgoryModel *cateModel = [_listMovieByCate objectAtIndex:indexPath.section];
    
    header.lblTitleHeader.text = cateModel.CategoryName;
    
    return header;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HVMovieByCatgoryModel *cateModel = [_listMovieByCate objectAtIndex:indexPath.section];
    
    NSArray *arrModel = cateModel.Movies;
    
    HVMovieModel *movieModel = [arrModel objectAtIndex:indexPath.item];
    
    HVHomeDetail *homeDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetail"];
    homeDetail.movieByCate = movieModel;
    homeDetail.categoryModel = cateModel;
    [self.navigationController pushViewController:homeDetail animated:YES];

}

- (IBAction)btnMenu:(id)sender {
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    NSLog(@"this is menu");
}

- (IBAction)btnSearch:(id)sender {
    
    UINavigationController *navi = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"naviSearch"];
    
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

@end
