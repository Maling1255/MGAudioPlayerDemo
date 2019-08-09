//
//  AVAudioPlayer+Extension.h
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MGAudioPlayerConfigurate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVAudioPlayer (Extension)

@property (nonatomic, strong) MGAudioPlayerConfigurate *audioConfig;

@end

NS_ASSUME_NONNULL_END
