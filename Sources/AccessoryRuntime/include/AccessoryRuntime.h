// Copyright (c) 2026 Aether.
// SPDX-License-Identifier: MIT

#import <UIKit/UIKit.h>

UIView * _Nonnull ASRuntimeMorphView(UIView * _Nonnull source);
@interface ASRuntimeSourceLease : NSObject
+ (BOOL)isAvailableForSource:(UIView * _Nonnull)source NS_SWIFT_NAME(isAvailable(for:));
- (nullable instancetype)initWithSource:(UIView * _Nonnull)source;
- (void)invalidate;
@end

UIGlassEffect * _Nonnull ASRuntimeMakeInteractiveGlass(NSInteger variant) API_AVAILABLE(ios(26.0));
NSUInteger ASRuntimeApplyGlassVariant(UIView * _Nonnull root, NSInteger variant);
