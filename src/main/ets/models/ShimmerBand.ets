/**
 * Band geometry in vp from the top left of the content.
 * Drawn as a length x thickness rectangle at origin, rotated about its own centre,
 * then translated by progress times travel.
 */
export interface ShimmerBand {
  /** Along the gradient, before rotation. */
  length: number;

  /** Across the gradient, before rotation. */
  thickness: number;
  originX: number;
  originY: number;

  /** Degrees, clockwise. */
  rotationAngle: number;
  travelX: number;
  travelY: number;
}

export const EMPTY_SHIMMER_BAND: ShimmerBand = {
  length: 0,
  thickness: 0,
  originX: 0,
  originY: 0,
  rotationAngle: 0,
  travelX: 0,
  travelY: 0
};