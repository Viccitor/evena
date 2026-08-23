class Evento {
  final String id;
  final String titulo;
  final String imagemUrl;
  final DateTime inicio;
  final DateTime fim;
  final String local;
  final String endereco;
  final String descricao;
  final String formato;
  final String categoria;
  final double latitude;
  final double longitude;

  const Evento({
    required this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.inicio,
    required this.fim,
    required this.local,
    required this.endereco,
    required this.descricao,
    required this.formato,
    required this.categoria,
    required this.latitude,
    required this.longitude,
  });

  String get dia => inicio.day.toString().padLeft(2, '0');

  String get mes {
    const meses = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ',
    ];
    return meses[inicio.month - 1];
  }

  String get hora =>
      '${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}';
}