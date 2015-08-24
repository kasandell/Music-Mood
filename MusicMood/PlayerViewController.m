//
//  PlayerViewController.m
//  MusicMood
//
//  Created by Kyle Sandell on 4/7/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#import "PlayerViewController.h"
#import <Spotify/Spotify.h>
#import <Spotify/SPTTrack.h>
#import "AppDelegate.h"
@interface PlayerViewController ()
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) NSArray *moods;
@property (nonatomic, retain) NSString *currentMood;
@property (nonatomic, retain) NSString *moodToShiftTo;
@property (nonatomic, retain) NSArray *subArrayMoods;
@property (nonatomic, retain) NSArray *listOfSongResponses;
@property (nonatomic, readwrite) SPTAudioStreamingController *trackPlayer;
@property (nonatomic, retain) SPTSession *session;

//@property (nonatomic, retain) NSMutableArray *spotifyIDList;
@end

@implementation PlayerViewController

NSString *apiKey=@"ZHQKZJR1FWXP2R9YH";
NSString *baseURL=@"http://developer.echonest.com/api/v4/song/search?api_key=";
static NSString * const kClientId = @"bc1b21101f1d46858c554e108518d5e6";
static NSString * const kCallbackURL = @"music-mood-login://callback";
static NSString * const kTokenSwapURL = @"http://localhost:1234/swap";



-(NSMutableArray *)getSpotifyID
{
    return self.spotifyIDList;
}

NSString *preferredGenre;
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.session=
    self.trackPlayer=[[SPTAudioStreamingController alloc] initWithClientId:kClientId];
    self.defaults =[NSUserDefaults standardUserDefaults];
    self.moods=[NSArray arrayWithArray:[self.defaults objectForKey:@"Moods"]];
    self.currentMood=[self.defaults objectForKey:@"Im Feeling"];
    self.moodToShiftTo=[self.defaults objectForKey:@"I Want To Feel"];
    NSUInteger indexOfCurrentMood=[self.moods indexOfObject:self.currentMood];
    NSUInteger indexOfIWantToFeel=[self.moods indexOfObject:self.moodToShiftTo];
    if (indexOfCurrentMood>indexOfIWantToFeel) {
        self.subArrayMoods=[self.moods subarrayWithRange:NSMakeRange(indexOfIWantToFeel, indexOfCurrentMood-indexOfIWantToFeel)];
        self.subArrayMoods=[[self.subArrayMoods reverseObjectEnumerator] allObjects];
    }
    else{
        self.subArrayMoods=[self.moods subarrayWithRange:NSMakeRange(indexOfIWantToFeel, indexOfCurrentMood-indexOfIWantToFeel)];
    }
    NSMutableArray *listOfURLs=[[NSMutableArray alloc] init];
    preferredGenre=[self.defaults objectForKey:@"Genre"];
   
    for (NSMutableString *str in self.subArrayMoods) {
       
        NSMutableString *TempURL=[[NSMutableString alloc] initWithString:@""];
        [TempURL appendString:baseURL];
        
        [TempURL appendString:apiKey];
        [TempURL appendString:@"&format=json"];
        [TempURL appendString:@"&style="];
        [TempURL appendString:preferredGenre];
        [TempURL appendString:@"&mood="];
        [TempURL appendString:[str lowercaseString]];
        [TempURL appendString:@"&results=7"];
        [TempURL appendString:@"&bucket=id:spotify"];
        
          [listOfURLs addObject:TempURL];
        
    }
    NSMutableArray *listOfReturnData=[[NSMutableArray alloc] init];
    for(NSString *str in listOfURLs)
    {
        
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:10
         ];
        NSError *requestError;
        NSURLResponse *urlResponse = [[NSURLResponse alloc] init];
        [request setHTTPMethod:@"GET"];
        
        NSData *responseDataJSON = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if(requestError)
        {
            NSLog(@"Houston we have a problem");
        }
        
        //    NSString *response = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        //
        //    NSLog(@"%@", response);
        
        NSError *error;
        NSMutableDictionary *responseData = [NSJSONSerialization
                                             JSONObjectWithData:responseDataJSON
                                             options:NSJSONReadingMutableContainers
                                             error:&error];
        [listOfReturnData addObject:responseData];
    }
    self.spotifyIDList=[[NSMutableArray alloc] init];
    for(NSMutableDictionary *dict in listOfReturnData)
    {
        for(int i=0; i<[dict[@"response"][@"songs"] count]; i++)
        {
            if(dict[@"response"][@"songs"][i][@"artist_foreign_ids"][0][@"foreign_id"]){
                [self.spotifyIDList addObject:[NSURL URLWithString:dict[@"response"][@"songs"][i][@"artist_foreign_ids"][0][@"foreign_id"]]];
                //NSLog(@"%@", dict[@"response"][@"songs"][i][@"artist_foreign_ids"][0][@"foreign_id"]);
            }
        }
    }
     AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.session=appdelegate.session;
    [self playUsingSession:self.session];
    //[self application];

}


-(void)playUsingSession:(SPTSession *)session {
    
    // Create a new player if needed
    if (self.trackPlayer == nil) {
        self.trackPlayer = [[SPTAudioStreamingController alloc] initWithClientId:kClientId];
    }
    
    [self.trackPlayer loginWithSession:session callback:^(NSError *error) {
        if(error!=nil)
        {
            NSLog(@"Houston we have a problem");
            NSLog(@"%@", error);
            return;
        }
    }];
   // [self.trac]
   /*
    for(NSURL *url in self.spotifyIDList)
    {
        [self.trackPlayer queueURI:url callback:^(NSError *error) {
            if(error)
            {
                NSLog(@"%@", error);
                return;
            }
        }];
    }
    */
    [self.trackPlayer queueURIs:self.spotifyIDList clearQueue:YES callback:^(NSError *error) {
        if(error)
        {
            NSLog(@"%@", error);
            return;
        }
    }];
    [self.trackPlayer queuePlay:^(NSError *error) {
        if(error)
        {
            NSLog(@"%@", error);
            return;
        }
    }];
       //[self.trackPlayer playT]
    //[self.trackPlayer ]
  /*  [self.trackPlayer playURIs:self.spotifyIDList fromIndex:0 callback:^(NSError *error){
        if(error)
        {
            NSLog(@"%@", error);
        }
        
        NSLog(@"LOL FUCK YOU SPOTIFY");
        
    }];*/

    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
