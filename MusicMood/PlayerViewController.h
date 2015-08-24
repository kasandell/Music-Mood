//
//  PlayerViewController.h
//  MusicMood
//
//  Created by Kyle Sandell on 4/7/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
@property (nonatomic, retain) NSMutableArray *spotifyIDList;
-(NSMutableArray *)getSpotifyID;
@end
