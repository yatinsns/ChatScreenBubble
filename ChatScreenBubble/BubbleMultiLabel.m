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

@implementation BubbleMultiLabel

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    bubbleImageView_.frame = self.bounds;
    
    CGFloat x = paddingLeft_;
    CGFloat y = paddingTop_;
    CGFloat labelWidth = self.bounds.size.width - (paddingLeft_ + paddingRight_);
    
    BOOL first = YES;
    
    for(OHAttributedLabel *label in labels_)
    {
        if(!first)
        {
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
    CGSize sizeToFit = [[self class] sizeForTexts:texts_ withFont:font_ constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) paddingTop:paddingTop_ left:paddingLeft_ bottom:paddingBottom_ right:paddingRight_ inter:paddingInter_];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeToFit.width, sizeToFit.height);
}

+ (CGSize)sizeForTexts:(NSArray *)texts withFont:(UIFont *)font constrainedToSize:(CGSize)size paddingTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right inter:(CGFloat)inter
{
    CGFloat labelWidth = size.width - (left + right);
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
