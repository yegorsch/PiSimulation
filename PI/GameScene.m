//
//  GameScene.m
//  PI
//
//  Created by Егор on 5/19/18.
//  Copyright © 2018 Yegor's Mac. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKShapeNode *_squareNode;
    SKShapeNode *_circleNode;
    CGRect _squareRect;
    SKLabelNode *_scoreLabel;
    SKTexture *_dotTexture;
}

NSInteger const maxNumberOfDots = 20000;
NSInteger currentNumberOfDots = 0;
double dotsInCircle = 0;


- (void)didMoveToView:(SKView *)view {
    [self addSquare];
    [self addCircle];
    _scoreLabel = [SKLabelNode labelNodeWithText:@"Pi: "];
    _scoreLabel.position = CGPointMake(0, -_squareNode.frame.size.height / 2 - 45);
    _scoreLabel.color = [UIColor whiteColor];
    _scoreLabel.fontName = @"Arial-BoldMT";
    _scoreLabel.fontSize = 60;
    [self addChild:_scoreLabel];
    _dotTexture = [SKTexture textureWithImageNamed:@"whitePixel"];
}

- (void)addCircle {
    _circleNode = [SKShapeNode shapeNodeWithEllipseInRect:_squareRect];
    _circleNode.lineWidth = 4.5;
    [_squareNode addChild:_circleNode];
}

- (void)addSquare {
    double offset = 50;
    double edgeLength = self.scene.frame.size.width - offset;
    _squareRect = CGRectMake(self.scene.frame.origin.x + offset / 2,
                                   self.scene.frame.origin.y + edgeLength / 2,
                                   edgeLength, edgeLength);
    _squareNode = [SKShapeNode shapeNodeWithRect:_squareRect];
    _squareNode.lineWidth = 6.5;
    [self.scene addChild:_squareNode];
}

- (SKShapeNode *)generateDot {
    CGPoint randomPoint = CGPointMake([self getRandomXForRect], [self getRandomYForRect]);
    SKShapeNode *node = [[SKSpriteNode new] initWithTexture:_dotTexture];
    node.position = randomPoint;
    return node;
}

-(void)update:(CFTimeInterval)currentTime {
    [self addDots:3];
}

- (void)addDots:(int)num {
    for (int i = 0; i < num; i++) {
        if (currentNumberOfDots != maxNumberOfDots) {
            SKShapeNode *dot = [self generateDot];
            if ([_circleNode containsPoint:dot.frame.origin]) {
                dotsInCircle++;
                double piApprox = dotsInCircle / currentNumberOfDots * 4;
                NSString *labelString = [[NSString alloc] initWithFormat:@"Pi: %f", piApprox];
                [_scoreLabel setText:labelString];
            }
            [self.scene addChild:dot];
            currentNumberOfDots++;
        }
    }
}

-(double) getRandomXForRect {
    int lowerBound = 0;
    int upperBound = _squareRect.size.width;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue -  _squareRect.size.height / 2;
}

-(double) getRandomYForRect {
    int lowerBound = 0;
    int upperBound = _squareRect.size.height;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return rndValue - _squareRect.size.height / 2 - _squareRect.origin.x + _squareRect.origin.y;
}


@end
