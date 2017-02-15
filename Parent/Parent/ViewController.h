//
//  ViewController.h
//  Parent
//
//  Created by Gordon Kung on 4/11/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *myLongitude;
@property (weak, nonatomic) IBOutlet UILabel *myLatitude;

@property (weak, nonatomic) IBOutlet UITextField *userID;

@property (weak, nonatomic) IBOutlet UITextField *radius;

- (IBAction)createUser:(id)sender;
- (IBAction)checkStatus:(id)sender;
- (IBAction)updateZone:(id)sender;

-(BOOL)inZoneWithChildLatitude:(double)childLatitude andChildLongitude:(double)childLongitude andParentLatitude: (double) parentLatitude andParentLongitude: (double) parentLongitude;

-(void)noInternetAlert:(NSError*)error;

    

@end
