//
//  AppDelegate.h
//  GamesByEmailNotifier
//
//  Created by Bill Bradley on 7/31/14.
//  Copyright (c) 2014 BillBradley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;

-(void)runCheckForTurns;

@end
