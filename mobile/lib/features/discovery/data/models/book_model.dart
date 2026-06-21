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
  final bool hasActiveBorrowing;

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
    this.hasActiveBorrowing = false,
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
      hasActiveBorrowing: hasActiveBorrowing,
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
      ownerName = user['name']?.toString() ?? 'Unknown';
      if (user['pivot'] != null) {
        final val = user['pivot']['is_public'] ?? user['pivot']['isPublic'];
        isPublic = val == 1 || val == true || val == '1' || val == 'true';
      }
    }
    // Fallback if is_public is at root
    if (!isPublic && json['is_public'] != null) {
      final val = json['is_public'];
      isPublic = val == 1 || val == true || val == '1' || val == 'true';
    }

    return BookModel(
      id: json['id']?.toString() ?? '',
      isbn: json['isbn'] ?? '',
      title: json['title']?.toString() ?? 'Unknown',
      author: json['author']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? '',
      isPublic: isPublic,
      statusVerifikasi: parseStatus(json['status_verifikasi'] ?? json['statusVerifikasi'] ?? ''),
      ownerId: ownerId,
      ownerName: ownerName,
      imageUrl: json['cover_image_url'] ?? json['coverImageUrl'] ?? 'https://picsum.photos/200/300',
      distance: '0 km away',
      condition: 'Good',
      genreIds: (json['genres'] as List?)
              ?.whereType<Map>()
              .map((g) => g['id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList() ??
          [],
      hasActiveBorrowing: (json['peminjaman'] as List?)?.isNotEmpty ?? false,
    );
  }

  factory BookModel.fromLocalMap(Map<String, dynamic> map) {
    BookStatus parseStatus(String? status) {
      if (status == 'approved') return BookStatus.publicApproved;
      if (status == 'need_verification') return BookStatus.publicPending;
      if (status == 'rejected') return BookStatus.publicRejected;
      return BookStatus.private;
    }

    return BookModel(
      id: map['id']?.toString() ?? '',
      isbn: map['isbn']?.toString() ?? '',
      title: map['title']?.toString() ?? 'No Title',
      author: map['author']?.toString() ?? 'Unknown',
      description: map['description']?.toString() ?? '',
      isPublic: map['isPublic'] == 1 || map['isPublic'] == true,
      statusVerifikasi: parseStatus(map['statusVerifikasi']?.toString()),
      ownerId: map['ownerId']?.toString() ?? '',
      ownerName: map['ownerName']?.toString() ?? 'Unknown',
      imageUrl: map['imageUrl']?.toString() ?? 'https://picsum.photos/200/300',
      distance: map['distance']?.toString() ?? '0 km away',
      condition: map['condition']?.toString() ?? 'Good',
      hasActiveBorrowing: map['hasActiveBorrowing'] == 1 || map['hasActiveBorrowing'] == true,
    );
  }

  Map<String, dynamic> toLocalMap() {
    String statusString = 'private';
    switch (statusVerifikasi) {
      case BookStatus.publicApproved:
        statusString = 'approved';
        break;
      case BookStatus.publicPending:
        statusString = 'need_verification';
        break;
      case BookStatus.publicRejected:
        statusString = 'rejected';
        break;
      case BookStatus.private:
        statusString = 'private';
        break;
    }

    return {
      'id': id,
      'isbn': isbn,
      'title': title,
      'author': author,
      'description': description,
      'isPublic': isPublic ? 1 : 0,
      'statusVerifikasi': statusString,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'imageUrl': imageUrl,
      'distance': distance,
      'condition': condition,
      'hasActiveBorrowing': hasActiveBorrowing ? 1 : 0,
    };
  }
}
