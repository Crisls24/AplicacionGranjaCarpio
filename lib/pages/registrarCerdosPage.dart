import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db_helper.dart';
import 'dart:async';
import 'package:intl/intl.dart';


class RegistrarCerdo extends StatefulWidget {
  const RegistrarCerdo({Key? key}) : super(key: key);

  @override
  _RegistrarCerdoState createState() => _RegistrarCerdoState();
}

class _RegistrarCerdoState extends State<RegistrarCerdo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _alimentacionController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String? _etapaSeleccionada;
  final List<String> _etapas = ['Lactante', 'Gestante', 'Crecimiento'];

  Future<bool> _verificarIdUnico(String id) async {
    final existe = await _dbHelper.existeCerdo(id);
    return !existe;
  }

  Future<void> _registrarCerdo() async {
    if (_formKey.currentState!.validate()) {
      if (_etapaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Debe seleccionar una etapa"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      bool idUnico = await _verificarIdUnico(_idController.text);
      if (!idUnico) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("El ID ya está registrado"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _dbHelper.addCerdo(
        _idController.text,
        double.parse(_pesoController.text),
        _fechaNacimientoController.text,
        _etapaSeleccionada ?? '',
        _razaController.text,
        _alimentacionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cerdo registrado exitosamente!"),
          backgroundColor: Colors.green,
        ),
      );
      _idController.clear();
      _pesoController.clear();
      _fechaNacimientoController.clear();
      _razaController.clear();
      _alimentacionController.clear();
      setState(() {
        _etapaSeleccionada = null;
      });
      Navigator.pop(context);
    }
  }

  String? _validarFecha(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obligatorio";
    }
    try {
      DateTime fecha = DateFormat("yyyy-MM-dd").parseStrict(value);
      DateTime hoy = DateTime.now();
      if (fecha.isAfter(hoy)) {
        return "La fecha no puede estar en el futuro";
      }
    } catch (e) {
      return "Formato incorrecto. Usa YYYY-MM-DD";
    }
    return null;
  }

  Future<void> _seleccionarFecha() async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', ''), // Cambiar a español
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Añadir Cerdo",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: "Número de Identificación",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _pesoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: "Peso (KG)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _fechaNacimientoController,
                        decoration: InputDecoration(
                          labelText: "Fecha de Nacimiento",
                          hintText: "YYYY-MM-DD",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: _seleccionarFecha,
                        validator: _validarFecha,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _razaController,
                  decoration: InputDecoration(
                    labelText: "Raza",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _alimentacionController,
                  decoration: InputDecoration(
                    labelText: "Alimentación",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
                ),
                SizedBox(height: 10),
                Text("Etapa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  children: _etapas.map((etapa) => RadioListTile<String>(
                    title: Text(etapa),
                    value: etapa,
                    groupValue: _etapaSeleccionada,
                    onChanged: (value) {
                      setState(() {
                        _etapaSeleccionada = value;
                      });
                    },
                  )).toList(),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _registrarCerdo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Añadir Cerdito", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




