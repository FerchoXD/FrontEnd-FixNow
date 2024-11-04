import 'package:flutter/material.dart';

class StyleButtonFacebook {
  static Widget buildButton(double scaleFactor, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10 * scaleFactor),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor, vertical: 8 * scaleFactor),
        child: Row(
          children: [
            Image.asset(
              'assets/images/facebook.png',
              width: 30 * scaleFactor,
              height: 30 * scaleFactor,
            ),
            SizedBox(width: 10 * scaleFactor),
            Text(
              'Facebook',
              style: TextStyle(fontSize: 16 * scaleFactor),
            ),
          ],
        ),
      ),
    );
  }
}
