//
//  ViewController.m
//  Parent
//
//  Created by Gordon Kung on 4/11/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//
// Create User Button: (HTTP POST Request)
// - Takes data from the fields
// - Put them in a dictionary
// - Convert dictionary to JSON
// - Sends that data to the server
// - Server will then record the data
//
// Create Check Status Button: (HTTP GET Request)
// - It ask the server to get all the information about the child in the zone
// - then parent will do calculation to find out if the the child is in the zone/ not in the zone base on the location
//
// Create Update Button: (Patch Request)
// - Ability to update zone base on new location & radius
// - Sends a 'patch' request with the new zone data

#import "ViewController.h"
#include <math.h>

@interface ViewController ()

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (nonatomic) double parentLongitude;
@property (nonatomic) double parentLatitude;
@property (nonatomic) double childLongitude;
@property (nonatomic) double childLatitude;

@end

@implementation ViewController

-(BOOL)inZoneWithChildLatitude:(double)childLatitude andChildLongitude:(double)childLongitude andParentLatitude: (double) parentLatitude andParentLongitude: (double) parentLongitude {
    
    // degrees to radians
    
    double lat1rad = childLatitude * M_PI/180;
    double lon1rad = childLongitude * M_PI/180;
    double lat2rad = parentLatitude * M_PI/180;
    double lon2rad = parentLongitude * M_PI/180;
    
    // deltas
    
    double dLat = lat2rad - lat1rad;
    double dLon = lon2rad - lon1rad;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad);
    double c = 2 * asin(sqrt(a));
    double R = 6372.8;
    
    NSLog(@"distance: %f", R * c);
    
    //if user is in zone then return yes
    
    if ([self.radius.text floatValue] >= R *c) {
        
        NSLog(@"Child is in Zone");
        
        return YES;
    }
    
    NSLog(@"Child is not in the Zone");
    
    return NO;
    
    
}

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
    
    // We set the delegate of locationManager to self
    // Which means that every location related events will be sent to ViewController
    
    self.locationManager.delegate = self;
    
    // Setting Accuracy
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    // Requesting Location update
    
    [self.locationManager startUpdatingLocation];
    
}
#pragma mark - CLLocationManagement Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    _myLatitude.text = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
    _myLongitude.text = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createUser:(id)sender {
    
    // Create urlstring with userID from UItextfield
    
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.userID.text];
    
    //  Create url with a string
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    //  Create the NSURL configuration
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Create an NSMutableURLRequest so that you can specifically set the request to be a POST.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    // Create a JSON representation of the dictionary you will post to the web service.
    
    NSDictionary *userDetails = @{@"username":self.userID.text,@"latitude":self.myLatitude.text,@"longitude":self.myLongitude.text,@"radius":self.radius.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
    
    // Create the NSURLSessionUpload Task using the JSON Data
    // This will make a HTTP POST with the body set as JSON Data
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response here
        
        if (error == nil){
            NSLog(@"User created successfully");
        }
        else{
        
            // Method for error alert
            
            [self noInternetAlert:error];
            NSLog(@"error");
        }
        
    }];
    
    // This fires request
    
    [uploadTask resume];
}

- (IBAction)checkStatus:(id)sender {
    
    // Specify a URL that can return JSON
    
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.userID.text];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Create an NSURLSessionDataTask using the NSURLSession shared session
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(error) {
            
            // method for error alert
            
            [self noInternetAlert:error];
            
            NSLog(@"%@",error.userInfo);
        }
        else {
            NSDictionary *myDictionaryJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSLog(@"%@", myDictionaryJSON);
            
            // Extracting longitude and latitude for parent and child from JSON Dictionary recieved after making request to the server
            
            self.childLatitude = [[myDictionaryJSON valueForKey:@"current_latitude"] doubleValue];
            self.childLongitude = [[myDictionaryJSON valueForKey:@"current_longitude"]doubleValue];
            self.parentLatitude = [[myDictionaryJSON valueForKey:@"latitude"]doubleValue];
            self.parentLongitude = [[myDictionaryJSON valueForKey:@"longitude"]doubleValue];
            
            // Check if child is inZone
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //Code that presents or dismisses a view controller here
                
                if ([self inZoneWithChildLatitude:self.childLatitude andChildLongitude:self.childLongitude andParentLatitude:self.parentLatitude andParentLongitude: self.parentLongitude] == YES) {
                    
                    // If child in zone present 'keep drink viewController'
                    
                    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"keepDrinkingVC"] animated:YES completion:nil];
                } else {
                    
                    // if child is not in the zone present 'child is not in the zone viewController'
                    
                    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"notInZoneVC"] animated:YES completion:nil];
                };
            });
        }
        
        NSLog(@"Check Status Complete");
    }];
    
    // This fires the task
    
    [downloadTask resume];
    
}

- (IBAction)updateZone:(id)sender {
    
    // Create urlstring with userID from UItextfield
    
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.userID.text];
    
    //  Create url with a string
    NSURL *url = [NSURL URLWithString: urlString];
    
    //  Create the NSURL configuration
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Create an NSMutableURLRequest so that you can specifically set the request to be a PATCH.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"PATCH";
    
    // Create a JSON representation of the dictionary you will post to the web service.
    
    NSDictionary *userDetails =
    @{@"username":self.userID.text,@"latitude":self.myLatitude.text,@"longitude":self.myLongitude.text,@"radius":self.radius.text};
    
    NSLog(@"Parent location updated..... %@ , %@", self.myLatitude.text, self.myLongitude.text);
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
    
    // Create the NSURLSessionUpload Task using the JSON Data
    // This will make a HTTP PATCH with the body set as JSON Data
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        // Handle response here
        if (error == nil){
            NSLog(@"Updated successfully");
        }
        else{
            [self noInternetAlert:error];
            NSLog(@"error");
        }
        
    }];
    // This fires request
    [uploadTask resume];
    
}
@end
