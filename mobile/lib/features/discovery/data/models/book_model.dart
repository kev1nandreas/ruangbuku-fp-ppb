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
  final List<String> genreIds;

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
    this.genreIds = const [],
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
      genreIds: genreIds,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    BookStatus parseStatus(String status) {
      if (status == 'private') return BookStatus.private;
      if (status == 'need_verification') return BookStatus.publicPending;
      if (status == 'approved') return BookStatus.publicApproved;
      if (status == 'rejected') return BookStatus.publicRejected;
      return BookStatus.private;
    }

    // Safety check for users array
    bool isPublic = false;
    String ownerId = '';
    String ownerName = 'Unknown';
    if (json['users'] != null && json['users'] is List && json['users'].isNotEmpty) {
      final user = json['users'][0];
      ownerId = user['id']?.toString() ?? '';
      ownerName = user['name'] ?? 'Unknown';
      if (user['pivot'] != null) {
        isPublic = user['pivot']['isPublic'] == 1 || user['pivot']['isPublic'] == true;
      }
    }

    return BookModel(
      id: json['id']?.toString() ?? '',
      isbn: json['isbn'] ?? '',
      title: json['title'] ?? 'Unknown',
      author: json['author'] ?? 'Unknown',
      description: json['description'] ?? '',
      isPublic: isPublic,
      statusVerifikasi: parseStatus(json['statusVerifikasi'] ?? ''),
      ownerId: ownerId,
      ownerName: ownerName,
      imageUrl: json['coverImageUrl'] ?? 'https://picsum.photos/200/300',
      distance: '0 km away',
      condition: 'Good',
      genreIds: (json['genres'] as List?)?.map((g) => g['id'].toString()).toList() ?? [],
    );
  }
}
