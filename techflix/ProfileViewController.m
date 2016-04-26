//
//  ProfileViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 1/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "EditProfileViewController.h"

#import "HexColors.h"

@interface TFProfileHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@end

@implementation TFProfileHeaderView
@end

@interface ProfileViewController ()
{
    IBOutlet TFProfileHeaderView *headerView;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor hx_colorWithHexString:@"#090909"]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    headerView.majorLabel.text = [NSString stringWithFormat:@"Major: %@", [User currentUser].major];
    headerView.nameLabel.text = [User currentUser].name;
    headerView.usernameLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].username];
    headerView.movieLabel.text = [NSString stringWithFormat:@"Favorite Movie: %@", [User currentUser].favoriteMovie];
    [self.tableView setTableHeaderView:headerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserData) name:@"newLogIn" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)refreshUserData {
    NSLog(@"REFRESH");
    headerView.majorLabel.text = [NSString stringWithFormat:@"Major: %@", [User currentUser].major];
    headerView.nameLabel.text = [User currentUser].name;
    headerView.usernameLabel.text = [NSString stringWithFormat:@"@%@", [User currentUser].username];
    headerView.movieLabel.text = [NSString stringWithFormat:@"Favorite Movie: %@", [User currentUser].favoriteMovie];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
            cell.selectedBackgroundView = bgView;
            cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell.textLabel setText:@"Edit Profile"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LowerCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LowerCell"];
            UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
            [bgView setBackgroundColor:[UIColor hx_colorWithHexString:@"#1A1A1A"]];
            cell.selectedBackgroundView = bgView;
            cell.backgroundColor = [UIColor hx_colorWithHexString:@"#090909"];
            [cell.textLabel setTextColor:[UIColor redColor]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
        [cell.textLabel setText:@"Log Out"];
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?" message:@"This will take you back to the Sign In screen." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [User logOut];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //push edit profile
        [self.navigationController pushViewController:[[EditProfileViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    }
}

@end
