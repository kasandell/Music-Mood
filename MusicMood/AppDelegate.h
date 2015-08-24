//
//  AppDelegate.h
//  MusicMood
//
//  Created by Kyle Sandell on 4/4/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Spotify/Spotify.h>
#import "PlayerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) SPTSession *session;

-(void)playUsingSession;
@end

