//
//  HVViewControllerMenu.m
//  HDVideo
//
//  Created by Vu Van Tien on 5/16/2560 BE.
//  Copyright © 2560 BE MyStudio. All rights reserved.
//

#import "HVViewControllerMenu.h"
#import "HVMovieCategoryMenu.h"
#import "HVViewDetailMenu.h"
#import "AppDelegate.h"
@interface HVViewControllerMenu () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation HVViewControllerMenu
{
    NSMutableArray *_arrListObjectCates;
    NSMutableArray *_arrListNameCates;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) getDataFromServer{
    [self.util showLoadingInView:self.view];
    
    [self.networkManager getAllCategoryCompletion:^(HVResponseObject *responseObject) {
        [self.util dismissLoadingInView:self.view];
        
        if (!responseObject.responseCode.boolValue) {
            _arrListObjectCates = [NSMutableArray array];
            _arrListNameCates = [NSMutableArray array];

            NSArray *arrCates = (NSArray *)responseObject.responseData;
            
            for (NSDictionary *dicModel in arrCates) {
                HVMovieCategoryMenu *catesMenu = [[HVMovieCategoryMenu alloc] initWithDictionary:dicModel error:nil];
                [_arrListObjectCates addObject:catesMenu];
                [_arrListNameCates addObject:catesMenu.CategoryName];
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
    return _arrListObjectCates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _arrListNameCates[indexPath.row];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HVMovieCategoryMenu *categoryMenu = [_arrListObjectCates objectAtIndex:indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app gotoCategoryDetailForCategory:categoryMenu.CategoryID];
    
}

@end
