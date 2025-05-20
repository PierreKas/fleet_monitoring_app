import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';

class TrackingButton extends StatefulWidget {
  final void Function()? onPressed;
  final bool isTracking;
  const TrackingButton(
      {super.key, required this.onPressed, required this.isTracking});

  @override
  State<TrackingButton> createState() => _TrackingButtonState();
}

class _TrackingButtonState extends State<TrackingButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      icon: Icon(
        widget.isTracking ? Icons.stop : Icons.play_arrow,
        color: widget.isTracking ? MyColors.red : MyColors.green,
      ),
      label: Text(
        widget.isTracking ? 'Stop Tracking' : 'Track This Car',
        style: TextStyle(
          color: widget.isTracking ? MyColors.red : MyColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: widget.isTracking ? MyColors.red : MyColors.green,
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
