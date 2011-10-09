//
//  BubbleMultiLabel.h
//  ChatScreenBubble
//
//  Created by Yatin Sarbalia on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleMultiLabel : UIView {
    UIImageView *bubbleImageView_;
    NSString *readImageName_;
    NSString *deliveryImageName_;
    
    NSMutableArray *labels_;
    NSMutableArray *lineViews_;
    NSMutableArray *texts_;
    NSMutableArray *status_;
    
    UIFont *font_;
    CGFloat paddingLeft_;
    CGFloat paddingRight_;
    CGFloat paddingTop_;
    CGFloat paddingBottom_;
    CGFloat paddingInter_;
    
    BOOL showDeliveryReadStatus_;
}

@property (nonatomic, retain) NSMutableArray *texts;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, assign) BOOL showDeliveryReadStatus;

- (id)initWithImageName:(NSString *)imageName leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight readImageName:(NSString *)readImageName deliveryImageName:(NSString*)deliveryImageName;

- (void)setPaddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right inter:(CGFloat)inter;
- (void)refreshViewWithCurrentContext;

+ (CGSize)sizeForTexts:(NSArray *)texts withFont:(UIFont *)font constrainedToSize:(CGSize)size paddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right inter:(CGFloat)inter showShowDeliveryReadStatus:(BOOL)showDeliveryReadStatus;

@end
