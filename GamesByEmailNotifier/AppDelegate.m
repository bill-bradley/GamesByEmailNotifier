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

- (IBAction)checkForTurnsClicked:(id)sender
{
    [self checkForTurns];
}

- (void)checkForTurns
{
    // need to store these
    NSString *username = @"";
    NSString *password = @"";
    
    // get json response for user
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webservices.gamesbyemail.com/JavaScript/MyTurns?UserId=%@&Password=%@",username,password]]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    NSString *string = [[NSString alloc] initWithData:content
                                             encoding:NSUTF8StringEncoding];
    
    // Data returned has non-string keys, match and replace all keys with double quotes
    NSError *regexError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=[{,])(.*?)(?=:)" options:NSRegularExpressionCaseInsensitive error:&regexError];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"\"$0\""];

    // convert back to content for jsonParsing
    content = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:content
                                                                options:0 error:&jsonParsingError];
    
    if( jsonParsingError == nil)
    {
        // search for Turns
        NSArray *turns = [jsonResponse objectForKey:@"turns"];
        
        if( [turns count] > 0 ) // Has turn
        {
            self.statusBar.image = [NSImage imageNamed:@"NoTurns.ico"];
        }
        else // No turn
        {
            self.statusBar.image = [NSImage imageNamed:@"SleepNoTurns.ico"];
        }
    } else {
        NSLog(@"Error: %@", error);
    }
}

// handler from menu item
- (IBAction)viewMyGames:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gamesbyemail.com/User/MyGames"]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // check on load
    [self checkForTurns];
    
    // check once every 60 seconds
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(runCheckForTurns) userInfo:nil repeats:YES];
}

@end

