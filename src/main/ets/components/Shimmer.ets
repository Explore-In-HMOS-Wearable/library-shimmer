import { ShimmerClock } from '../animations/ShimmerClock';
import { ShimmerGeometry } from '../geometry/ShimmerGeometry';
import { EMPTY_SHIMMER_BAND, ShimmerBand } from '../models/ShimmerBand';
import { ResolvedShimmerOptions, ShimmerOptions } from '../models/ShimmerOptions';
import { ShimmerDefaults } from '../services/ShimmerDefaults';
import { ShimmerPalette } from '../styles/ShimmerPalette';

// Band is rotated on its own, so the gradient stays along its length
const BAND_GRADIENT_ANGLE: number = 90;

/**
 * Paints a moving highlight over any content.
 * The wrapper hugs its content; content that should fill the line declares its own width.
 */
@ComponentV2({ freezeWhenInactive: true })
export struct Shimmer {
  @Require @BuilderParam content: () => void;
  @Param options: ShimmerOptions = {};
  @Local private contentWidth: number = 0;
  @Local private contentHeight: number = 0;
  @Local private isVisibleOnScreen: boolean = true;
  private readonly clock: ShimmerClock = new ShimmerClock();

  @Computed
  get settings(): ResolvedShimmerOptions {
    return ShimmerDefaults.resolve(this.options);
  }

  // Empty band means no sweep: disabled or not measured yet
  @Computed
  get band(): ShimmerBand {
    const settings: ResolvedShimmerOptions = this.settings;
    if (!settings.isEnabled) {
      return EMPTY_SHIMMER_BAND;
    }
    return ShimmerGeometry.calculateBand(
      this.contentWidth,
      this.contentHeight,
      settings.direction,
      settings.tilt,
      settings.widthRatio
    );
  }

  // accessibilityText has separate string and Resource overloads; a union matches neither
  @Computed
  get accessibilityLabel(): string {
    const label: ResourceStr = this.settings.accessibilityText;
    if (typeof label === 'string') {
      return label;
    }
    return this.getUIContext().getHostContext()?.resourceManager?.getStringSync(label) ?? '';
  }

  @Monitor('options', 'contentWidth', 'contentHeight')
  onSweepInputChanged(): void {
    console.log(`Shimmer sweep | size: ${this.contentWidth}x${this.contentHeight} | band.length: ${this.band.length}`);
    if (this.band.length > 0) {
      this.clock.start(this.getUIContext(), this.settings.duration, this.settings.curve);
    } else {
      this.clock.stop(this.getUIContext());
    }
  }

  build() {
    if (this.settings.maskToContent) {
      this.maskedLayout();
    } else {
      this.overlayLayout();
    }
  }

  /** Band over the content, clipped to the wrapper box. */
  @Builder
  private overlayLayout() {
    Column() {
      this.content();
    }
    .borderRadius(this.settings.borderRadius)
    .clip(true)
    .overlay(this.bandLayer())
    .accessibilityGroup(this.accessibilityLabel.length > 0)
    .accessibilityText(this.accessibilityLabel)
    .onSizeChange((oldSize: SizeOptions, newSize: SizeOptions) => this.readSize(newSize))
    .onVisibleAreaChange([0.0, 0.05], (isVisible: boolean) => {
      this.isVisibleOnScreen = isVisible;
    });
  }

  /**
   * Content drawn twice: once as it is, once as a DST_IN mask that keeps the
   * band only where the content is opaque, which is how a gradient is clipped
   * to text glyphs in ArkUI.
   */
  @Builder
  private maskedLayout() {
    Stack() {
      Column() {
        this.content();
      };

      Stack() {
        // Direct child, not an overlay: an overlay layer is composited after the
        // blend and the mask would never see it
        this.bandLayer();

        Column() {
          this.content();
        }
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN);
      }
      .width(this.contentWidth)
      .height(this.contentHeight)
      .clip(true)
      .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN);
    }
    .accessibilityGroup(this.accessibilityLabel.length > 0)
    .accessibilityText(this.accessibilityLabel)
    .onSizeChange((oldSize: SizeOptions, newSize: SizeOptions) => this.readSize(newSize))
    .onVisibleAreaChange([0.0, 0.05], (isVisible: boolean) => {
      this.isVisibleOnScreen = isVisible;
    });
  }

  // Oversized band: position keeps it out of layout, translate animates on the render thread
  @Builder
  private bandLayer() {
    if (this.band.length > 0) {
      Column()
        .width(this.band.length)
        .height(this.band.thickness)
        .position({ x: this.band.originX, y: this.band.originY })
        .translate({ x: this.clock.progress * this.band.travelX, y: this.clock.progress * this.band.travelY })
        .linearGradient({
          angle: BAND_GRADIENT_ANGLE,
          colors: ShimmerPalette.calculateGradientColors(this.settings.highlightOpacity)
        })
        .rotate({ angle: this.band.rotationAngle, centerX: '50%', centerY: '50%' })
        .hitTestBehavior(HitTestMode.None)
        .accessibilityLevel('no');
    }
  }

  private readSize(size: SizeOptions): void {
    this.contentWidth = size.width as number;
    this.contentHeight = size.height as number;
  }
}