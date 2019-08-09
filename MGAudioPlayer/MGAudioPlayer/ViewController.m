//
//  ViewController.m
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import "ViewController.h"
#import "MGAudioPlayer.h"
#import "MGAudioPlayerConfigurate.h"
#import "MGAudioElement.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(4);
    
    
    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"breath_in";
    audioElement1.voiceDuration = @"4";
    audioElement1.fadeInInterval = @"1";
    audioElement1.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"breath_out";
    audioElement2.voiceDuration = @"8";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement3 = [[MGAudioElement alloc] init];
    audioElement3.musicName = @"breath_hold";
    audioElement3.voiceDuration = @"5";
    audioElement3.fadeInInterval = @"1";
    audioElement3.fadeOutInterval = @"1";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement2, audioElement3].mutableCopy configurate:configurate];
    
    
    
    
    
    NSArray *musics = @[@"breath_in", @"breath_out", @"breath_hold"];
    for (int i = 0; i < 3; i++) {
        
        NSString *path1 = [[NSBundle mainBundle] pathForResource:musics[i] ofType:@"mp3"];
        NSURL *audioFileURL = [NSURL fileURLWithPath:path1];
        AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        
        NSLog(@"%@ : %f", musics[i], audioDurationSeconds);
    }
    
    
}





@end
