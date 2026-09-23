import { UIContext } from '@kit.ArkUI';
import { SHIMMER_MINIMUM_DURATION } from '../tokens/ShimmerTokens';

@ObservedV2
export class ShimmerClock {
  /** 0: band before the entry edge, 1: band past the exit edge. */
  @Trace progress: number = 0;

  start(uiContext: UIContext, duration: number, curve: Curve | ICurve | string): void {
    // progress stays 1 while running; reset first or the new loop sees no change
    this.stop(uiContext);
    uiContext.animateTo({
      duration: Math.max(SHIMMER_MINIMUM_DURATION, duration),
      curve: curve,
      iterations: -1,
    }, () => {
      this.progress = 1;
    });
  }

  // Zero duration jumps without animating and cancels the running loop
  stop(uiContext: UIContext): void {
    uiContext.animateTo({ duration: 0 }, () => {
      this.progress = 0;
    });
  }
}