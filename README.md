<div>
  <h1>AccessorySurface <img src="Resources/icon/icon.png" alt="AccessorySurface icon" width="96" height="96" align="right"></h1>
  <p>Replace a native bottom accessory’s visible surface with your own glass view, while keeping control of its layout and animation.</p>
  <p><img src="https://img.shields.io/badge/iOS%20%2F%20iPadOS-18%2B-000000?logo=apple" alt="iOS / iPadOS 18+"> <img src="https://img.shields.io/badge/Swift-6.0%2B-F05138?logo=swift&amp;logoColor=white" alt="Swift 6.0+"></p>
</div>

## How it works

AccessorySurface gives you a retained lease that suppresses the native source’s appearance, a way to resolve its visible morphing view, and controls for the replacement’s glass response. Your app owns the replacement view, corner geometry, animation and gestures.

Source suppression and glass response selection use non-public UIKit hooks. Lease creation returns `nil` when suppression cannot be acquired; keep the native accessory visible in that case. Glass construction falls back to a standard public interactive effect when its requested response is unavailable. Operations return results directly, without error throws or observation callbacks.

## Installation

In Xcode, add `https://github.com/Aeastr/AccessorySurface` as a package dependency and link the **AccessorySurface** product to your app target.

For an app with a package manifest:

```swift
dependencies: [
    .package(url: "https://github.com/Aeastr/AccessorySurface.git", from: "1.1.0")
]

// In your app target’s dependencies:
.product(name: "AccessorySurface", package: "AccessorySurface")
```

For local development, add your AccessorySurface checkout with Xcode’s **Add Local** option instead.

## Quick start

Own this helper in your view controller. Once the native accessory is attached, pass its content view as `source` and the containing tab controller’s view as `container`. The helper installs a glass overlay at the source’s visible frame.

```swift
import UIKit
import AccessorySurface

@MainActor
final class AccessoryOverlay {
    private var lease: AccessorySourceLease?
    private weak var source: UIView?
    private let glass = UIVisualEffectView(
        effect: AccessoryGlass.makeSurfaceEffect()
    )

    @discardableResult
    func show(source: UIView, in container: UIView) -> Bool {
        remove()
        guard let lease = AccessorySourceLease(source: source) else {
            return false
        }
        self.lease = lease
        self.source = source
        container.addSubview(glass)
        updateLayout()
        // Add your content to glass.contentView.
        return true
    }

    func updateLayout() {
        guard let source, let container = glass.superview else { return }
        let visibleSource = AccessorySourceLease.morphView(for: source)
        glass.frame = visibleSource.convert(visibleSource.bounds, to: container)
        AccessoryGlass.applyVariant(0, to: glass)
    }

    func remove() {
        glass.removeFromSuperview()
        lease?.invalidate()
        lease = nil
        source = nil
    }
}
```

Call `updateLayout()` from your host’s `viewDidLayoutSubviews()` and `remove()` when detaching the overlay. Call `show(source:in:)` again if UIKit replaces the native source instance. Keep the helper alive while its overlay is displayed; releasing its lease restores the native appearance.

This example supplies a resting overlay. Implement your own corner shaping, presentation, animation and interaction around it.

## Earlier systems

The package supports iOS 18 and later. Native tab-bar bottom accessories and
interactive glass require iOS 26. `AccessoryGlass.makeSurfaceEffect()` returns
interactive glass on iOS 26+, and a system-material blur on earlier systems.
`makeInteractiveEffect()` remains available when guarded with iOS 26 availability;
`applyVariant` returns zero before iOS 26.

On iOS 18, provide your own empty positioning view above the tab bar, for example
with a safe-area inset on the tab's content. Use that view's converted frame to
place the same replacement surface. An empty anchor needs no suppression lease.
The package does not install tab-bar accessories or reserve content space.
Keep content, presentation and gestures shared between both placement paths.

## Documentation

Start with the [AccessorySurface documentation catalog](Sources/AccessorySurface/Documentation.docc/AccessorySurface.md).

- [Replacing an accessory surface](Sources/AccessorySurface/Documentation.docc/Integration/Integration.md): ownership, layout updates and restoring the native source.
- [Choosing a glass response](Sources/AccessorySurface/Documentation.docc/GlassResponses/GlassResponses.md): response variants, observable results and fallbacks.

## License

[MIT](LICENSE). Copyright © 2026 Aether. See [source notes](SOURCE-NOTES.md) for provenance.
