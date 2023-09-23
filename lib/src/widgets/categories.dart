import 'package:flutter/material.dart';

class MyExpansionTile extends StatefulWidget {
  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  bool _isExpanded = false; // Valor inicial para rastrear si el ExpansionTile está expandido.
  int? _selectedValue;     // Valor para rastrear el RadioListTile seleccionado.

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: _isExpanded,
      title: Text('Elige una opción'),
      onExpansionChanged: (bool expanding) => setState(() {
        _isExpanded = expanding;
      }),
      children: <Widget>[
        RadioListTile<int>(
          title: Text('Opción 1'),
          value: 1,
          groupValue: _selectedValue,
          onChanged: (int? value) {
            setState(() {
              _selectedValue = value;
              _isExpanded = false; // Contrae el ExpansionTile.
            });
          },
        ),
        RadioListTile<int>(
          title: Text('Opción 2'),
          value: 2,
          groupValue: _selectedValue,
          onChanged: (int? value) {
            setState(() {
              _selectedValue = value;
              _isExpanded = false; // Contrae el ExpansionTile.
            });
          },
        ),
        // ... Puedes agregar más RadioListTile si lo deseas.
      ],
    );
  }
}