//
//  GameScene.h
//  TunnelRunner
//

//  Copyright (c) 2014 Michael Zuccarino. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol TunnelDelegate <NSObject>

@required
-(void)didDie;
-(void)didWin;

@end

@interface GameScene : SKScene

@property (nonatomic) id<TunnelDelegate> delegate;

@end
