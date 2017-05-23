//
//  HVSearchVC.m
//  HDVideo
//
//  Created by Vu Van Tien on 5/18/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVSearchVC.h"
#import "HVMovieModel.h"
#import "HVHomeDetail.h"
@interface HVSearchVC () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation HVSearchVC
{
    NSMutableArray *_listMovieSearch;
    NSMutableArray *_listNameEnglishMovieSearch;
    NSMutableArray *_lisNameVNMovieSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_myTableView resignFirstResponder];
    if ([_searchBar.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"you must enter keywords" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:btnOk];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self getDataSearchFromServer];
    }
}

- (void) getDataSearchFromServer{
    [self.util showLoadingInView:self.view];
    
    [self.networkManager getMovieSearchWithKey:_searchBar.text completion:^(HVResponseObject *responseObject) {
        [self.util dismissLoadingInView:self.view];
        
        if (!responseObject.responseCode.boolValue) {
            _listMovieSearch = [NSMutableArray array];
            _listNameEnglishMovieSearch = [NSMutableArray array];
            _lisNameVNMovieSearch = [NSMutableArray array];
            NSArray *arrResponseObject = (NSArray *)responseObject.responseData;
            NSArray *arrelementResponse = arrResponseObject[0];
            NSArray *arrMovieModel = [arrelementResponse valueForKey:@"Data"];
            
            for (NSDictionary *dicModel in arrMovieModel) {
                HVMovieModel *movieModel = [[HVMovieModel alloc] initWithDictionary:dicModel error:nil];
                
                [_listMovieSearch addObject:movieModel];
                [_listNameEnglishMovieSearch addObject:movieModel.MovieName];
                [_lisNameVNMovieSearch addObject:movieModel.KnownAs];
            }
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"sorry" message:@"Please check the network" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *btnOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:btnOk];
            [self presentViewController:alert animated:YES completion:nil];

        }
        [_myTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listNameEnglishMovieSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSearch" forIndexPath:indexPath];
    
    cell.textLabel.text = _listNameEnglishMovieSearch[indexPath.row];
    cell.detailTextLabel.text = _lisNameVNMovieSearch[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HVHomeDetail *homeDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeDetail"];
    homeDetail.movieBySearch = _listMovieSearch[indexPath.row];
    self.definesPresentationContext = YES;
    [self.navigationController pushViewController:homeDetail animated:YES];
}

- (IBAction)backMainHome:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
