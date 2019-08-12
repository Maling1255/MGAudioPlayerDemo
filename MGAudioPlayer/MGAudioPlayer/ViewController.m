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
    
    
//    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
//    configurate.repeat = YES;
//    configurate.numberOfLoops = @(10);
//
//
//    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
//    audioElement1.musicName = @"breath_in";
//    audioElement1.voiceDuration = @"4";
//    audioElement1.fadeInInterval = @"1";
//    audioElement1.fadeOutInterval = @"1";
//
//    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
//    audioElement2.musicName = @"breath_out";
//    audioElement2.voiceDuration = @"4";
//    audioElement2.fadeInInterval = @"1";
//    audioElement2.fadeOutInterval = @"1";
//
//    MGAudioElement *audioElement3 = [[MGAudioElement alloc] init];
//    audioElement3.musicName = @"breath_hold";
//    audioElement3.voiceDuration = @"5";
//    audioElement3.fadeInInterval = @"1";
//    audioElement3.fadeOutInterval = @"1";
//
//
//    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement2, audioElement3].mutableCopy configurate:configurate];
    

//    NSArray *musics = @[@"breath_in", @"breath_out", @"breath_hold"];
    NSArray *musics = @[@"in_ok", @"out_ok", @"hold_ok"];
    for (int i = 0; i < 3; i++) {

        NSString *path1 = [[NSBundle mainBundle] pathForResource:musics[i] ofType:@"mp3"];
        NSURL *audioFileURL = [NSURL fileURLWithPath:path1];
        AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);

        NSLog(@"%@ : %f", musics[i], audioDurationSeconds);
    }
}

- (IBAction)click478:(id)sender {
    
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(4);
    
    
    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"inhale";
    audioElement1.voiceDuration = @"4";
    audioElement1.fadeInInterval = @"1.5";
    audioElement1.fadeOutInterval = @"0.8";
    
    MGAudioElement *audioElement3 = [[MGAudioElement alloc] init];
    audioElement3.musicName = @"hold";
    audioElement3.voiceDuration = @"7";
    audioElement3.fadeInInterval = @"2";
    audioElement3.fadeOutInterval = @"2";
//
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"exhale";
    audioElement2.voiceDuration = @"8";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"5";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement3, audioElement2].mutableCopy configurate:configurate];
    
}
- (IBAction)clickUjjayiBreath:(id)sender {
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(5);
    
    
    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"inhale";
    audioElement1.voiceDuration = @"7";
    audioElement1.fadeInInterval = @"2";
    audioElement1.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"exhale";
    audioElement2.voiceDuration = @"7";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"3";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement2 ].mutableCopy configurate:configurate];
    
}
- (IBAction)clickSquarebreath:(id)sender {
    
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(4);

    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"inhale";
    audioElement1.voiceDuration = @"4";
    audioElement1.fadeInInterval = @"1.5";
    audioElement1.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement3 = [[MGAudioElement alloc] init];
    audioElement3.musicName = @"hold";
    audioElement3.voiceDuration = @"4";
    audioElement3.fadeInInterval = @"1";
    audioElement3.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"exhale";
    audioElement2.voiceDuration = @"4";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"2";
    
    MGAudioElement *audioElement4 = [[MGAudioElement alloc] init];
    audioElement4.musicName = @"hold";
    audioElement4.voiceDuration = @"4";
    audioElement4.fadeInInterval = @"1";
    audioElement4.fadeOutInterval = @"1";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement3, audioElement2 , audioElement4].mutableCopy configurate:configurate];
    
    
}

- (IBAction)clickBreath:(id)sender {
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(7);
    
    
    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"breath_in";
    audioElement1.voiceDuration = @"4";
    audioElement1.fadeInInterval = @"2";
    audioElement1.fadeOutInterval = @"0.2";
    
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"breath_out";
    audioElement2.voiceDuration = @"4";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"2";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement2].mutableCopy configurate:configurate];
}


















- (IBAction)clickTest:(id)sender {
    
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(7);
    
    MGAudioElement *audioElement1 = [[MGAudioElement alloc] init];
    audioElement1.musicName = @"breathe_guide";
    audioElement1.voiceDuration = @"10";
    audioElement1.fadeInInterval = @"1";
    audioElement1.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement2 = [[MGAudioElement alloc] init];
    audioElement2.musicName = @"breathe_guide";
    audioElement2.voiceDuration = @"10";
    audioElement2.fadeInInterval = @"1";
    audioElement2.fadeOutInterval = @"1";
    
    MGAudioElement *audioElement3 = [[MGAudioElement alloc] init];
    audioElement3.musicName = @"breathe_guide";
    audioElement3.voiceDuration = @"10";
    audioElement3.fadeInInterval = @"1";
    audioElement3.fadeOutInterval = @"1";
    
    [[MGAudioPlayer sharedManager] playAudios:@[audioElement1, audioElement2, audioElement3].mutableCopy configurate:configurate];
    
}




@end
