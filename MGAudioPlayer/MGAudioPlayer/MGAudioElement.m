//
//  MGAudioElement.m
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import "MGAudioElement.h"

@implementation MGAudioElement

- (instancetype)copyWithZone:(NSZone *)zone
{
    MGAudioElement *element = [[self.class allocWithZone:zone] init];
    element.musicName = self.musicName;
    element.voiceDuration = self.voiceDuration;
    element.fadeInInterval = self.fadeInInterval;
    element.fadeOutInterval = self.fadeOutInterval;
    element.audioPlayer = self.audioPlayer;
    return element;
}

@end
