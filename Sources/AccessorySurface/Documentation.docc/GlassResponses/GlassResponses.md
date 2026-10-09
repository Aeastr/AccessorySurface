# Choosing a Glass Response

Create an interactive glass surface and configure its native response where available.

@Options {
    @TopicsVisualStyle(detailedGrid)
}

## Overview

``AccessorySurface/AccessoryGlass/makeInteractiveEffect(variant:)`` returns an interactive `UIGlassEffect`. Variants `0...2` are passed through to the native response controls; their appearance depends on the OS implementation. The default is `0`.

```swift
// Run on the main actor; retain glass as part of your own view hierarchy.
let glass = UIVisualEffectView(
    effect: AccessoryGlass.makeInteractiveEffect(variant: 0)
)
// After attachment or layout, when native interactions are present:
let applied = AccessoryGlass.applyVariant(0, to: glass)
```

The effect factory returns standard public interactive glass if a variant is outside `0...2`, a required hook is absent, or the configured result is not a glass effect. The return value does not distinguish a selected variant from the fallback.

## Apply a Response After Layout

Native interactions can appear after effect construction. Call ``AccessorySurface/AccessoryGlass/applyVariant(_:to:)`` after attaching or laying out the glass view. It visits the supplied view and its descendants, sets matching interactions’ preferred variant and reads it back.

The returned count is the number of interactions whose readback matches the requested variant. It is not a rendered-frame measurement or a guarantee about appearance. Zero can mean no matching interaction, unavailable hooks, unsuccessful readback or an unsupported variant. No callback is sent and no error is thrown.

Glass response fallback does not supply a replacement for source suppression. Acquire and retain a source lease separately before covering the native accessory.

## Topics

### Create and Configure Glass

- ``AccessorySurface/AccessoryGlass``
- ``AccessorySurface/AccessoryGlass/makeInteractiveEffect(variant:)``
- ``AccessorySurface/AccessoryGlass/applyVariant(_:to:)``
