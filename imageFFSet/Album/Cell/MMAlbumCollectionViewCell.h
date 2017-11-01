//
//  MMAlbumCollectionViewCell.h
//  minimemaker
//
//  Created by cy on 2017. 2. 10..
//  Copyright © 2017년 Minkook Yoo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *MMAlbumCollectionViewCellIdentifier = @"MMAlbumCollectionViewCell";

@interface MMAlbumCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@end
