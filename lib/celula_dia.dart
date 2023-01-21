import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat diaFormat = DateFormat('dd/MM');
final DateFormat nomeFormat = DateFormat('EEE');

class CelulaDia extends StatefulWidget {
  final DateTime dia;
  final bool isSelected;
  final VoidCallback onSelect;

  const CelulaDia({
    Key? key,
    required this.dia,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _CelulaDiaState createState() => _CelulaDiaState();
}

class _CelulaDiaState extends State<CelulaDia> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        onPressed: () {
          widget.onSelect();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              widget.isSelected ? Colors.green[100] : Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              diaFormat.format(widget.dia),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              nomeFormat.format(widget.dia),
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
