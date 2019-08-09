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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    MGAudioPlayerConfigurate *configurate = [[MGAudioPlayerConfigurate alloc] init];
    configurate.repeat = YES;
    configurate.numberOfLoops = @(4);
    [[MGAudioPlayer sharedManager] playAudios:@[@"breath_in", @"breath_out", @"breath_hold"].mutableCopy configurate:configurate];
    
    
    
    
    
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
