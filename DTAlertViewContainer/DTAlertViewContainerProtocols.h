//
//  DTAlertViewContainerProtocols.h
//  DTAlertViewContainer
//
//  Created by Dmitrii Titov on 01.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTAlertViewContainerProtocol <NSObject>

- (void)dismiss;
- (void)layoutAlertViewAnimated:(BOOL)animated;
- (void)focus;
- (void)performTextInputSwitch:(void (^)(void))switchAction;

@end

@protocol DTAlertViewProtocol <NSObject>

@property (nonatomic, weak) id<DTAlertViewContainerProtocol> delegate;

@property (nonatomic, assign) CGFloat requiredHeight;
@property (nonatomic, assign) CGRect frameToFocus;
@property (nonatomic, assign) BOOL needToFocus;

- (void)backgroundPressed;

@end
