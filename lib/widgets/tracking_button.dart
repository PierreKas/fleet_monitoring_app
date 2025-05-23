import 'package:fleet_monitoring_app/utils/colors.dart';
import 'package:flutter/material.dart';

class TrackingButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isTracking;
  const TrackingButton(
      {super.key, required this.onPressed, required this.isTracking});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isTracking ? Icons.stop : Icons.play_arrow,
        color: isTracking ? MyColors.red : MyColors.green,
      ),
      label: Text(
        isTracking ? 'Stop Tracking' : 'Track The Car',
        style: TextStyle(
          color: isTracking ? MyColors.red : MyColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isTracking ? MyColors.red : MyColors.green,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
