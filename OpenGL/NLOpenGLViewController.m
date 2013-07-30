//
//  NLOpenGLViewController.m
//  OpenGL
//
//  Created by Nick Lupinetti on 7/29/13.
//  Copyright (c) 2013 Nick Lupinetti. All rights reserved.
//

#import "NLOpenGLViewController.h"
#import "NLOpenGLView.h"

@interface NLOpenGLViewController ()

@end

@implementation NLOpenGLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    _glView = [[NLOpenGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.glView;
}

@end
