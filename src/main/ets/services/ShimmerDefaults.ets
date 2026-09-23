import { ResolvedShimmerOptions, ShimmerOptions } from '../models/ShimmerOptions';
import { ShimmerDirection } from '../tokens/ShimmerTokens';

const DEFAULT_OPTIONS: ResolvedShimmerOptions = {
  isEnabled: true,
  maskToContent: true,
  duration: 1400,
  direction: ShimmerDirection.LeftToRight,
  tilt: 20,
  curve: Curve.EaseInOut,
  highlightOpacity: 0.15,
  widthRatio: 0.65,
  borderRadius: 0,
  accessibilityText: ''
};

/** Fills omitted fields. For app wide settings, share one module level ShimmerOptions const. */
export class ShimmerDefaults {
  static resolve(options: ShimmerOptions): ResolvedShimmerOptions {
    return {
      isEnabled: options.isEnabled ?? DEFAULT_OPTIONS.isEnabled,
      maskToContent: options.maskToContent ?? DEFAULT_OPTIONS.maskToContent,
      duration: options.duration ?? DEFAULT_OPTIONS.duration,
      direction: options.direction ?? DEFAULT_OPTIONS.direction,
      tilt: options.tilt ?? DEFAULT_OPTIONS.tilt,
      curve: options.curve ?? DEFAULT_OPTIONS.curve,
      highlightOpacity: options.highlightOpacity ?? DEFAULT_OPTIONS.highlightOpacity,
      widthRatio: options.widthRatio ?? DEFAULT_OPTIONS.widthRatio,
      borderRadius: options.borderRadius ?? DEFAULT_OPTIONS.borderRadius,
      accessibilityText: options.accessibilityText ?? DEFAULT_OPTIONS.accessibilityText
    };
  }
}