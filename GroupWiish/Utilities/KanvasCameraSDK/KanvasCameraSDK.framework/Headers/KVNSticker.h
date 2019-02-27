//
//  KVNSticker.h
//  KanvasCameraSDK
//
//  Created by Damian Finkelstein on 4/12/17.
//  Copyright © 2017 Tony Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVNSticker : NSObject

@property (readonly, nonatomic) NSString * imageURL;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithURL:(NSString *)string;

@end
