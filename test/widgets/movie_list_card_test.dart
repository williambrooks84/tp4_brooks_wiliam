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
        genreNames: ['Action', 'Drama'],
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
              genres: ['Action', 'Drama'],
            ),
          ),
        ),
      );

      // Assert : Vérifier que le titre et l'année sont affichés
      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite quand le film est favori",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Favorite Movie',
        year: 2024,
        genreNames: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: true,
              onFavoriteTap: () {},
              genres: [],
            ),
          ),
        ),
      );

      // Vérifier que l'icône favorite pleine est affichée
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets("Affiche l'icône favorite_border quand le film n'est pas favori",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Not Favorite',
        year: 2024,
        genreNames: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
              genres: [],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
    
    testWidgets("Affiche la première lettre du titre dans le CircleAvatar",
        (WidgetTester tester) async {
      final testMovie = MovieListItem(
        id: 1,
        title: 'Avatar',
        year: 2024,
        genreNames: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
              genres: [],
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets("Applique la bonne couleur au CircleAvatar",
        (WidgetTester tester) async {
      // 'A' => ASCII 65, 65 % 10 = 5 => Colors.blue
      final testMovie = MovieListItem(
        id: 1,
        title: 'A Movie',
        year: 2024,
        genreNames: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieListCard(
              movieService: MockMovieService(),
              movie: testMovie,
              isFavorite: false,
              onFavoriteTap: () {},
              genres: [],
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, Colors.blue);
    });
  });
}

class MockMovieService extends MovieService {
  @override
  Future<List<MovieListItem>> getMovies({int limit = 20}) async {
    return [];
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    throw UnimplementedError();
  }
}