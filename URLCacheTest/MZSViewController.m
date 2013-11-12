//
//  MZSViewController.m
//  URLCacheTest
//
//  Created by Matt Sanford on 2013-11-12.
//  Copyright (c) 2013 MZSanford, LLC. All rights reserved.
//

#import "MZSViewController.h"
#import <mach/mach_time.h>

@interface MZSViewController ()

@property (nonatomic, weak) IBOutlet UILabel *currentSizeLabel;
@property (nonatomic, weak) IBOutlet UIButton *makeRequestButton;
@property (nonatomic, weak) IBOutlet UITextField *acceptHeader;
@property (nonatomic, weak) IBOutlet UISwitch *clearCacheSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *varyUrlSwitch;

@end

@implementation MZSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self updateCacheSize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCacheSize
{
    NSUInteger memUsage = [[NSURLCache sharedURLCache] currentMemoryUsage];
    NSUInteger diskUsage = [[NSURLCache sharedURLCache] currentDiskUsage];

    NSString *values = [NSString stringWithFormat:@"MEM:%0.2f DISK:%0.2f", memUsage/1024.0, diskUsage/1024.0];
    self.currentSizeLabel.text = [@"Current Size: \n\t" stringByAppendingString:values];
}

- (IBAction)tappedMakeRequest:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://abs.twimg.com/errors/twitter_web_sprite_icons.png"];
    NSString *acceptHeaderValue = self.acceptHeader.text;
    if (self.clearCacheSwitch.on) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }

    if (self.varyUrlSwitch.on) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?accept=%@",
                                    [url absoluteString],
                                    [acceptHeaderValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    }


    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLCacheStorageAllowed
                                                          timeoutInterval:2.0];

    NSLog(@"Requesting URL: %@", [url absoluteString]);
    if (acceptHeaderValue && ![acceptHeaderValue isEqualToString:@""]) {
        [urlRequest setValue:acceptHeaderValue forHTTPHeaderField:@"Accept"];
        NSLog(@"Sending accept header value: %@", acceptHeaderValue);
    }

    NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:urlRequest];
    BOOL servedFromCache = (cachedResponse != nil);

    NSURLResponse *response = nil;
    NSError *error = nil;

    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        // Some bad stuff is going down here.
        abort();
    }

    uint64_t start = mach_absolute_time();
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    uint64_t end = mach_absolute_time();
    uint64_t elapsed = end - start;

    uint64_t nanos = elapsed * info.numer / info.denom;
    CGFloat timeInSecs = (CGFloat)nanos / NSEC_PER_SEC;

    NSLog(@"%@: %@ response code with %lu bytes of data: %f sec", (servedFromCache ? @"CACHED" : @"Fresh"),
          (error == nil ? @"Non-error" : @"Error"),
          [data length],
          timeInSecs);
    
    [self updateCacheSize];
}

@end
