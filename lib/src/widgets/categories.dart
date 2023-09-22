import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  static const String name = 'ui_controls_screen';
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Controls'),
      ),
      body: const _CategoriesWidget(),
    );
  }
}

class _CategoriesWidget extends StatefulWidget {
  const _CategoriesWidget();

  @override
  State<_CategoriesWidget> createState() => _CategoriesWidgetState();
}

enum Transportation { car, boat, plane, submarine }

class _CategoriesWidgetState extends State<_CategoriesWidget> {
  bool isDeveloper = true;
  bool wantsBreakfast= false;
  bool wantsLunch= false;
  bool wantsDinner= false;


  Transportation selectTransportation = Transportation.car;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        SwitchListTile(
          value: isDeveloper,
          title: const Text("Developer Mode"),
          subtitle: const Text("Controles adicionales"),
          onChanged: (value) {
            
            setState(() {
              isDeveloper = !isDeveloper;
            });
          },
        ),
        ExpansionTile(
          title: const Text("Vehículo de transporte"),
          subtitle: Text("$selectTransportation"),
          children: [
            RadioListTile(
              title: const Text("By Car"),
              subtitle: const Text("Viajar por carro"),
              value: Transportation.car,
              groupValue: selectTransportation,
              onChanged: (value) {
                setState(() {
                  selectTransportation = Transportation.car;
                });
              },
            ),
            RadioListTile(
              title: const Text("By boat"),
              subtitle: const Text("Viajar por barco"),
              value: Transportation.boat,
              groupValue: selectTransportation,
              onChanged: (value) {
                setState(() {
                  selectTransportation = Transportation.boat;
                });
              },
            ),
            RadioListTile(
              title: const Text("By plane"),
              subtitle: const Text("Viajar por avion"),
              value: Transportation.plane,
              groupValue: selectTransportation,
              onChanged: (value) {
                setState(() {
                  selectTransportation = Transportation.plane;
                });
              },
            ),
            RadioListTile(
              title: const Text("By Submarine"),
              subtitle: const Text("Viajar por Submarino"),
              value: Transportation.submarine,
              groupValue: selectTransportation,
              onChanged: (value) {
                setState(() {
                  selectTransportation = Transportation.submarine;
                });
              },
            )
          ],
        ),
      
      CheckboxListTile(
        title: const Text("¿Quieres desayuno?"),
        value: wantsBreakfast,
        onChanged: (value) {
          
          setState(() {
            wantsBreakfast = !wantsBreakfast;
          });
        
        },),
        CheckboxListTile(
        title: const Text("¿Quieres almuerzo?"),
        value: wantsLunch,
        onChanged: (value) {
          
          setState(() {
            wantsLunch = !wantsLunch;
          });
        
        },),
        CheckboxListTile(
        title: const Text("¿Quieres cena?"),
        value: wantsDinner,
        onChanged: (value) {
          
          setState(() {
            wantsDinner = !wantsDinner;
          });
        
        },)
      ],
    );
  }
}
