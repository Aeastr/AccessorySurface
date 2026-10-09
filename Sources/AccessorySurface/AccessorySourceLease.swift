// Copyright (c) 2026 Aether.
// SPDX-License-Identifier: MIT

import UIKit
import AccessoryRuntime

/// Keeps the native source's appearance suppressed until invalidation or release.
/// Retain one lease while displaying a replacement surface over that source.
@MainActor
public final class AccessorySourceLease {
    private let runtime: ASRuntimeSourceLease

    /// Checks whether the source exposes the suppression hooks and expected ABI.
    /// - Parameter source: The native accessory content view to inspect.
    /// - Returns: Whether the expected hooks are available. This does not acquire
    ///   assertions, and a subsequent initializer can still return `nil`.
    public static func isAvailable(for source: UIView) -> Bool {
        ASRuntimeSourceLease.isAvailable(for: source)
    }

    /// Acquires the assertions that suppress the native source’s appearance.
    /// - Parameter source: The native accessory content view to suppress.
    /// - Returns: `nil` if required hooks or either assertion are unavailable.
    ///   Retain a successful lease while displaying your replacement.
    public init?(source: UIView) {
        guard let runtime = ASRuntimeSourceLease(source: source) else { return nil }
        self.runtime = runtime
    }

    /// Releases suppression assertions so the native source can draw again.
    /// Repeated calls are safe. Remove your replacement view when invalidating
    /// its lease. Releasing the lease also invalidates the underlying assertions.
    public func invalidate() { runtime.invalidate() }

    /// Resolves the native view whose geometry represents the visible source.
    /// - Parameter source: The native accessory content view.
    /// - Returns: Its morphing view when available, otherwise `source` itself.
    ///   The caller converts its geometry into the replacement’s coordinate space.
    public static func morphView(for source: UIView) -> UIView {
        ASRuntimeMorphView(source)
    }
}
