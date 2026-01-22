import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp4_brooks_william/models/movie.dart';
import 'package:tp4_brooks_william/pages/movie_list_page.dart' show MovieListCard;
import 'package:tp4_brooks_william/services/movie_service.dart';

void main() {
  group('MovieListCard Widget Tests', () {
    testWidgets("Affiche correctement le titre et l'année d'un film",
        (WidgetTester tester) async {
      // Créer un film de test
      final testMovie = MovieListItem(
        id: 1,
        title: 'Test Movie',
        year: 2024,
      );

      // Construire le widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Assert : Vérifier que le titre et l'année sont affichés
      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Année : 2024'), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite quand le film est favori",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Favorite Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: true,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Vérifier que l'icône favorite pleine est affichée
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    // ... et bien plus ! Crée d'autres tests de widgets :
    // - Teste l'icône favorite_border quand isFavorite est false
        testWidgets("Affiche l'icône favorite_border quand le film n'est pas favori",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Not Favorite',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
    
    // - Teste l'affichage du CircleAvatar avec la première lettre
    testWidgets("Affiche la première lettre du titre dans le CircleAvatar",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Avatar',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    // - Teste la couleur du CircleAvatar selon la première lettre
    testWidgets("Applique la bonne couleur au CircleAvatar",
        (WidgetTester tester) async {
      // 'A' => ASCII 65, 65 % 10 = 5 => Colors.blue
      final testMovie = MovieListItem(
        id: 1,
        title: 'A Movie',
        year: 2024,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, Colors.blue);
    });
  });
}

// Mock (simulation) du MovieService pour les tests
// Permet de créer un MovieListCard sans avoir besoin d'une vraie connexion API
// Dans ces tests, on ne teste que l'affichage, donc ces méthodes ne sont jamais appelées
class MockMovieService extends MovieService {
  @override
  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    return []; // Retourne une liste vide (non utilisée dans ces tests)
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    // Lance une erreur car non implémenté (non utilisé dans ces tests)
    throw UnimplementedError();
  }
}