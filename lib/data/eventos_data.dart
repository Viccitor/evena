import 'package:evena/models/evento.dart';

final List<Evento> eventos = [
  Evento(
    id: '1',
    titulo: 'Marketing Digital Experience 2026',
    imagemUrl: 'assets/images/evento1.jpg',
    inicio: DateTime(2026, 9, 12, 19, 0),
    fim: DateTime(2026, 9, 12, 22, 0),
    local: 'Centro de Convenções Paulista',
    endereco: 'Av. Paulista, 1578 - Bela Vista, São Paulo - SP',
    descricao:
        'Uma noite de conteúdo prático sobre marketing digital, conteúdo, tráfego pago e construção de marca com profissionais do mercado.',
    formato: 'Presencial',
    categoria: 'Networking',
  ),
  Evento(
    id: '2',
    titulo: 'Festival Aurora',
    imagemUrl: 'assets/images/evento2.jpeg',
    inicio: DateTime(2026, 9, 20, 16, 0),
    fim: DateTime(2026, 9, 20, 23, 30),
    local: 'Parque Villa-Lobos',
    endereco:
        'Av. Prof. Fonseca Rodrigues, 2001 - Alto de Pinheiros, São Paulo - SP',
    descricao:
        'Festival ao ar livre com música, arte, gastronomia e experiências para curtir com os amigos.',
    formato: 'Presencial',
    categoria: 'Música',
  ),
  Evento(
    id: '3',
    titulo: 'Future Tech Summit',
    imagemUrl: 'assets/images/evento3.webp',
    inicio: DateTime(2026, 10, 3, 9, 0),
    fim: DateTime(2026, 10, 3, 18, 0),
    local: 'Expo Center Norte',
    endereco: 'Rua José Bernardo Pinto, 333 - Vila Guilherme, São Paulo - SP',
    descricao:
        'Tecnologia, inteligência artificial, desenvolvimento e produtos digitais em um dia inteiro de palestras e networking.',
    formato: 'Presencial',
    categoria: 'Tecnologia',
  ),
  Evento(
    id: '4',
    titulo: 'Game Dev Night',
    imagemUrl: 'assets/images/evento4.webp',
    inicio: DateTime(2026, 10, 10, 18, 30),
    fim: DateTime(2026, 10, 10, 22, 0),
    local: 'Arena Hub',
    endereco: 'Al. Rio Claro, 241 - Bela Vista, São Paulo - SP',
    descricao:
        'Encontro para quem gosta de games, programação e criação de experiências interativas.',
    formato: 'Presencial',
    categoria: 'Workshop',
  ),
  Evento(
    id: '5',
    titulo: 'Sabores de São Paulo',
    imagemUrl: 'assets/images/evento1.jpg',
    inicio: DateTime(2026, 10, 18, 12, 0),
    fim: DateTime(2026, 10, 18, 20, 0),
    local: 'Mercado Municipal',
    endereco: 'Rua da Cantareira, 306 - Centro Histórico, São Paulo - SP',
    descricao:
        'Experiência gastronômica com chefs convidados, degustações e oficinas rápidas.',
    formato: 'Presencial',
    categoria: 'Gastronomia',
  ),
  Evento(
    id: '6',
    titulo: 'Conexão Empreendedora',
    imagemUrl: 'assets/images/evento2.jpeg',
    inicio: DateTime(2026, 10, 24, 14, 0),
    fim: DateTime(2026, 10, 24, 19, 0),
    local: 'Cubo Itaú',
    endereco: 'Alameda Vicente Pinzon, 54 - Vila Olímpia, São Paulo - SP',
    descricao:
        'Palestras, cases e rodas de conversa para quem quer tirar projetos do papel e conhecer novas pessoas.',
    formato: 'Presencial',
    categoria: 'Networking',
  ),
  Evento(
    id: '7',
    titulo: 'Teatro: Depois da Meia-Noite',
    imagemUrl: 'assets/images/evento3.webp',
    inicio: DateTime(2026, 11, 7, 20, 0),
    fim: DateTime(2026, 11, 7, 22, 0),
    local: 'Teatro Gazeta',
    endereco: 'Av. Paulista, 900 - Bela Vista, São Paulo - SP',
    descricao:
        'Uma peça contemporânea sobre escolhas, encontros e tudo aquilo que muda quando a cidade desacelera.',
    formato: 'Presencial',
    categoria: 'Teatro',
  ),
  Evento(
    id: '8',
    titulo: 'Arena Esports Weekend',
    imagemUrl: 'assets/images/evento4.webp',
    inicio: DateTime(2026, 11, 15, 10, 0),
    fim: DateTime(2026, 11, 15, 19, 0),
    local: 'Shopping Center Norte',
    endereco: 'Travessa Casalbuono, 120 - Vila Guilherme, São Paulo - SP',
    descricao:
        'Campeonatos, desafios, comunidade gamer e espaços para testar jogos e conhecer criadores.',
    formato: 'Presencial',
    categoria: 'Workshop',
  ),
];
