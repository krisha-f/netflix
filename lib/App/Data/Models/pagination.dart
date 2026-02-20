class PaginationModel<T> {
  final List<T> data;
  final Meta meta;

  PaginationModel({
    required this.data,
    required this.meta,
  });

  factory PaginationModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return PaginationModel(
      data: (json['data'] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}