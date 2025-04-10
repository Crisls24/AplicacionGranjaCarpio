import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<String>> _events; // Mapa para almacenar eventos por fecha
  late DateTime _selectedDay; // Día seleccionado
  late DateTime _focusedDay; // Día enfocado en el calendario

  @override
  void initState() {
    super.initState();
    _events = {}; // Inicializar el mapa de eventos
    _selectedDay = DateTime.now(); // Día seleccionado por defecto
    _focusedDay = DateTime.now(); // Día enfocado por defecto
  }

  // Método para agregar un evento (puedes modificarlo según tus necesidades)
  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) {
        String eventDescription = '';

        return AlertDialog(
          title: const Text('Agregar Evento'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Descripción del evento'),
            onChanged: (value) {
              eventDescription = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (eventDescription.isNotEmpty) {
                  setState(() {
                    if (_events[_selectedDay] != null) {
                      _events[_selectedDay]!.add(eventDescription);
                    } else {
                      _events[_selectedDay] = [eventDescription];
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Inseminación'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 50),
            iconSize: 90,
            color: Colors.deepPurple,
            onPressed: _addEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<String>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) => _events[day] ?? [], // Cargar eventos del día
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay; // Actualizar el día seleccionado
                _focusedDay = focusedDay; // Actualizar el día enfocado
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay; // Cambiar la página del calendario
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: _events[_selectedDay]?.map((event) => ListTile(
                title: Text(event),
              )).toList() ?? [
                const ListTile(title: Text('No hay eventos para este día.')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
