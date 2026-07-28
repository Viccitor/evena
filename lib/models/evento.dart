// lib/models/evento.dart
class Evento {
  final String id;
  final String titulo;
  final String imagemUrl;
  final String dia;
  final String mes;
  final String hora;
  final String local;
  final String descricao;

  Evento({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.dia,
    required this.mes,
    required this.hora,
    required this.local,
    required this.descricao,
  });
}