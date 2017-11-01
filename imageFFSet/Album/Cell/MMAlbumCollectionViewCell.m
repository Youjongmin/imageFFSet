//
//  MMAlbumCollectionViewCell.m
//  minimemaker
//
//  Created by cy on 2017. 2. 10..
//  Copyright © 2017년 Minkook Yoo. All rights reserved.
//

#import "MMAlbumCollectionViewCell.h"

@implementation MMAlbumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
//    self.alphaView.layer.borderColor = [UIColor mainColor].CGColor;
}

- (void)setSelected:(BOOL)selected {
    
    _alphaView.layer.borderWidth = selected ? 3.0f : 0;
    
    [super setSelected:selected];
}

@end
