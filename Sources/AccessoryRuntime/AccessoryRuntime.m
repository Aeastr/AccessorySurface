// Copyright (c) 2026 Aether.
// SPDX-License-Identifier: MIT

#import "AccessoryRuntime.h"
#import <string.h>

// Private names are decoded once at runtime, keeping literal selectors out of
// Objective-C selector metadata. This is obfuscation, not an API stability or
// security boundary. Public UIKit calls and our own symbols remain readable.
#import <objc/message.h>

static NSString *ASRuntimeDecodeName(const uint8_t *bytes, NSUInteger count) {
    // A volatile key prevents folding the decoder into a plaintext constant.
    static volatile uint8_t key = 0xA7;
    uint8_t decoded[count];
    for (NSUInteger i = 0; i < count; i++) { decoded[i] = bytes[i] ^ key; }
    return [[NSString alloc] initWithBytes:decoded length:count encoding:NSASCIIStringEncoding];
}

typedef struct {
    SEL overrideAlpha;
    SEL suppressBackground;
    SEL morphView;
    SEL updateSuppression;
    SEL glass;
    SEL effectWithGlass;
    SEL setFlexVariant;
    SEL setPreferredVariant;
    SEL preferredVariant;
    NSString * __unsafe_unretained interactionClass;
} ASRuntimeRuntimeNames;

static const ASRuntimeRuntimeNames *ASRuntimeNames(void) {
    static ASRuntimeRuntimeNames names;
    static NSString *interactionClassName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const uint8_t overrideAlphaBytes[] = {0xf8, 0xd1, 0xc2, 0xc9, 0xc3, 0xe6, 0xd4, 0xd4, 0xc2, 0xd5, 0xd3, 0xce, 0xc8, 0xc9, 0xe1, 0xc8, 0xd5, 0xe8, 0xd1, 0xc2, 0xd5, 0xd5, 0xce, 0xc3, 0xc2, 0xe6, 0xcb, 0xd7, 0xcf, 0xc6, 0x9d};
        names.overrideAlpha = NSSelectorFromString(ASRuntimeDecodeName(overrideAlphaBytes, sizeof(overrideAlphaBytes)));
        const uint8_t suppressBackgroundBytes[] = {0xf8, 0xd4, 0xd2, 0xd7, 0xd7, 0xd5, 0xc2, 0xd4, 0xd4, 0xe5, 0xc6, 0xc4, 0xcc, 0xc0, 0xd5, 0xc8, 0xd2, 0xc9, 0xc3};
        names.suppressBackground = NSSelectorFromString(ASRuntimeDecodeName(suppressBackgroundBytes, sizeof(suppressBackgroundBytes)));
        const uint8_t morphViewBytes[] = {0xf8, 0xca, 0xc8, 0xd5, 0xd7, 0xcf, 0xf1, 0xce, 0xc2, 0xd0};
        names.morphView = NSSelectorFromString(ASRuntimeDecodeName(morphViewBytes, sizeof(morphViewBytes)));
        const uint8_t updateSuppressionBytes[] = {0xd2, 0xd7, 0xc3, 0xc6, 0xd3, 0xc2, 0xe5, 0xc6, 0xc4, 0xcc, 0xc0, 0xd5, 0xc8, 0xd2, 0xc9, 0xc3, 0xf4, 0xd2, 0xd7, 0xd7, 0xd5, 0xc2, 0xd4, 0xd4, 0xce, 0xc8, 0xc9, 0xee, 0xc1, 0xe9, 0xc2, 0xc2, 0xc3, 0xc2, 0xc3};
        names.updateSuppression = NSSelectorFromString(ASRuntimeDecodeName(updateSuppressionBytes, sizeof(updateSuppressionBytes)));
        const uint8_t glassBytes[] = {0xc0, 0xcb, 0xc6, 0xd4, 0xd4};
        names.glass = NSSelectorFromString(ASRuntimeDecodeName(glassBytes, sizeof(glassBytes)));
        const uint8_t effectWithGlassBytes[] = {0xc2, 0xc1, 0xc1, 0xc2, 0xc4, 0xd3, 0xf0, 0xce, 0xd3, 0xcf, 0xe0, 0xcb, 0xc6, 0xd4, 0xd4, 0x9d};
        names.effectWithGlass = NSSelectorFromString(ASRuntimeDecodeName(effectWithGlassBytes, sizeof(effectWithGlassBytes)));
        const uint8_t setFlexVariantBytes[] = {0xd4, 0xc2, 0xd3, 0xf8, 0xc1, 0xcb, 0xc2, 0xdf, 0xf1, 0xc6, 0xd5, 0xce, 0xc6, 0xc9, 0xd3, 0x9d};
        names.setFlexVariant = NSSelectorFromString(ASRuntimeDecodeName(setFlexVariantBytes, sizeof(setFlexVariantBytes)));
        const uint8_t setPreferredVariantBytes[] = {0xd4, 0xc2, 0xd3, 0xf7, 0xd5, 0xc2, 0xc1, 0xc2, 0xd5, 0xd5, 0xc2, 0xc3, 0xf1, 0xc6, 0xd5, 0xce, 0xc6, 0xc9, 0xd3, 0x9d};
        names.setPreferredVariant = NSSelectorFromString(ASRuntimeDecodeName(setPreferredVariantBytes, sizeof(setPreferredVariantBytes)));
        const uint8_t preferredVariantBytes[] = {0xd7, 0xd5, 0xc2, 0xc1, 0xc2, 0xd5, 0xd5, 0xc2, 0xc3, 0xf1, 0xc6, 0xd5, 0xce, 0xc6, 0xc9, 0xd3};
        names.preferredVariant = NSSelectorFromString(ASRuntimeDecodeName(preferredVariantBytes, sizeof(preferredVariantBytes)));
        const uint8_t interactionClassBytes[] = {0xf8, 0xf2, 0xee, 0xe1, 0xcb, 0xc2, 0xdf, 0xee, 0xc9, 0xd3, 0xc2, 0xd5, 0xc6, 0xc4, 0xd3, 0xce, 0xc8, 0xc9};
        interactionClassName = ASRuntimeDecodeName(interactionClassBytes, sizeof(interactionClassBytes));
        names.interactionClass = interactionClassName;
    });
    return &names;
}

// Typed dispatch preserves the Objective-C ABI, notably the double argument
// used by the source-alpha assertion. Callers check optional hooks first.
static id ASRuntimeObject(id receiver, SEL selector) {
    return ((id (*)(id, SEL))objc_msgSend)(receiver, selector);
}
static void ASRuntimeSetInteger(id receiver, SEL selector, NSInteger value) {
    ((void (*)(id, SEL, NSInteger))objc_msgSend)(receiver, selector, value);
}
static NSInteger ASRuntimeInteger(id receiver, SEL selector) {
    return ((NSInteger (*)(id, SEL))objc_msgSend)(receiver, selector);
}

@protocol ASRuntimeAssertion <NSObject>
- (void)invalidate;
@end

UIView *ASRuntimeMorphView(UIView *source) {
    SEL selector = ASRuntimeNames()->morphView;
    if ([source respondsToSelector:selector]) {
        id resolved = ASRuntimeObject(source, selector);
        if ([resolved isKindOfClass:UIView.class]) { return resolved; }
    }
    return source;
}

@interface ASRuntimeSourceLease ()
@property(nonatomic, strong) id<ASRuntimeAssertion> alphaAssertion;
@property(nonatomic, strong) id<ASRuntimeAssertion> backgroundAssertion;
@end

@implementation ASRuntimeSourceLease
+ (BOOL)isAvailableForSource:(UIView *)source {
    const ASRuntimeRuntimeNames *names = ASRuntimeNames();
    NSMethodSignature *signature = [source methodSignatureForSelector:names->overrideAlpha];
    UIView *morphView = ASRuntimeMorphView(source);
    return signature.numberOfArguments == 3 &&
        strcmp([signature getArgumentTypeAtIndex:2], @encode(double)) == 0 &&
        signature.methodReturnType[0] == '@' &&
        [morphView respondsToSelector:names->suppressBackground];
}
- (instancetype)initWithSource:(UIView *)source {
    if (![ASRuntimeSourceLease isAvailableForSource:source]) { return nil; }
    self = [super init];
    if (self) {
        const ASRuntimeRuntimeNames *names = ASRuntimeNames();
        _alphaAssertion = ((id (*)(id, SEL, double))objc_msgSend)(source, names->overrideAlpha, 0.0);
        _backgroundAssertion = ASRuntimeObject(ASRuntimeMorphView(source), names->suppressBackground);
        if ([_alphaAssertion respondsToSelector:names->updateSuppression]) {
            ((void (*)(id, SEL))objc_msgSend)(_alphaAssertion, names->updateSuppression);
        }
        if (!_alphaAssertion || !_backgroundAssertion) {
            [self invalidate];
            return nil;
        }
    }
    return self;
}
- (void)invalidate {
    if ([_alphaAssertion respondsToSelector:@selector(invalidate)]) { [_alphaAssertion invalidate]; }
    if ([_backgroundAssertion respondsToSelector:@selector(invalidate)]) { [_backgroundAssertion invalidate]; }
    _alphaAssertion = nil;
    _backgroundAssertion = nil;
}
- (void)dealloc { [self invalidate]; }
@end

UIGlassEffect *ASRuntimeMakeInteractiveGlass(NSInteger variant) {
    UIGlassEffect *effect = [UIGlassEffect new];
    effect.interactive = YES;
    const ASRuntimeRuntimeNames *names = ASRuntimeNames();
    if (variant < 0 || variant > 2 ||
        ![effect respondsToSelector:names->glass] ||
        ![UIGlassEffect respondsToSelector:names->effectWithGlass]) { return effect; }
    // Configure a fresh material; never mutate shared presets during a drag.
    id glass = ASRuntimeObject(effect, names->glass);
    if (![glass respondsToSelector:names->setFlexVariant]) { return effect; }
    ASRuntimeSetInteger(glass, names->setFlexVariant, variant);
    id configured = ((id (*)(id, SEL, id))objc_msgSend)(UIGlassEffect.class, names->effectWithGlass, glass);
    if (![configured isKindOfClass:UIGlassEffect.class]) { return effect; }
    ((UIGlassEffect *)configured).interactive = YES;
    return configured;
}

NSUInteger ASRuntimeApplyGlassVariant(UIView *root, NSInteger variant) {
    if (variant < 0 || variant > 2) { return 0; }
    const ASRuntimeRuntimeNames *names = ASRuntimeNames();
    NSUInteger applied = 0;
    for (id interaction in root.interactions) {
        if (![NSStringFromClass([interaction class]) isEqualToString:names->interactionClass] ||
            ![interaction respondsToSelector:names->setPreferredVariant] ||
            ![interaction respondsToSelector:names->preferredVariant]) { continue; }
        if (ASRuntimeInteger(interaction, names->preferredVariant) != variant) {
            ASRuntimeSetInteger(interaction, names->setPreferredVariant, variant);
        }
        if (ASRuntimeInteger(interaction, names->preferredVariant) == variant) { applied++; }
    }
    for (UIView *child in root.subviews) { applied += ASRuntimeApplyGlassVariant(child, variant); }
    return applied;
}
