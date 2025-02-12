import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../../config/themes/colors.dart';
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
  late Duration _visibleValue;
  bool listenOnlyUserInteraction = false;

  double get percent {
    if (widget.duration.inMilliseconds == 0) {
      return 0;
    }
    return _visibleValue.inMilliseconds / widget.duration.inMilliseconds;
  }

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
    log('Initial Duration: ${widget.duration.inMilliseconds} ms');
  }

  @override
  void didUpdateWidget(SliderPlayerReuse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInteraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  double soundValue = 90;
  @override
  Widget build(BuildContext context) {
    final maximum = widget.duration.inMilliseconds > 0
        ? widget.duration.inMilliseconds.toDouble()
        : 1.0; // Ensure maximum is positive and avoids zero or negative

    const minimum = 0.0;
    return SizedBox(
      height: context.height * .3,
      child: SfRadialGauge(
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

            maximum: maximum
            //  (widget.duration.inMilliseconds!.toDouble() > 0)
            //     ? widget.duration.inMilliseconds!.toDouble()
            //     : 0.0
            ,
            pointers: <GaugePointer>[
              // range
              RangePointer(
                value:
                    percent * widget.currentPosition.inMilliseconds.toDouble(),
                width: 4.0,
                color: Colors.white,
                onValueChanging: (value) => log(value.toString()),
                gradient: SweepGradient(
                  colors: [
                    AppColors.cViolet,
                    HexColor("#FFFFFF"),
                    AppColors.cBannerColor,
                    AppColors.cViolet,
                  ],
                ),
              ),
              // point at start
              MarkerPointer(
                value:
                    percent * widget.currentPosition.inMilliseconds.toDouble(),
                enableDragging: true,
                onValueChanged: (v) {
                  // soundValue = v;
                  // setState(() {});
                  // debugPrint("$soundValue");
                  setState(() {
                    final to = Duration(milliseconds: v.floor());
                    _visibleValue = to;
                    // log(' minimum $minimum');
                    // log(' maximum $maximum');
                    // log(maximum.toString());
                  });
                },
                onValueChangeEnd: (newValue) {
                  setState(() {
                    listenOnlyUserInteraction = false;
                    widget.seekTo(_visibleValue);
                  });
                },
                onValueChangeStart: (_) {
                  setState(() {
                    listenOnlyUserInteraction = true;
                  });
                },
                // onValueChanging: (newValue) {},
                markerHeight: 16.0,
                markerWidth: 16.0,
                markerType: MarkerType.circle,
                color: Colors.white,
                borderWidth: 2,
                borderColor: Colors.white54,
              ),
            ],
            // minutes
            annotations: [
              // start
              GaugeAnnotation(
                angle: 175,
                positionFactor: 1,
                widget: Text(
                  durationToString(widget.currentPosition),
                  style: styleW400(context,
                      fontSize: FontSize.f10, color: Colors.white,),
                ),
              ),
              // end
              GaugeAnnotation(
                angle: 365,
                positionFactor: 1,
                widget: Text(
                  durationToString(widget.duration),
                  style: styleW400(context,
                      fontSize: FontSize.f10, color: Colors.white,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
