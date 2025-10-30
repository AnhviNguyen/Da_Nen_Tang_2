import 'package:flutter/cupertino.dart';
import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';
import 'package:photo_gallery_app/screen/PhotoDetailScreenState.dart';

class PhotoDetailScreen extends StatefulWidget {
  final Photo photo;
  final PhotoRepository photoRepository;

  const PhotoDetailScreen({
    super.key,
    required this.photo,
    required this.photoRepository,
  });

  @override
  State<PhotoDetailScreen> createState() => PhotoDetailScreenState();
}