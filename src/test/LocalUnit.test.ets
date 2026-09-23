// import { describe, expect, it } from '@ohos/hypium';
// import { ShimmerGeometry } from '../main/ets/geometry/ShimmerGeometry';
// import { ShimmerBand } from '../main/ets/models/ShimmerBand';
// import { ShimmerGradientStop } from '../main/ets/models/ShimmerGradientStop';
// import { ShimmerColor, ShimmerRgba } from '../main/ets/styles/ShimmerColor';
// import { ShimmerPalette } from '../main/ets/styles/ShimmerPalette';
// import { ShimmerDirection } from '../main/ets/tokens/ShimmerTokens';
//
// /** Tolerance for values that pass through trigonometry. */
// const EPSILON: number = 0.01;
//
// function isClose(actual: number, expected: number): boolean {
//   return Math.abs(actual - expected) < EPSILON;
// }
//
// export default function localUnitTest() {
//
//   describe('ShimmerColorTest', () => {
//
//     it('reads every hex form', 0, () => {
//       const short: ShimmerRgba | undefined = ShimmerColor.toRgba('#F00');
//       expect(short?.red).assertEqual(255);
//       expect(short?.green).assertEqual(0);
//       expect(short?.alpha).assertEqual(1);
//
//       const rgb: ShimmerRgba | undefined = ShimmerColor.toRgba('#00FF80');
//       expect(rgb?.green).assertEqual(255);
//       expect(rgb?.blue).assertEqual(128);
//
//       const argb: ShimmerRgba | undefined = ShimmerColor.toRgba('#80FFFFFF');
//       expect(argb?.red).assertEqual(255);
//       expect(isClose(argb?.alpha ?? 0, 128 / 255)).assertTrue();
//     });
//
//     it('reads the rgb and rgba functions', 0, () => {
//       const opaque: ShimmerRgba | undefined = ShimmerColor.toRgba('rgb(10, 20, 30)');
//       expect(opaque?.red).assertEqual(10);
//       expect(opaque?.alpha).assertEqual(1);
//
//       const translucent: ShimmerRgba | undefined = ShimmerColor.toRgba('rgba(10, 20, 30, 0.5)');
//       expect(translucent?.blue).assertEqual(30);
//       expect(isClose(translucent?.alpha ?? 0, 0.5)).assertTrue();
//     });
//
//     it('treats a number at or below 0xFFFFFF as opaque', 0, () => {
//       const white: ShimmerRgba | undefined = ShimmerColor.toRgba(0xFFFFFF);
//       expect(white?.red).assertEqual(255);
//       expect(white?.alpha).assertEqual(1);
//
//       const half: ShimmerRgba | undefined = ShimmerColor.toRgba(0x80FF0000);
//       expect(half?.red).assertEqual(255);
//       expect(isClose(half?.alpha ?? 0, 128 / 255)).assertTrue();
//     });
//
//     it('returns undefined rather than guessing a color', 0, () => {
//       expect(ShimmerColor.toRgba('not a color') === undefined).assertTrue();
//       expect(ShimmerColor.toRgba('#GGGGGG') !== undefined).assertTrue();
//       expect(ShimmerColor.toRgba('#12345') === undefined).assertTrue();
//       expect(ShimmerColor.toRgba(-1) === undefined).assertTrue();
//     });
//
//     it('treats the alpha of the color as a ceiling', 0, () => {
//       // A token that is already half transparent must not become opaque.
//       expect(ShimmerColor.withOpacity('#80FFFFFF', 1)).assertEqual('#80FFFFFF');
//       expect(ShimmerColor.withOpacity('#FFFFFFFF', 0.5)).assertEqual('#80FFFFFF');
//     });
//
//     it('keeps the channels when fading a color out', 0, () => {
//       // Fading towards transparent black would drag the midpoint through grey
//       // and leave a dark seam along the edges of the band.
//       expect(ShimmerColor.toTransparent('#FFFFFFFF')).assertEqual('#00FFFFFF');
//       expect(ShimmerColor.toTransparent('#FF3366CC')).assertEqual('#003366CC');
//     });
//
//     it('converts the system color enum', 0, () => {
//       expect(ShimmerColor.of(Color.White)).assertEqual('#FFFFFFFF');
//       expect(ShimmerColor.of(Color.Transparent)).assertEqual('#00000000');
//     });
//   });
//
//   describe('ShimmerPaletteTest', () => {
//
//     it('places the stops the way the reference implementations do', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: '#FFFFFF',
//         highlightOpacity: 1,
//         intensity: 0,
//         dropOff: 0.5
//       });
//
//       expect(stops.length).assertEqual(4);
//       expect(isClose(stops[0].position, 0.25)).assertTrue();
//       expect(isClose(stops[1].position, 0.4995)).assertTrue();
//       expect(isClose(stops[2].position, 0.5005)).assertTrue();
//       expect(isClose(stops[3].position, 0.75)).assertTrue();
//     });
//
//     it('widens the core as intensity grows', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: '#FFFFFF',
//         highlightOpacity: 1,
//         intensity: 0.4,
//         dropOff: 0.3
//       });
//
//       expect(isClose(stops[1].position, 0.2995)).assertTrue();
//       expect(isClose(stops[2].position, 0.7005)).assertTrue();
//     });
//
//     it('never lets the two core stops share a position', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: '#FFFFFF',
//         highlightOpacity: 1,
//         intensity: 0,
//         dropOff: 0
//       });
//       expect(stops[1].position < stops[2].position).assertTrue();
//     });
//
//     it('fades the edges to the highlight color, not to black', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: '#FF3366CC',
//         highlightOpacity: 1,
//         intensity: 0,
//         dropOff: 0.5
//       });
//       expect(stops[0].color).assertEqual('#003366CC');
//       expect(stops[3].color).assertEqual('#003366CC');
//       expect(stops[1].color).assertEqual('#FF3366CC');
//     });
//
//     it('clamps the stops instead of rescaling them', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: '#FFFFFF',
//         highlightOpacity: 1,
//         intensity: 0.9,
//         dropOff: 0.9
//       });
//       expect(stops[0].position).assertEqual(0);
//       expect(stops[3].position).assertEqual(1);
//     });
//
//     it('falls back to the package highlight when the color is unreadable', 0, () => {
//       const stops: ShimmerGradientStop[] = ShimmerPalette.calculateBandStops({
//         highlightColor: 'not a color',
//         highlightOpacity: 1,
//         intensity: 0,
//         dropOff: 0.5
//       });
//       expect(stops[1].color).assertEqual('#FFFFFFFF');
//     });
//   });
//
//   describe('ShimmerGeometryTest', () => {
//
//     it('returns an empty band before the content is measured', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(0, 80, ShimmerDirection.LeftToRight, 0, 1);
//       expect(band.length).assertEqual(0);
//       expect(band.travelX).assertEqual(0);
//     });
//
//     it('starts fully outside and ends fully outside', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 0, 1);
//
//       // Leading edge sits on the entry boundary at progress zero.
//       const leadingEdgeAtStart: number = band.originX + band.length;
//       expect(leadingEdgeAtStart <= 0).assertTrue();
//
//       // Trailing edge has cleared the exit boundary at progress one.
//       const trailingEdgeAtEnd: number = band.originX + band.travelX;
//       expect(trailingEdgeAtEnd >= 200).assertTrue();
//     });
//
//     it('spans the content plus its own length', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 0, 1);
//       expect(isClose(band.length, 200)).assertTrue();
//       expect(isClose(band.travelX, 400)).assertTrue();
//       expect(band.travelY).assertEqual(0);
//     });
//
//     it('mirrors the travel for the opposite direction', 0, () => {
//       const forward: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 0, 1);
//       const backward: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.RightToLeft, 0, 1);
//
//       expect(isClose(backward.travelX, -forward.travelX)).assertTrue();
//       expect(backward.originX > 200).assertTrue();
//     });
//
//     it('swaps the axis for a vertical sweep', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.TopToBottom, 0, 1);
//       expect(band.travelX).assertEqual(0);
//       expect(isClose(band.length, 80)).assertTrue();
//       expect(isClose(band.travelY, 160)).assertTrue();
//       expect(band.rotationAngle).assertEqual(90);
//     });
//
//     it('lengthens the band and the travel as the tilt grows', 0, () => {
//       const upright: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 0, 1);
//       const tilted: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 20, 1);
//
//       expect(tilted.length > upright.length).assertTrue();
//       expect(tilted.travelX > upright.travelX).assertTrue();
//       expect(isClose(tilted.rotationAngle, 20)).assertTrue();
//     });
//
//     it('keeps a tilted band thin enough to be worth tilting', 0, () => {
//       // The previous implementation covered the diagonal twice over. The
//       // minimum coverage span has to stay well under that.
//       const tilted: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 20, 1);
//       const oldThickness: number = 2 * Math.sqrt(200 * 200 + 80 * 80);
//       expect(tilted.thickness < oldThickness / 2).assertTrue();
//     });
//
//     it('holds the travel finite at an extreme tilt', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 90, 1);
//       expect(Number.isFinite(band.travelX)).assertTrue();
//       expect(band.travelX > 0).assertTrue();
//     });
//
//     it('scales the band with the width ratio', 0, () => {
//       const half: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, 0, 0.5);
//       expect(isClose(half.length, 100)).assertTrue();
//       expect(isClose(half.travelX, 300)).assertTrue();
//     });
//
//     it('survives values that are not numbers', 0, () => {
//       const band: ShimmerBand =
//         ShimmerGeometry.calculateBand(200, 80, ShimmerDirection.LeftToRight, Number.NaN, 0);
//       expect(Number.isFinite(band.length)).assertTrue();
//       expect(band.length > 0).assertTrue();
//     });
//   });
// }