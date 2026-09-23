import { EMPTY_SHIMMER_BAND, ShimmerBand } from '../models/ShimmerBand';
import { ShimmerDirection } from '../tokens/ShimmerTokens';

// At 90 the band stops moving along the axis and travel becomes infinite
const MAXIMUM_TILT_DEGREES: number = 89;
// Covers antialiasing on the long edges; without it a hairline shows at tilt 0
const THICKNESS_MARGIN: number = 2;

/**
 * Pure geometry, in vp from the top left of the content.
 * The band travels strictly along the direction axis; tilt only leans it.
 * Leaning the travel too would make a wide, short card's sweep exit through the bottom edge.
 */
export class ShimmerGeometry {
  // At progress 0 and 1 the band is fully outside the content
  static calculateBand(
    contentWidth: number,
    contentHeight: number,
    direction: ShimmerDirection,
    tilt: number,
    widthRatio: number
  ): ShimmerBand {
    if (contentWidth <= 0 || contentHeight <= 0 || widthRatio <= 0) {
      return EMPTY_SHIMMER_BAND;
    }

    const isHorizontal: boolean =
      direction === ShimmerDirection.LeftToRight || direction === ShimmerDirection.RightToLeft;
    const isReversed: boolean =
      direction === ShimmerDirection.RightToLeft || direction === ShimmerDirection.BottomToTop;
    const alongAxis: number = isHorizontal ? contentWidth : contentHeight;
    const acrossAxis: number = isHorizontal ? contentHeight : contentWidth;

    const tiltDegrees: number = Math.min(MAXIMUM_TILT_DEGREES, Math.max(-MAXIMUM_TILT_DEGREES, tilt));
    const cosine: number = Math.cos(tiltDegrees * Math.PI / 180);
    const sine: number = Math.abs(Math.sin(tiltDegrees * Math.PI / 180));

    const length: number = (alongAxis * cosine + acrossAxis * sine) * widthRatio;
    const thickness: number = (length * sine + acrossAxis) / cosine + THICKNESS_MARGIN * 2;
    const entryOffset: number = (length + acrossAxis * sine) / 2 / cosine;
    const travel: number = (alongAxis + entryOffset * 2) * (isReversed ? -1 : 1);

    const startAlongAxis: number = isReversed ? alongAxis + entryOffset : -entryOffset;
    const centreX: number = isHorizontal ? startAlongAxis : acrossAxis / 2;
    const centreY: number = isHorizontal ? acrossAxis / 2 : startAlongAxis;

    return {
      length: length,
      thickness: thickness,
      originX: centreX - length / 2,
      originY: centreY - thickness / 2,
      rotationAngle: (isHorizontal ? 0 : 90) + tiltDegrees,
      travelX: isHorizontal ? travel : 0,
      travelY: isHorizontal ? 0 : travel
    };
  }
}