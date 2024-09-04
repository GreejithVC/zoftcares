class PostListModel {
  bool? status;
  List<PostModel>? data;
  int? currentPage;
  int? pageSize;
  int? totalItems;
  int? totalPages;
  int? nextPage;
  int? previousPage;
  bool? hasMore;

  PostListModel({
    this.status,
    this.data,
    this.currentPage,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.nextPage,
    this.previousPage,
    this.hasMore,
  });

  // Factory constructor to create a PostListModel from JSON
  factory PostListModel.fromJson(Map<String, dynamic> json) {
    return PostListModel(
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
          .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      hasMore: json['hasMore'],
    );
  }

  // Method to convert PostListModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['pageSize'] = this.pageSize;
    data['totalItems'] = this.totalItems;
    data['totalPages'] = this.totalPages;
    data['nextPage'] = this.nextPage;
    data['previousPage'] = this.previousPage;
    data['hasMore'] = this.hasMore;
    return data;
  }
}

class PostModel {
  int? id;
  String? title;
  String? body;
  String? image;

  PostModel({
    this.id,
    this.title,
    this.body,
    this.image,
  });

  // Factory constructor to create a PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      image: json['image'],
    );
  }

  // Method to convert PostModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    return data;
  }
}
