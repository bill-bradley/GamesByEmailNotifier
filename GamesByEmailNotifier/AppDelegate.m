//
//  AppDelegate.m
//  GamesByEmailNotifier
//
//  Created by Bill Bradley on 7/31/14.
//  Copyright (c) 2014 BillBradley. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // self.statusBar.title = @"GamesByEmail Turn Notifier";
    self.statusBar.image = [NSImage imageNamed:@"SleepNoTurns.ico"];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
}

- (IBAction)checkForTurns:(id)sender {}

- (void)runCheckForTurns
{
    NSString *username = @"";
    NSString *password = @"";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setHTTPMethod:@"GET"];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webservices.gamesbyemail.com/JavaScript/MyTurns?UserId=%@&Password=%@",username,password]]];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *string = [[NSString alloc] initWithData:content
                                             encoding:NSUTF8StringEncoding];
    
    string = [string stringByReplacingOccurrencesOfString:@"turns" withString:@"\"turns\""];
    string = [string stringByReplacingOccurrencesOfString:@"playAllUrl" withString:@"\"playAllUrl\""];
    string = [string stringByReplacingOccurrencesOfString:@"status" withString:@"\"status\""];
    string = [string stringByReplacingOccurrencesOfString:@"interval" withString:@"\"interval\""];
    string = [string stringByReplacingOccurrencesOfString:@"message" withString:@"\"message\""];
    string = [string stringByReplacingOccurrencesOfString:@"upgradePage" withString:@"\"upgradePage\""];
    
    content = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:content
                                                                options:0 error:&jsonParsingError];
    
    if( jsonParsingError == nil)
    {
        NSArray *turns = [jsonResponse objectForKey:@"turns"];
        
        NSLog(@"Turns: %lu", (unsigned long)[turns count]);
        
        if( [turns count] > 0 )
        {
            self.statusBar.image = [NSImage imageNamed:@"NoTurns.ico"];
        }
        else
        {
            self.statusBar.image = [NSImage imageNamed:@"SleepNoTurns.ico"];
        }
    }
}
- (IBAction)viewMyGames:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gamesbyemail.com/User/MyGames"]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self runCheckForTurns];
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(runCheckForTurns) userInfo:nil repeats:YES];
}

@end
