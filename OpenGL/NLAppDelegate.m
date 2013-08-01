//
//  NLAppDelegate.m
//  OpenGL
//
//  Created by Nick Lupinetti on 7/29/13.
//  Copyright (c) 2013 Nick Lupinetti. All rights reserved.
//

#import "NLAppDelegate.h"
#import "NLOpenGLViewController.h"

@implementation NLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NLOpenGLViewController *controller = [[NLOpenGLViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = controller;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
