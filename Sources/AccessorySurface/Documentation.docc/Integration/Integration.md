# Replacing an Accessory Surface

Keep the native accessory’s layout while drawing a replacement in its place.

@Options {
    @TopicsVisualStyle(detailedGrid)
}

## Overview

Your view controller should own both the replacement view and its source lease. Wait until the native bottom accessory’s content view is attached to the hierarchy before attempting to acquire the lease.

```swift
// Inputs from your host controller, after the accessory is attached:
// source: the native bottom accessory’s content view
// container: the containing tab controller’s view
// replacement: the glass view your controller owns
guard let lease = AccessorySourceLease(source: source) else {
    return // Keep the native accessory; do not install the replacement.
}
// Store lease in your controller before returning from this operation.
container.addSubview(replacement)
let visibleSource = AccessorySourceLease.morphView(for: source)
replacement.frame = visibleSource.convert(visibleSource.bounds, to: container)
```

The lease retains the native suppression assertions. Keep it alive for the entire time the replacement is visible, including any expansion or dismissal you implement. The lease does not add views, manage content or animate geometry.

## Respond to Layout and Source Changes

Update your replacement’s frame when the host lays out. Resolve the morph view again rather than caching it across native hierarchy changes. The resolver returns the original source when it cannot obtain a suitable morphing view.

Model-frame conversion is enough for a resting overlay. If your app follows a source during an animation, it owns presentation-layer tracking and any display-link lifecycle.

If UIKit replaces the accessory’s content view, remove the old replacement and invalidate its lease before acquiring one for the new source. A lease applies to the source supplied at initialization; it does not automatically track replacements.

## Restore the Native Source

Remove your replacement view and call `invalidate()` on its retained lease. Invalidation can be repeated safely. Release the lease afterward; releasing it also invalidates the underlying assertions.

``AccessorySurface/AccessorySourceLease/isAvailable(for:)`` checks the expected hooks and alpha argument signature, but does not acquire assertions. A positive check does not guarantee initialization succeeds. Treat the optional initializer’s result as the acquisition outcome. There is no asynchronous completion callback or throwing error.

## Topics

### Own the Replacement Lifetime

- ``AccessorySurface/AccessorySourceLease``
- ``AccessorySurface/AccessorySourceLease/init(source:)``
- ``AccessorySurface/AccessorySourceLease/invalidate()``

### Resolve the Native Source

- ``AccessorySurface/AccessorySourceLease/isAvailable(for:)``
- ``AccessorySurface/AccessorySourceLease/morphView(for:)``


## iOS 18 compatibility

Use `AccessoryGlass.makeSurfaceEffect()` to obtain native interactive glass on
iOS 26 and later, or a system-material blur on iOS 18. `makeInteractiveEffect()`
requires iOS 26; response application returns zero on earlier systems. Native
bottom accessories still require iOS 26. An app-owned empty positioning view on
iOS 18 supplies geometry without acquiring a source suppression lease; the app
reserves space and owns the same content, animation and gestures in both cases.
