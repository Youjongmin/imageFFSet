//
//  MMCameraPreviewCollectionViewCell.h
//  minimemaker
//
//  Created by cy on 2017. 2. 13..
//  Copyright © 2017년 Minkook Yoo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *MMCameraCollectionViewCellIdentifier = @"MMCameraPreviewCollectionViewCell";


@interface MMCameraPreviewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;

@end
