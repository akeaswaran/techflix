//
//  IntroViewController.m
//  techflix
//
//  Created by Akshay Easwaran on 4/26/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "IntroViewController.h"
#import "User.h"
#import "SignUpViewController.h"

#import "CSNotificationView.h"

@interface IntroViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}
@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    usernameField.attributedPlaceholder = str;
    
    NSAttributedString *pss = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor lightTextColor] }];
    passwordField.attributedPlaceholder = pss;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:passwordField]) {
        [textField resignFirstResponder];
        [self logIn:nil];
    } else {
        [textField resignFirstResponder];
        [passwordField becomeFirstResponder];
    }
    return YES;
}

- (IBAction)logIn:(id)sender {
    BOOL success = [User logIn:usernameField.text password:passwordField.text];
    if (success) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newLogIn" object:nil];
        [CSNotificationView showInViewController:self.presentingViewController style:CSNotificationViewStyleSuccess message:@"Logged in successfully!"];
    } else {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Username and/or password incorrect - unable to log in"];
    }
}

-(IBAction)signUp:(id)sender {
    //push sign up
    [self.navigationController pushViewController:[[SignUpViewController alloc] init] animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
