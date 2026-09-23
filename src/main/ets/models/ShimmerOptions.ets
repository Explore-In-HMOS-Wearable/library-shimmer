import { ShimmerDirection } from '../tokens/ShimmerTokens';

/** Every field is optional; omitted ones come from ShimmerDefaults. */
export interface ShimmerOptions {
  /** When false, the content renders without a band. */
  isEnabled?: boolean;

  /**
   * Clips the highlight to the shape of the content, so shapes and glyphs
   * light up and the gaps between them stay dark. Costs a second draw of the
   * content; turn off for a plain sweep over a whole card.
   */
  maskToContent?: boolean;

  /** One sweep, in ms. */
  duration?: number;
  direction?: ShimmerDirection;

  /** Lean of the band away from the sweep axis, in degrees. */
  tilt?: number;
  curve?: Curve | ICurve | string;

  /** Alpha at the centre of the white band, 0 to 1. */
  highlightOpacity?: number;

  /** Band length as a fraction of the content span it crosses. */
  widthRatio?: number;

  /** Read when maskToContent is off, to match rounded content corners. */
  borderRadius?: number | BorderRadiuses;

  /** Read by screen readers instead of the skeleton; empty keeps the default. */
  accessibilityText?: ResourceStr;
}

export type ResolvedShimmerOptions = Required<ShimmerOptions>;