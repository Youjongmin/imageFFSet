//
//  JMAlbumViewController.h
//  imageFFSet
//
//  Created by colondee on 2017. 10. 27..
//  Copyright © 2017년 yjm. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,JMAlbumType) {
    JMAlbumTypeImage,
    JMAlbumTypeVideo
};

@interface JMAlbumViewController : UIViewController

@property (nonatomic, assign) JMAlbumType mediatype; // image  video

- (void)didClickComplete:(void(^)(id resultdata))block;

@end
