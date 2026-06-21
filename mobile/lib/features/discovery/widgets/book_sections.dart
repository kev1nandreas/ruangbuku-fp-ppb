import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../data/models/genre_model.dart';
import 'popular_book_card.dart';
import 'recent_book_card.dart';

/// First genre name for [book], or '-' when it has none / is unknown.
String genreNameFor(BookModel book, List<GenreModel> genres) {
  if (book.genreIds.isEmpty) return '-';
  final match = genres.where((g) => g.id == book.genreIds.first);
  return match.isEmpty ? '-' : match.first.name;
}

/// Horizontal carousel of popular books shown on the home pages.
class PopularBooksRow extends StatelessWidget {
  final List<BookModel> books;
  final List<GenreModel> genres;

  const PopularBooksRow({
    super.key,
    required this.books,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        separatorBuilder: (_, _) => const SizedBox(width: RuangBukuSpacing.lg),
        itemBuilder: (context, index) {
          final bk = books[index];
          return PopularBookCard(
            bookId: bk.id,
            title: bk.title,
            author: bk.author,
            imageUrl: bk.imageUrl,
            genre: genreNameFor(bk, genres),
          );
        },
      ),
    );
  }
}

/// Vertical list of recently added books shown on the home pages.
class RecentBooksList extends StatelessWidget {
  final List<BookModel> books;
  final List<GenreModel> genres;

  /// Returns true when the book is currently out on loan (drives availability).
  final bool Function(BookModel book) isOnLoan;

  const RecentBooksList({
    super.key,
    required this.books,
    required this.genres,
    required this.isOnLoan,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          const EdgeInsets.symmetric(horizontal: RuangBukuSpacing.marginMobile),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      separatorBuilder: (_, _) => const SizedBox(height: RuangBukuSpacing.md),
      itemBuilder: (context, index) {
        final bk = books[index];
        return RecentBookCard(
          bookId: bk.id,
          title: bk.title,
          author: bk.author,
          addedBy: bk.ownerName,
          avatarUrl: 'https://picsum.photos/seed/${bk.ownerId}/100/100',
          imageUrl: bk.imageUrl,
          isAvailable: !isOnLoan(bk),
          genre: genreNameFor(bk, genres),
        );
      },
    );
  }
}
