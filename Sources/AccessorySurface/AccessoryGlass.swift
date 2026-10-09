// Copyright (c) 2026 Aether.
// SPDX-License-Identifier: MIT

import UIKit
import AccessoryRuntime

/// Low-level glass response controls. Presentation and animation belong to callers.
@MainActor
public enum AccessoryGlass {
    /// Creates interactive glass with a requested native response.
    /// - Parameter variant: A native response index in `0...2`; defaults to `0`.
    /// - Returns: A configured effect when supported, otherwise the standard
    ///   public interactive glass effect. Unsupported indices also fall back.
    ///   The result does not report whether fallback occurred.
    public static func makeInteractiveEffect(variant: Int = 0) -> UIGlassEffect {
        ASRuntimeMakeInteractiveGlass(variant)
    }

    /// Applies a response to matching native interactions in a view subtree.
    /// - Parameters:
    ///   - variant: A native response index in `0...2`.
    ///   - root: The glass view whose interactions and descendants to visit.
    /// - Returns: The number of interactions whose preferred-variant readback
    ///   matches the request. Zero also covers absent hooks and unsupported
    ///   indices. The count does not verify the rendered appearance.
    /// Call after attachment or layout when native interactions are available.
    @discardableResult
    public static func applyVariant(_ variant: Int, to root: UIView) -> UInt {
        ASRuntimeApplyGlassVariant(root, variant)
    }
}
