//
//  EditProfileViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/26/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "EditProfileViewController.h"
#import "TextFieldCell.h"
#import "User.h"
#import "MasterObject.h"

#import "CSNotificationView.h"

@interface EditProfileViewController ()
{
    UITextField *usernameField;
    UITextField *passwordField;
    UITextField *nameField;
    UITextField *majorField;
    UITextField *favoriteMovieField;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit Profile";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:@"TextFieldCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save {
    if (usernameField.text.length > 0 || passwordField.text.length > 0 || nameField.text.length > 0 || majorField.text.length > 0 || favoriteMovieField.text.length > 0) {
        [User currentUser].username = usernameField.text;
        [User currentUser].password = passwordField.text;
        [User currentUser].name = nameField.text;
        [User currentUser].major = majorField.text;
        [User currentUser].favoriteMovie = favoriteMovieField.text;
        [MasterObject save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newLogIn" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Invalid input - unable to edit profile"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    
    if (indexPath.row == 0) {
        usernameField = cell.textField;
        [cell.textField setText:[User currentUser].username];
        [cell.titleLabel setText:@"Username"];
        [cell.textField setSecureTextEntry:NO];
    } else if (indexPath.row == 1) {
        passwordField = cell.textField;
        [cell.textField setText:[User currentUser].password];
        [cell.textField setSecureTextEntry:YES];
        [cell.titleLabel setText:@"Password"];
    } else if (indexPath.row == 2) {
        nameField = cell.textField;
        [cell.textField setText:[User currentUser].name];
        [cell.titleLabel setText:@"Name"];
        [cell.textField setSecureTextEntry:NO];
    } else if (indexPath.row == 3) {
        majorField = cell.textField;
        [cell.textField setText:[User currentUser].major];
        [cell.titleLabel setText:@"Major"];
        [cell.textField setSecureTextEntry:NO];
    } else {
        favoriteMovieField = cell.textField;
        [cell.textField setText:[User currentUser].favoriteMovie];
        [cell.titleLabel setText:@"Favorite Movie"];
        [cell.textField setSecureTextEntry:NO];
    }
    
    NSAttributedString *fm = [[NSAttributedString alloc] initWithString:cell.titleLabel.text.lowercaseString attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    cell.textField.attributedPlaceholder = fm;
    
    return cell;
}

@end
