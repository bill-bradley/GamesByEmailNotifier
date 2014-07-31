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
    self.statusBar.image = [NSImage imageNamed:@"pawn_19_19.png"];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
}

- (IBAction)checkForTurns:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:@"Checking for turns."];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK clicked, delete the record
    }
}

- (IBAction)viewMyGames:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.gamesbyemail.com/User/MyGames"]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

@end
