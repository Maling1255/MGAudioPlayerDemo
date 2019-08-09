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
@property (nonatomic, copy) NSString *voiceDuration;
@property (nonatomic, copy) NSString *fadeInInterval;
@property (nonatomic, copy) NSString *fadeOutInterval;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@end

NS_ASSUME_NONNULL_END
