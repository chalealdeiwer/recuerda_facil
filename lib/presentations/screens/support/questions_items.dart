import 'package:flutter/material.dart';

class Question {
  final String title;
  final String answer;
  final IconData icon;
  final DateTime dateAdded;

  Question({
    required this.title,
    required this.answer,
    required this.icon,
    required this.dateAdded,
  });
}

List<Question> questions = [
  Question(
    title: '¿Cómo puedo crear una actividad para recordar?',
    answer: 'Para crear una actividad, ve a la sección de "Agregar actividad", llena los detalles y presiona "Guardar".',
    icon: Icons.add_circle_outline,
    dateAdded: DateTime(2023, 10, 3),
  ),
  Question(
    title: '¿Cómo puedo editar o eliminar una actividad programada?',
    answer: 'Mantén pulsado sobre la actividad que deseas editar y para eliminar desliza hacia la izquierda.',
    icon: Icons.edit,
    dateAdded: DateTime(2023, 9, 15),
  ),
  Question(
    title: '¿Cómo puedo configurar notificaciones para mis actividades?',
    answer: 'Ve a la sección de "Configuración de notificaciones" en la configuración de la app y elige tus preferencias.',
    icon: Icons.notifications,
    dateAdded: DateTime(2023, 8, 12),
  ),
  Question(
    title: '¿Cómo puedo agregar un contacto de emergencia?',
    answer: 'En la sección de "Contactos de emergencia", pulsa "Agregar" y llena la información requerida.',
    icon: Icons.person_add,
    dateAdded: DateTime(2023, 7, 23),
  ),
  Question(
    title: '¿Qué hago si olvidé mi contraseña o no puedo iniciar sesión?',
    answer: 'Pulsa en "Olvidé mi contraseña" en la pantalla de inicio de sesión y sigue las instrucciones.',
    icon: Icons.lock_open,
    dateAdded: DateTime(2023, 6, 18),
  ),
  Question(
    title: '¿Cómo puedo cambiar el tema de la app?',
    answer: 'Ve a la sección de "Apariencia" en la configuración de la app y selecciona tu preferencia.',
    icon: Icons.color_lens,
    dateAdded: DateTime(2023, 5, 10),
  ),
  Question(
    title: '¿Puedo compartir mis actividades con otros?',
    answer: 'Sí, simplemente selecciona la opción de compartir en el menu desplegable.',
    icon: Icons.share,
    dateAdded: DateTime(2023, 4, 8),
  ),
  Question(
    title: '¿Cómo puedo ver el historial de mis actividades?',
    answer: 'Ve a la sección de "Historial" en el menú principal para ver todas tus actividades pasadas.',
    icon: Icons.history,
    dateAdded: DateTime(2023, 3, 14),
  ),
  Question(
    title: '¿Cómo puedo buscar una actividad específica?',
    answer: 'Utiliza la barra de búsqueda en la parte superior de la pantalla y escribe el nombre de la actividad.',
    icon: Icons.search,
    dateAdded: DateTime(2023, 2, 20),
  ),
  Question(
    title: '¿Cómo puedo categorizar mis actividades?',
    answer: 'Al crear o editar una actividad, selecciona una categoría del menú deslizable.',
    icon: Icons.category,
    dateAdded: DateTime(2023, 1, 6),
  ),
  Question(
    title: '¿Cómo puedo ver las actividades programadas para una fecha futura?',
    answer: 'Ve al calendario y selecciona la fecha para ver las actividades programadas.',
    icon: Icons.calendar_today,
    dateAdded: DateTime(2022, 12, 30),
  ),
  Question(
    title: '¿Puedo sincronizar mis actividades con otras aplicaciones?',
    answer: 'Sí, ve a la sección de "Sincronización" en la configuración de la app para conectar con otras aplicaciones.',
    icon: Icons.sync,
    dateAdded: DateTime(2022, 11, 17),
  ),
  Question(
    title: '¿Qué información se necesita para agregar un contacto de emergencia?',
    answer: 'Necesitarás el nombre, número de teléfono y, opcionalmente, una dirección de correo electrónico.',
    icon: Icons.contact_phone,
    dateAdded: DateTime(2022, 10, 4),
  ),
  Question(
    title: '¿Cómo puedo modificar mi perfil?',
    answer: 'Ve a la sección de "Perfil" en el menú principal y pulsa en "Editar perfil".',
    icon: Icons.person,
    dateAdded: DateTime(2022, 9, 22),
  ),
  Question(
    title: '¿Cómo puedo ver y editar las notas adjuntas a una actividad?',
    answer: 'Pulsa en la actividad y luego en el icono de notas para ver y editar las notas adjuntas.',
    icon: Icons.note,
    dateAdded: DateTime(2022, 8, 11),
  ),
  Question(
    title: '¿Cómo puedo cambiar la contraseña de mi cuenta?',
    answer: 'Ve a la sección de "Seguridad" en la configuración de la app y sigue las instrucciones para cambiar la contraseña.',
    icon: Icons.vpn_key,
    dateAdded: DateTime(2022, 7, 19),
  ),
  Question(
    title: '¿Cómo puedo cerrar sesión en la app?',
    answer: 'Entra en el menu desplegable y luego en "Cerrar sesión".',
    icon: Icons.logout,
    dateAdded: DateTime(2022, 6, 30),
  ),


];
