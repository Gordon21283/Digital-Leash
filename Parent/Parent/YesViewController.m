//
//  YesViewController.m
//  Parent
//
//  Created by Gordon Kung on 4/14/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "YesViewController.h"

@interface YesViewController ()
- (IBAction)wooHoo:(id)sender;

@end

@implementation YesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wooHoo:(id)sender {
    
    // Dismiss the ViewController
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
