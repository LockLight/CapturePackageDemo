//
//  newsCell.m
//  科技头条Demo
//
//  Created by locklight on 17/3/8.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "newsCell.h"
#import "UIImageView+WebCache.h"

@interface newsCell ()

@property (weak, nonatomic) IBOutlet UILabel *newsContent;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsAddTime;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@end

@implementation newsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    _newsContent.text = @"没出生前就被污染了，有世界观前就被腐化了，一颗卑劣的种子所结出的苦果,你从未见过的真正的麦迪文";
//    _newsTitle.text = @"NGA.镶金玫瑰";
//    _newsAddTime.text = @"2017-3-21";
//    _newsImage.image = [UIImage imageNamed:@"lichKing"];

}

- (void)setModel:(newsModel *)model{
    _model = model;
    
    _newsContent.text = model.title;
    _newsTitle.text = model.sitename;
    _newsAddTime.text = [NSDate dateWithTimeIntervalSince1970:[model.addtime doubleValue]].description;
    [_newsImage sd_setImageWithURL:[NSURL URLWithString:model.src_img] placeholderImage:[UIImage imageNamed:@"lichKing"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
