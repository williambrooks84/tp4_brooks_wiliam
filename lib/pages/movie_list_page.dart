import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_page.dart';

const _appGradient = LinearGradient(
  colors: [Color(0xFF050810), Color.fromARGB(255, 119, 117, 124)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class MovieListPage extends StatefulWidget {
  final MovieService movieService;

  const MovieListPage({super.key, required this.movieService});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<MovieListItem> movies = [];
  bool isLoading = true;
  String? errorMessage;
  final Set<int> favorites = {};

  // cache genres fetched from detail endpoint
  final Map<int, List<String>> _genresById = {};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedMovies = await widget.movieService.getMovies(limit: 30);
      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });

      // fetch genres using the same detail logic
      for (final item in loadedMovies) {
        _loadGenresFor(item.id);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadGenresFor(int movieId) async {
    if (_genresById.containsKey(movieId)) return;
    try {
      final details = await widget.movieService.getMovieDetails(movieId);
      if (!mounted) return;
      setState(() {
        _genresById[movieId] = details.genreNames;
      });
    } catch (_) {
      // ignore per-item failures
    }
  }

  void toggleFavorite(int movieId) {
    setState(() {
      favorites.contains(movieId)
          ? favorites.remove(movieId)
          : favorites.add(movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Films récents'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMovies),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FavoritesPage(
                  movieService: widget.movieService,
                  favorites: favorites,
                  movies: movies,
                  toggleFavorite: toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: _appGradient),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadMovies,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) => MovieListCard(
                    movieService: widget.movieService,
                    movie: movies[index],
                    isFavorite: favorites.contains(movies[index].id),
                    onFavoriteTap: () => toggleFavorite(movies[index].id),
                    genres: _genresById[movies[index].id] ?? const [],
                  ),
                ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  final MovieService movieService;
  final Set<int> favorites;
  final List<MovieListItem> movies;
  final Function(int) toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.movieService,
    required this.favorites,
    required this.movies,
    required this.toggleFavorite,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  void _removeFavorite(int movieId) {
    widget.toggleFavorite(movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = widget.movies
        .where((movie) => widget.favorites.contains(movie.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Films favoris'),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: _appGradient),
        child: SafeArea(
          child: favoriteMovies.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun film favori ajouté.',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                )
              : ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) => MovieListCard(
                    movieService: widget.movieService,
                    movie: favoriteMovies[index],
                    isFavorite: true,
                    onFavoriteTap: () =>
                        _removeFavorite(favoriteMovies[index].id),
                    favoriteIcon: Icons.delete,
                  ),
                ),
        ),
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  final MovieService movieService;
  final MovieListItem movie;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final IconData? favoriteIcon;

  // add genres override
  final List<String> genres;

  const MovieListCard({
    super.key,
    required this.movieService,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.favoriteIcon,
    this.genres = const [],
  });

  // Génère une couleur basée sur la première lettre du titre
  Color _getColorFromLetter(String title) {
    if (title.isEmpty) return Colors.grey;

    final letter = title[0].toUpperCase();
    final colorIndex = letter.codeUnitAt(0) % 10;

    const colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.orange,
      Colors.brown,
    ];

    return colors[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MovieDetailPage(movieService: movieService, movieId: movie.id),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getColorFromLetter(movie.title),
            child: Text(
              movie.title.isNotEmpty ? movie.title[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          title: Text(
            movie.title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (genres.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  genres.take(3).join(', '),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
              const SizedBox(height: 6),
              Text(
                '${movie.year}',
                style: const TextStyle(
                  color: Color.fromRGBO(221, 37, 40, 1),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          isThreeLine: genres.isNotEmpty,
          trailing: IconButton(
            icon: Icon(
              favoriteIcon ??
                  (isFavorite ? Icons.favorite : Icons.favorite_border),
              color: isFavorite && favoriteIcon == null
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: onFavoriteTap,
          ),
        ),
      ),
    );
  }
}
