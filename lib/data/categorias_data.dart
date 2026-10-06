/// Categoria de evento exibida na home e usada como filtro na pesquisa.
/// [nome] precisa ser igual ao campo `categoria` dos eventos
/// (a comparação ignora maiúsculas e acentos).
class CategoriaEvento {
  final String nome;
  final String imagem;

  const CategoriaEvento({required this.nome, required this.imagem});
}

const List<CategoriaEvento> categoriasEventos = [
  CategoriaEvento(nome: 'Networking', imagem: 'assets/images/negocios.png'),
  CategoriaEvento(nome: 'Música', imagem: 'assets/images/shows.png'),
  CategoriaEvento(nome: 'Teatro', imagem: 'assets/images/teatro.png'),
  CategoriaEvento(nome: 'Festival', imagem: 'assets/images/viagem.png'),
  CategoriaEvento(nome: 'Educação', imagem: 'assets/images/educacao.png'),
  CategoriaEvento(nome: 'Infantil', imagem: 'assets/images/infantil.png'),
  CategoriaEvento(nome: 'Esportes', imagem: 'assets/images/esportes.png'),
  CategoriaEvento(nome: 'Workshop', imagem: 'assets/images/games.png'),
  CategoriaEvento(nome: 'Tecnologia', imagem: 'assets/images/tech.png'),
  CategoriaEvento(nome: 'Gastronomia', imagem: 'assets/images/gastronomia.png'),
];