import 'package:flutter/material.dart';

class MenuItem{
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon
  });
}

const appMenuItems =<MenuItem>[
  MenuItem(title: 'Vista General', subTitle: 'Página de Recordatorios', link: '/home/1', icon: Icons.home),
  MenuItem(title: 'Calendario', subTitle: 'Calendario Recordatorios', link: '/home/2', icon: Icons.calendar_today),
  MenuItem(title: 'Más', subTitle: 'Mas servicios', link: '/home/0', icon: Icons.add_circle_outline),
  MenuItem(title: 'Personas', subTitle: 'Encuentra personas', link: '/community', icon: Icons.people),
  MenuItem(title: 'Compartir', subTitle: 'Compartir Recordatorios', link: '/shared', icon: Icons.share_rounded),
  MenuItem(title: 'Mi cuenta', subTitle: 'Gestionar mi cuenta', link: '/account', icon: Icons.account_circle_rounded),
  //todo: falta
  MenuItem(title: 'Guía de Usuario', subTitle: 'Una guía detallada', link: '/user_guide', icon: Icons.help_center_rounded),
  //
  MenuItem(title: 'Configuración', subTitle: 'Configuraciones Generales', link: '/settings', icon: Icons.settings),
  MenuItem(title: 'Apariencia', subTitle: 'Apariencia de la aplicación', link: '/appearance', icon: Icons.color_lens_rounded),

  MenuItem(title: 'Privacidad', subTitle: 'Gestión Privacidad', link: '/privacy', icon: Icons.admin_panel_settings),
  MenuItem(title: 'Soporte y Ayuda', subTitle: 'Soporte y Ayuda de la aplicación', link: '/support', icon: Icons.support_agent_rounded),
  MenuItem(title: 'Acerca de:', subTitle: 'Acerca de la aplicación', link: '/about', icon: Icons.info_outline),
  MenuItem(title: 'Pruebas', subTitle: 'Pruebas', link: '/test', icon: Icons.tag_faces_outlined),
  MenuItem(title: 'Mas Funciones', subTitle: 'Pruebas', link: '/more_functions', icon: Icons.emoji_people_rounded),








];