//
//  MGAudioPlayerConfigurate.h
//  MGAudioPlayer
//
//  Created by maling on 2019/8/9.
//  Copyright © 2019 maling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAudioPlayerConfigurate : NSObject

@property (nonatomic, assign, getter=isRepeat) BOOL repeat;

// 总的播放次数
@property (nonatomic, strong) NSNumber *numberOfLoops;
// 当前播放到第几次
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
