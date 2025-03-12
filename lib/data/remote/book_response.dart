class BookResponse{
  late final String? title;
  late final String? subtitle;
  late final String? description;
  late final String? imageUrl;


  BookResponse({
     this.title,
    this.subtitle,
    this.description,
    this.imageUrl

});

  factory BookResponse.fromJson(Map<String,dynamic>json){
    return BookResponse(
      title: json['volumeInfo']['title']??"No title",
      subtitle: json['volumeInfo']['subtitle']??"No subtitle",
      description: json['volumeInfo']['description']??"No description",
      imageUrl: json['volumeInfo']['imageLinks']?['thumbnail'],
    );
  }
}