import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const RoundedButton(
      {Key? key, required this.title, required this.onTap, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 220,
        decoration: BoxDecoration(
            color: Colors.pink.shade300,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            title,
            style: const TextStyle(
                fontFamily: 'VariableFont',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
