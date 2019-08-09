//
//  MGAudioPlayer.m
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGAudioPlayer.h"
#import "AVAudioPlayer+Extension.h"
#import "MGAudioElement.h"


#define MGAUDIO_FADE_STEPS 30.0f
@interface MGAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *previousPlayer;
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, copy) NSString *preAudioName;
@property (nonatomic, assign) NSInteger index;

//监控进度
@property (nonatomic, strong) NSTimer *avTimer;

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

- (void)playAudio:(MGAudioElement *)audio config:(MGAudioPlayerConfigurate *)config
{
    assert(audio.musicName);
    _preAudioName = audio.musicName;
    
    MGAudioElement *currentElement = _musicsDict[_preAudioName];
//    AVAudioPlayer *player = _musicsDict[_preAudioName];
    AVAudioPlayer *player = currentElement.audioPlayer;
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:audio.musicName withExtension:@"mp3"];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        player.delegate = self;
        [player prepareToPlay];
        self.currentPlayer = player;
        
        audio.audioPlayer = player;
        _musicsDict[audio.musicName] = audio;
    }
    player.audioConfig = config;

    
    player.volume = 0;
    NSTimeInterval interval = audio.fadeInInterval.floatValue / MGAUDIO_FADE_STEPS;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(fadeIn:)
                                   userInfo:player
                                    repeats:YES];
    [player play];
    
    // 监听播放进度
    self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timer:) userInfo:audio repeats:YES];
    self.previousPlayer = player;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _index ++;
    
    // 每次进来释放上一个监听播放进度的定时器
    if (self.avTimer) {
        [self.avTimer invalidate];
        self.avTimer = nil;
    }
    
    if (_index < _musicArray.count)
    {
        MGAudioElement *element = _musicArray[_index];
        [self playAudio:element config:player.audioConfig];
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
        NSLog(@"**************************真的结束了**************************");
        
        [_musicArray removeAllObjects];
        [_musicsDict removeAllObjects];
    }
}

- (void)timer:(NSTimer *)timer
{
    MGAudioElement *element = timer.userInfo;
    
    CGFloat currentDuration = element.audioPlayer.currentTime;
    CGFloat totalDuration = [self audioElementDurationWithMusicName:element.musicName];
    
    NSLog(@"%f    %f", element.audioPlayer.currentTime, totalDuration);
    
    AVAudioPlayer *currentAudioPlayer = element.audioPlayer;
    if (element.audioPlayer.currentTime >= totalDuration - element.fadeOutInterval.floatValue) {
        
        float volume = currentAudioPlayer.volume;
        volume = volume - 1.0 / MGAUDIO_FADE_STEPS;
        volume = volume < 0.1 ? 0.1 : volume;
        currentAudioPlayer.volume = volume;
    }
    
}

- (CGFloat)audioElementDurationWithMusicName:(NSString *)musicName
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    NSURL *audioFileURL = [NSURL fileURLWithPath:path1];
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    float totalDuration = CMTimeGetSeconds(audioDuration);
    return totalDuration;
}




#pragma mark -
#pragma mark - fade
- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume + 1.0 / MGAUDIO_FADE_STEPS;
    volume = volume > 1.0 ? 1.0 : volume;
    player.volume = volume;
    
    NSLog(@"volume: %f", volume);
    
    
    if (volume >= 1.0) {
        [timer invalidate];
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
