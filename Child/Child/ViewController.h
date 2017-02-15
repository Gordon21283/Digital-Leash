//
//  ViewController.h
//  Child
//
//  Created by Gordon Kung on 4/12/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
- (IBAction)reportLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userID;
-(void)noInternetAlert:(NSError*)error;




@end

