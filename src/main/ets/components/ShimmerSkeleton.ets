// White at low alpha takes its tone from the surface underneath; tune on device
const PLACEHOLDER_FILL_COLOR: string = '#2C2C2E';
const LINE_THICKNESS: number = 12;
const LINE_SPACING: number = 8;
const LAST_LINE_LENGTH: string = '60%';

/**
 * Placeholder shapes. They do not animate; wrap a whole group in one Shimmer,
 * so the band crosses every shape at the same speed and in the same phase.
 * Params avoid universal attribute names (width, height, borderRadius), which fail to compile.
 */

/** Defaults to one full width text line; set boxHeight for images and cards. */
@ComponentV2
export struct ShimmerBox {
  @Param boxWidth: Length = '100%';
  @Param boxHeight: Length = LINE_THICKNESS;
  @Param cornerRadius: number | BorderRadiuses = LINE_THICKNESS / 2;

  build() {
    Column()
      .width(this.boxWidth)
      .height(this.boxHeight)
      .borderRadius(this.cornerRadius)
      .backgroundColor(PLACEHOLDER_FILL_COLOR)
      .accessibilityLevel('no');
  }
}

@ComponentV2
export struct ShimmerCircle {
  @Param diameter: number = 40;

  build() {
    ShimmerBox({ boxWidth: this.diameter, boxHeight: this.diameter, cornerRadius: this.diameter / 2 });
  }
}

@ComponentV2
export struct ShimmerParagraph {
  @Param lineCount: number = 3;

  @Computed
  get lines(): number[] {
    return new Array<number>(this.lineCount).fill(0);
  }

  build() {
    Column({ space: LINE_SPACING }) {
      ForEach(this.lines, (line: number, index: number) => {
        ShimmerBox({ boxWidth: index === this.lineCount - 1 ? LAST_LINE_LENGTH : '100%' });
      }, (line: number, index: number) => index.toString());
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%');
  }
}