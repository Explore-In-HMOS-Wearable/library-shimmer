// Transparent white, not #00000000: channels interpolate, so black would leave a grey seam at the band edges
const EDGE_COLOR: string = 'rgba(255, 255, 255, 0)';

/** Band gradient: transparent at both ends, white peak at the centre. */
export class ShimmerPalette {
  static calculateGradientColors(highlightOpacity: number): Array<[ResourceColor, number]> {
    const peakColor: string = `rgba(255, 255, 255, ${Math.min(1, Math.max(0, highlightOpacity))})`;
    return [[EDGE_COLOR, 0], [peakColor, 0.5], [EDGE_COLOR, 1]];
  }
}