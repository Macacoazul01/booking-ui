import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat diaFormat = DateFormat('dd/MM');
final DateFormat nomeFormat = DateFormat('EEE');

class CelulaHora extends StatefulWidget {
  final String hora;
  final bool isSelected;
  final VoidCallback onSelect;

  const CelulaHora({
    Key? key,
    required this.hora,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  _CelulaHoraState createState() => _CelulaHoraState();
}

class _CelulaHoraState extends State<CelulaHora> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        child: Center(
          child: Text(
            widget.hora,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
