//
//  MGAudioElement.h
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAudioElement : NSObject <NSCopying>

@property (nonatomic, copy) NSString *musicName;
// 需要播放时长
@property (nonatomic, copy) NSString *voiceDuration;
@property (nonatomic, copy) NSString *fadeInInterval;
@property (nonatomic, copy) NSString *fadeOutInterval;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

//@property (nonatomic, assign) MGAudioPlayerConfigurate *configurate;


@end

NS_ASSUME_NONNULL_END
