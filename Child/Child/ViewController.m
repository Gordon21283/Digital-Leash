//
//  ViewController.m
//  Child
//
//  Created by Gordon Kung on 4/12/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic)CLLocationManager *locationManager;

@end

@implementation ViewController
// Method for error alert "No internet connection pop-up"

-(void)noInternetAlert:(NSError*)error {
    
    if(error.code == -1009) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"message:@"Can't connect. Please check your internet Connection"preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Instantiate the CLLocationManager object

    self.locationManager = [[CLLocationManager alloc]init];

    self.locationManager.delegate = self;
    
    // Setting Accuracy
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    // Requesting Location update
    
    [self.locationManager startUpdatingLocation];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    self.latitude = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
  //  NSLog(@"Location updated..... %@ , %@", self.latitude, self.longitude);

}

- (IBAction)reportLocation:(id)sender {
    
    // Create urlstring with userID from UItextfield
    
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.userID.text];
    
    //  Create url with a string
    NSURL *url = [NSURL URLWithString: urlString];
    
    //  Create the NSURL configuration
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Create an NSMutableURLRequest so that you can specifically set the request to be a POST.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"PATCH";
    
    // Create a JSON representation of the dictionary you will post to the web service.
    
    NSDictionary *childDict =
    @{@"username":self.userID.text,@"current_latitude":self.latitude,@"current_longitude":self.longitude};
    NSLog(@"Child location updated..... %@ , %@", self.latitude, self.longitude);
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:childDict options:0 error:&error];
    
    // Create the NSURLSessionUpload Task using the JSON Data
    // This will make a HTTP PATCH with the body set as JSON Data
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response here
        
        if (error == nil)
            NSLog(@"Updated successfully");
        else
            
        // Method for error alert
            
            [self noInternetAlert:error];
            NSLog(@"error");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationReportedVC"] animated:YES completion:nil];

        });
        
    }];
    // This fires request
    [uploadTask resume];
    
}
@end
