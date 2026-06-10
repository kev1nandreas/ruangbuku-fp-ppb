enum BookStatus { private, publicPending, publicApproved, publicRejected }

class BookModel {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String description;
  final bool isPublic;
  BookStatus statusVerifikasi;
  final String ownerId;
  final String ownerName;
  final String imageUrl;
  final String distance;
  String condition;

  BookModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.description,
    required this.isPublic,
    required this.statusVerifikasi,
    required this.ownerId,
    required this.ownerName,
    required this.imageUrl,
    required this.distance,
    required this.condition,
  });

  BookModel copyWith({
    BookStatus? statusVerifikasi,
    String? condition,
  }) {
    return BookModel(
      id: id,
      isbn: isbn,
      title: title,
      author: author,
      description: description,
      isPublic: isPublic,
      statusVerifikasi: statusVerifikasi ?? this.statusVerifikasi,
      ownerId: ownerId,
      ownerName: ownerName,
      imageUrl: imageUrl,
      distance: distance,
      condition: condition ?? this.condition,
    );
  }
}
