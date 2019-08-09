//
//  AVAudioPlayer+Extension.m
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import "AVAudioPlayer+Extension.h"
#import <objc/runtime.h>

static char * const kAudioConfig = "kAudioConfig";
@implementation AVAudioPlayer (Extension)

- (void)setAudioConfig:(MGAudioPlayerConfigurate *)audioConfig
{
    objc_setAssociatedObject(self, &kAudioConfig, audioConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MGAudioPlayerConfigurate *)audioConfig
{
    return objc_getAssociatedObject(self, &kAudioConfig);
}

@end
