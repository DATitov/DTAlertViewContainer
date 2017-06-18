//
//  DTAlertViewContainer.h
//  DTAlertViewContainer
//
//  Created by Dmitrii Titov on 01.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAlertViewContainerProtocols.h"

typedef NS_ENUM(NSUInteger, DTAlertViewContainerAppearenceType) {
    DTAlertViewContainerAppearenceTypeFromTop,
    DTAlertViewContainerAppearenceTypeFromBottom,
    DTAlertViewContainerAppearenceTypeFromLeft,
    DTAlertViewContainerAppearenceTypeFromRight,
    DTAlertViewContainerAppearenceTypeFade,
};

typedef NS_ENUM(NSUInteger, DTAlertViewPositionBinding) {
    DTAlertViewPositionBindingCentre,
    DTAlertViewPositionBindingTop,
    DTAlertViewPositionBindingBottom,
    DTAlertViewPositionBindingLeft,
    DTAlertViewPositionBindingRight
};

@interface DTAlertViewContainerController : UIViewController

@property (nonatomic, strong, readonly, nonnull) UIScrollView *scrollView;
@property (nonatomic, strong, readonly, nonnull) UIView<DTAlertViewProtocol> *alertView;
@property (nonatomic, strong, nonnull) UIVisualEffectView *backgroundView;
@property (nonatomic, assign) DTAlertViewContainerAppearenceType appearenceAnimation;
@property (nonatomic, assign) DTAlertViewPositionBinding positionBinding;
@property (nonatomic, strong, nonnull) UIColor *containerBackgroundColor;

@property (nonatomic, assign) CGFloat minimumVerticalOffset;
@property (nonatomic, assign) CGFloat horisontalOffset;
@property (nonatomic, assign) CGFloat appearenceDuration;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;
@property (nonatomic, assign) BOOL alertViewContainsTableView;
@property (nonatomic, assign) CGFloat backgroundAlpha;

@property (nonatomic, copy, nullable) void (^dismissAction)(void);


- (void)presentOverVC:(nonnull UIViewController *)vc
            alertView:(nonnull UIView<DTAlertViewProtocol> *)alertView
  appearenceAnimation:(DTAlertViewContainerAppearenceType)appearenceAnimation
           completion:(void (^ __nullable)(void))completion;

@end
