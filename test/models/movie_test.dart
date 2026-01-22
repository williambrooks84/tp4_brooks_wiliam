import 'package:flutter_test/flutter_test.dart';
import 'package:tp4_brooks_william/models/movie.dart';

void main() {
  group('MovieListItem Tests', () {
    test('Parse correctement un JSON valide', () {
      // Arrange : Préparer des données JSON
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'year': 2024,
      };

      // Act : Créer un MovieListItem à partir du JSON
      final movie = MovieListItem.fromJson(json);

      // Assert : Vérifier que les valeurs sont correctes
      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.year, 2024);
    });

    test('Gère les valeurs nulles avec des valeurs par défaut', () {
      // JSON avec des champs manquants
      final json = {
        'id': 456,
      };

      final movie = MovieListItem.fromJson(json);

      // Vérifie que les valeurs par défaut sont appliquées
      expect(movie.id, 456);
      expect(movie.title, 'Sans titre');
      expect(movie.year, 0);
    });

    // ... et bien plus ! Crée d'autres tests pertinents :
    // - Teste d'autres cas limites
        test('Gère un JSON partiel pour Movie (cas limite)', () {
      final json = {
        'title': null,
        'year': null,
        'plot_overview': null,
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 0);
      expect(movie.title, 'Sans titre');
      expect(movie.year, 0);
      expect(movie.plotOverview, 'Aucune description disponible');
      expect(movie.genreNames, isEmpty);
    });

    // - Teste le parsing du modèle Movie complet
    test('Parse correctement un Movie complet', () {
      final json = {
        'id': 7,
        'title': 'Full Movie',
        'plot_overview': 'Synopsis complet',
        'year': 2020,
        'poster': 'https://example.com/poster.jpg',
        'backdrop': 'https://example.com/backdrop.jpg',
        'user_rating': 8.5,
        'genre_names': ['Action', 'Sci-Fi'],
        'trailer': 'https://www.youtube.com/watch?v=s2XXEbtT1fo',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 7);
      expect(movie.title, 'Full Movie');
      expect(movie.plotOverview, 'Synopsis complet');
      expect(movie.year, 2020);
      expect(movie.poster, 'https://example.com/poster.jpg');
      expect(movie.backdrop, 'https://example.com/backdrop.jpg');
      expect(movie.userRating, 8.5);
      expect(movie.genreNames, ['Action', 'Sci-Fi']);
      expect(movie.trailer, 'https://www.youtube.com/watch?v=s2XXEbtT1fo');
    });

    // - Teste le getter posterUrl avec et sans poster
    test('posterUrl retourne un placeholder si poster est null', () {
      final json = {
        'id': 1,
        'title': 'No Poster',
        'year': 2024,
      };

      final movie = Movie.fromJson(json);

      expect(movie.poster, isNull);
      expect(movie.posterUrl, 'https://placehold.co/600x400');
    });

    test('posterUrl retourne le poster quand il est défini', () {
      final json = {
        'id': 2,
        'title': 'Has Poster',
        'year': 2024,
        'poster': 'https://example.com/poster.jpg',
      };

      final movie = Movie.fromJson(json);

      expect(movie.posterUrl, 'https://example.com/poster.jpg');
    });
  });
}