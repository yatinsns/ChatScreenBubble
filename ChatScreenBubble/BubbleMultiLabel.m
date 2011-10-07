//
//  BubbleMultiLabel.m
//  ChatScreenBubble
//
//  Created by Yatin Sarbalia on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BubbleMultiLabel.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

#define EXTRA_PADDING_FOR_DELIVERY_READ_STATUS 30


@implementation BubbleMultiLabel

@synthesize showDeliveryReadStatus = showDeliveryReadStatus_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImageName:(NSString *)imageName leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        UIImage *bubbleImage = [UIImage imageNamed:imageName];
        UIImage *strechedImage = [bubbleImage stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        bubbleImageView_ = [[UIImageView alloc] initWithImage:strechedImage];
        [self addSubview:bubbleImageView_];
        
        labels_ = [[NSMutableArray alloc] init];
        lineViews_ = [[NSMutableArray alloc] init];
        showDeliveryReadStatus_ = NO;
    }
    return self;
}

- (void)dealloc
{
    self.texts = nil;
    self.font = nil;
    [labels_ release];
    [bubbleImageView_ release];
    [super dealloc];
}

- (UIFont *)font
{
    return font_;
}

- (void)setFont:(UIFont *)font
{
    if(font != font_)
    {
        [font_ release];
        font_ = [font retain];
        for(OHAttributedLabel *label in labels_)
        {
            label.font = font;
        }
    }
}

- (void)clearLabels
{
    for(OHAttributedLabel *label in labels_)
    {
        [label removeFromSuperview];        
    }
    [labels_ removeAllObjects];
}

- (NSMutableArray *)texts
{
    return texts_;
}

- (void)setTexts:(NSMutableArray *)texts
{
    if(texts != texts_)
    {
        [texts_ release];
        texts_ = [texts retain];
        [self clearLabels];
        for(NSString *text in texts_)
        {
            OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.textAlignment = UITextAlignmentLeft;
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.automaticallyAddLinksForType = NSTextCheckingAllTypes;
            
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text];
            label.attributedText = attributedText;
            [attributedText release];
            label.font = font_;
            
            [labels_ addObject:label];
            [self addSubview:label];
            [label release];
        }
    }
}

- (void)refreshLabels
{
    [self clearLabels];    
    for(NSString *text in texts_)
    {
        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.textAlignment = UITextAlignmentLeft;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.automaticallyAddLinksForType = NSTextCheckingAllTypes;
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text];
        label.attributedText = attributedText;
        [attributedText release];
        label.font = font_;
        
        [labels_ addObject:label];
        [self addSubview:label];
        [label release];
    }
}

- (void)setPaddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right inter:(CGFloat)inter
{
    paddingTop_ = top;
    paddingLeft_ = left;
    paddingRight_ = right;
    paddingBottom_ = bottom;
    paddingInter_ = inter;
}

#pragma mark - Layout management


- (void)removeSubLineViews
{
    for(UIView *lineView in lineViews_)
    {
        [lineView removeFromSuperview];
    }    
    [lineViews_ removeAllObjects];
    
}

- (void)layoutSubviews
{    
    [super layoutSubviews];
    
    [self removeSubLineViews];
    bubbleImageView_.frame = self.bounds;
    
    CGFloat x = paddingLeft_;
    CGFloat y = paddingTop_;
    CGFloat labelWidth = self.bounds.size.width - (paddingLeft_ + paddingRight_);
    if(showDeliveryReadStatus_)
        labelWidth -= EXTRA_PADDING_FOR_DELIVERY_READ_STATUS;
    
    BOOL first = YES;
    
    for(OHAttributedLabel *label in labels_)
    {
        if(!first)
        {            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(paddingLeft_, y+paddingInter_/2, labelWidth, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3];
            [self addSubview:lineView];
            [lineViews_ addObject:lineView];
            [lineView release];
            
            y+=paddingInter_;            
        }
        CGFloat remainingHeight = self.bounds.size.height - y - paddingBottom_;
        CGSize labelSize = [label.attributedText sizeConstrainedToSize:CGSizeMake(labelWidth, remainingHeight)];
        label.frame  = CGRectMake(x, y, labelSize.width, labelSize.height);
        y += labelSize.height;
        first = NO;
    }
}

- (void)refreshViewWithCurrentContext
{
    [self refreshLabels];   
    CGSize sizeToFit = [[self class] sizeForTexts:texts_ withFont:font_ constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) paddingTop:paddingTop_ left:paddingLeft_ bottom:paddingBottom_ right:paddingRight_ inter:paddingInter_ showShowDeliveryReadStatus:showDeliveryReadStatus_];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeToFit.width, sizeToFit.height);
}

+ (CGSize)sizeForTexts:(NSArray *)texts withFont:(UIFont *)font constrainedToSize:(CGSize)size paddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right inter:(CGFloat)inter showShowDeliveryReadStatus:(BOOL)showDeliveryReadStatus
{
    CGFloat labelWidth = size.width - (left + right);
    if(showDeliveryReadStatus)
        labelWidth -= EXTRA_PADDING_FOR_DELIVERY_READ_STATUS;
    
    CGFloat labelHeightSum = 0;
    
    for(NSString *text in texts)
    {
        NSMutableAttributedString *attributedText = [NSMutableAttributedString attributedStringWithString:text];
        [attributedText setFont:font];
        [attributedText setTextAlignment:kCTLeftTextAlignment lineBreakMode:UILineBreakModeWordWrap];
        CGSize labelSize = [attributedText sizeConstrainedToSize:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        labelHeightSum += labelSize.height;
    }
     
    CGFloat paddingInterSum = ([texts count] - 1) * inter;
    CGFloat height = top + labelHeightSum + paddingInterSum + bottom;
    
    return CGSizeMake(size.width, MIN(size.height, height));    
}

@end
