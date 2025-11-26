class ReportResponse {
  final int? count;
  final String? next;
  final dynamic previous;
  final List<Results>? results;

  ReportResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  ReportResponse.fromJson(Map<String, dynamic> json)
      : count = json['count'] as int?,
        next = json['next'] as String?,
        previous = json['previous'],
        results = (json['results'] as List?)?.map((dynamic e) => Results.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'count' : count,
    'next' : next,
    'previous' : previous,
    'results' : results?.map((e) => e.toJson()).toList()
  };
}

class Results {
  final int? id;
  final String? title;
  final String? url;
  final String? imageUrl;
  final String? newsSite;
  final String? summary;
  final String? publishedAt;
  final String? updatedAt;

  Results({
    this.id,
    this.title,
    this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
    this.updatedAt,
  });

  Results.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        url = json['url'] as String?,
        imageUrl = json['image_url'] as String?,
        newsSite = json['news_site'] as String?,
        summary = json['summary'] as String?,
        publishedAt = json['published_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'url' : url,
    'image_url' : imageUrl,
    'news_site' : newsSite,
    'summary' : summary,
    'published_at' : publishedAt,
    'updated_at' : updatedAt
  };
}