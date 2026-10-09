# ``AccessorySurface``

Replace a native bottom accessory’s visible surface with your own glass view.

@Options {
    @TopicsVisualStyle(detailedGrid)
}

## Overview

Acquire a source lease, use the native source’s resolved geometry to position your view, and choose its glass response. Your app owns content, corner shaping, presentation, animation and gestures. All public operations run on the main actor.

AccessorySurface uses non-public UIKit hooks. Source suppression is required for a replacement: a failed lease leaves the native source available. Glass response controls are optional and fall back independently. Availability checks describe the current source and runtime; they do not guarantee future OS compatibility.

## Topics

### Replace the Native Surface

- <doc:Integration>

### Configure Glass

- <doc:GlassResponses>


## iOS 18 compatibility

Use `AccessoryGlass.makeSurfaceEffect()` to obtain native interactive glass on
iOS 26 and later, or a system-material blur on iOS 18. `makeInteractiveEffect()`
requires iOS 26; response application returns zero on earlier systems. Native
bottom accessories still require iOS 26. An app-owned empty positioning view on
iOS 18 supplies geometry without acquiring a source suppression lease; the app
reserves space and owns the same content, animation and gestures in both cases.
