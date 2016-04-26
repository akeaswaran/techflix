//
//  SignUpViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/26/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"

#import "CSNotificationView.h"

@interface SignUpViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *majorField;
    IBOutlet UITextField *favoriteMovieField;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    usernameField.attributedPlaceholder = str;
    
    NSAttributedString *pss = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    passwordField.attributedPlaceholder = pss;
    
    NSAttributedString *nm = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    nameField.attributedPlaceholder = nm;
    
    NSAttributedString *mj = [[NSAttributedString alloc] initWithString:@"Major" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    majorField.attributedPlaceholder = mj;
    
    NSAttributedString *fm = [[NSAttributedString alloc] initWithString:@"Favorite Movie" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    favoriteMovieField.attributedPlaceholder = fm;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:passwordField]) {
        [textField resignFirstResponder];
        [self signUp:nil];
    } else {
        [textField resignFirstResponder];
        [passwordField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)signUp:(id)sender {
    BOOL success = [User signUpUserWithName:nameField.text username:usernameField.text password:passwordField.text major:majorField.text faveMovie:favoriteMovieField.text];
    if (success) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newLogIn" object:nil];
        [CSNotificationView showInViewController:self.presentingViewController style:CSNotificationViewStyleSuccess message:@"Signed up successfully!"];
    } else {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Invalid input - unable to sign up"];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
