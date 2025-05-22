import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/media_query_values.dart';

class SliderPlayerReuse extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const SliderPlayerReuse({
    Key? key,
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  }) : super(key: key);

  @override
  _SliderPlayerReuseState createState() => _SliderPlayerReuseState();
}

class _SliderPlayerReuseState extends State<SliderPlayerReuse> {
  late ValueNotifier<Duration> _visibleValue;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _visibleValue = ValueNotifier(widget.currentPosition);
  }

  @override
  void didUpdateWidget(SliderPlayerReuse oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update if the user is not interacting to prevent UI lag
    if (!_isUserInteracting && widget.currentPosition != _visibleValue.value) {
      _visibleValue.value = widget.currentPosition;
    }
  }

  @override
  void dispose() {
    _visibleValue.dispose();
    super.dispose();
  }

  double get percent {
    if (widget.duration.inMilliseconds <= 0) return 0;
    return _visibleValue.value.inMilliseconds / widget.duration.inMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    final double maxDuration = widget.duration.inMilliseconds.toDouble().clamp(1, double.infinity);

    return SizedBox(
      height: context.height * .3,
      child: ValueListenableBuilder<Duration>(
        valueListenable: _visibleValue,
        builder: (context, value, child) {
          return SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                startAngle: 180,
                endAngle: 360,
                showTicks: false,
                showLabels: false,
                canScaleToFit: true,
                radiusFactor: 1,
                axisLineStyle: AxisLineStyle(
                  color: HexColor("#16CCF7"),
                  thickness: 4.0,
                ),
                maximum: maxDuration,

                pointers: <GaugePointer>[
                  // Progress Bar
                  RangePointer(
                    value: percent * maxDuration,
                    width: 4.0,
                    color: Colors.white,
                    gradient: const SweepGradient(
  startAngle: 90 * (3.141592653589793 / 180), // Convert 90° to radians
  endAngle: (90 + 360) * (3.141592653589793 / 180), // Full sweep
  colors: [
    Color(0xFFDF23E1), // Pink at -12.93%
    Color(0xFF3820B2), // Deep Purple at 47.65%
    Color(0xFFAE39A0), // Light Blue at 105.85%
  ],
  stops: [0.0, 0.4765, 1.0], // Convert percentages to decimal
),
                  ),          
                  // Draggable Marker
                  MarkerPointer(
                    value: percent * maxDuration,
                    enableDragging: true,
                    onValueChanged: (v) {
                      _visibleValue.value = Duration(milliseconds: v.floor());
                    },
                    onValueChangeEnd: (_) {
                      _isUserInteracting = false;
                      widget.seekTo(_visibleValue.value);
                    },
                    onValueChangeStart: (_) {
                      _isUserInteracting = true;
                    },
                    markerHeight: 16.0,
                    markerWidth: 16.0,
                    markerType: MarkerType.circle,
                    color: Colors.white,
                    borderWidth: 2,
                    borderColor: Colors.white54,
                  ),
                ],
                // Time Labels
                annotations: [
                  GaugeAnnotation(
                    angle: 175,
                    positionFactor: 1,
                    widget: Text(
                      durationToString(value),
                      style: styleW400(context, fontSize: FontSize.f10, color: Colors.white),
                    ),
                  ),
                  GaugeAnnotation(
                    angle: 365,
                    positionFactor: 1,
                    widget: Text(
                      durationToString(widget.duration),
                      style: styleW400(context, fontSize: FontSize.f10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) => n >= 10 ? '$n' : '0$n';

  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

  return '$twoDigitMinutes:$twoDigitSeconds';
}
