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


#define MGAUDIO_FADE_STEPS 20.0f
@interface MGAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *previousPlayer;
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, copy) NSString *preAudioName;
@property (nonatomic, assign) NSInteger index;


// 监控进度
@property (nonatomic, strong) NSTimer *avTimer;
@property (nonatomic, assign) CGFloat currentPlayTime;


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

    NSLog(@"origin  %p", configurate);
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
        audio.audioPlayer.audioConfig = config;
        _musicsDict[audio.musicName] = audio;
        
    }
    player.audioConfig = config;

    player.volume = 0;
    
    // 淡入过程
    NSTimeInterval interval = audio.fadeInInterval.floatValue / MGAUDIO_FADE_STEPS;
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(fadeInTimer:) userInfo:player repeats:YES];
    [player play];
    
    // 实际的单个音频播放进度，监听播放进度 (控制淡出过程)
    self.avTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fadeOutTimer:) userInfo:audio repeats:YES];
    self.previousPlayer = player;
    
    // 每个音频要求播放时长倒计时
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countdowntTimer:) userInfo:audio repeats:YES];
}

- (void)countdowntTimer:(NSTimer *)timer
{
    MGAudioElement *audio = timer.userInfo;
    CGFloat aimDuration = audio.voiceDuration.floatValue;
    
    if (self.currentPlayTime == 0) {
        self.currentPlayTime = aimDuration;
    }
    else if (self.currentPlayTime > 0) {
        self.currentPlayTime-=0.05;
    } else {
        
        _index ++;
        if (_index < _musicArray.count)
        {
            MGAudioElement *element = _musicArray[_index];
            [self playAudio:element config:audio.audioPlayer.audioConfig];
            NSLog(@"播放下一个 %@   %@    %p %p", element.musicName, audio.musicName, element.audioPlayer, audio.audioPlayer);
            
        }
        else
        {
            audio.audioPlayer.audioConfig.currentIndex += 1;
            _index = 0;
            [self finishPlaying:audio.audioPlayer.audioConfig];
        }
        
        
        
        
        
        self.currentPlayTime = 0;
        [timer invalidate];
        timer = nil;
    }
    
//    NSLog(@"::::::  %f", self.currentPlayTime);
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    // 每次进来释放上一个监听播放进度的定时器
    if (self.avTimer) {
        [self.avTimer invalidate];
        self.avTimer = nil;
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

- (void)fadeOutTimer:(NSTimer *)timer
{
    MGAudioElement *element = timer.userInfo;
    [self fadeOut:element];
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
- (void)fadeInTimer:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume + 1.0 / MGAUDIO_FADE_STEPS;
    volume = volume > 1.0 ? 1.0 : volume;
    player.volume = volume;
    
//    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %f", volume);
    if (volume >= 1.0) {
        [timer invalidate];
    }
}

- (void)fadeOut:(MGAudioElement *)element
{
    CGFloat currentDuration = element.audioPlayer.currentTime;
    CGFloat totalDuration = [self audioElementDurationWithMusicName:element.musicName];
    
    //    NSLog(@"%f    %f", element.audioPlayer.currentTime, totalDuration);
    
    AVAudioPlayer *currentAudioPlayer = element.audioPlayer;
    if (currentDuration >= totalDuration - element.fadeOutInterval.floatValue) {
        
        float volume = currentAudioPlayer.volume;
        volume = volume - 1.0 / MGAUDIO_FADE_STEPS;
        volume = volume < 0.05 ? 0.005 : volume;
        
        
        NSLog(@"volume: %f                %@", volume, element.musicName);
        
        currentAudioPlayer.volume = volume;
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
