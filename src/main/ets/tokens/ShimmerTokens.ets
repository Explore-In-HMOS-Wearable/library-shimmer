/** Imports nothing, so any layer can import it without a cycle. */

/** Travel axis of the band, before tilt. */
export enum ShimmerDirection {
  LeftToRight = 0,
  RightToLeft = 1,
  TopToBottom = 2,
  BottomToTop = 3
}

// Floor for duration: shorter reads as flicker, zero applies instantly and shows no sweep
export const SHIMMER_MINIMUM_DURATION: number = 200;