import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String name;
  final String displayName;
  final String? description;
  final String? imageUrl;

  const Category({
    required this.name,
    required this.displayName,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, displayName, description, imageUrl];
}
