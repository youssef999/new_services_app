import 'package:flutter/material.dart';

void appMessage({
  required String text,
  required bool fail,
  required BuildContext context,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fail ? Colors.redAccent : Colors.greenAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            fail ? Icons.error : Icons.check_circle,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
