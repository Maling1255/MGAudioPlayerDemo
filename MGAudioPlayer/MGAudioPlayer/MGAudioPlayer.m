//
//  MGAudioPlayer.m
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGAudioPlayer.h"
#import "AVAudioPlayer+Extension.h"

@interface MGAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *previousPlayer;
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, copy) NSString *preAudioName;
@property (nonatomic, assign) NSInteger index;



@end
static MGAudioPlayer *_instance;
@implementation MGAudioPlayer

static NSMutableDictionary *_musicsDict;
+ (void)initialize {

    _musicsDict = [NSMutableDictionary dictionary];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

+ (instancetype)sharedManager
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


- (void)playAudios:(NSMutableArray *)array
{
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    
    [self playAudios:array configurate:configurate];
}

- (void)playAudios:(NSMutableArray *)array configurate:(MGAudioPlayerConfigurate *)configurate
{

    [self.musicArray removeAllObjects];
    [self.musicArray addObjectsFromArray:array];
    [self playAudio:_musicArray.firstObject config:configurate];
}

- (void)playAudio:(NSString *)musicName config:(MGAudioPlayerConfigurate *)config
{
    assert(musicName);
    _preAudioName = musicName;
    
    AVAudioPlayer *player = _musicsDict[_preAudioName];
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:@"mp3"];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = self;
        player.volume = 1;
        [player prepareToPlay];
        self.currentPlayer = player;
        _musicsDict[musicName] = player;
    }
    player.audioConfig = config;
    
    
    [player play];
    self.previousPlayer = player;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _index ++;
    
    if (_index < _musicArray.count)
    {
        [self playAudio:[NSString stringWithFormat:@"%@",_musicArray[_index]] config:player.audioConfig];
    }
    else
    {
//        [self.currentPlayer stop];
//        self.currentPlayer = nil;
        
        player.audioConfig.currentIndex += 1;
        _index = 0;
        [self finishPlaying:player.audioConfig];

    }
}

int i = 1;
- (void)finishPlaying:(MGAudioPlayerConfigurate *)config
{
    NSLog(@"播放完成   %d    %p    %ld", i++, config, config.currentIndex);
    
    if (config.currentIndex < config.numberOfLoops.integerValue) {
        [self playAudios:[[NSMutableArray alloc] initWithArray:self.musicArray copyItems:YES] configurate:config];
    } else {
        NSLog(@"真的结束了");
        
        [_musicArray removeAllObjects];
        [_musicsDict removeAllObjects];
    }
}

- (NSMutableArray *)musicArray
{
    if (!_musicArray) {
        _musicArray = [[NSMutableArray alloc] init];
    }
    return _musicArray;
}




@end
