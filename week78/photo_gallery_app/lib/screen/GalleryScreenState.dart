import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:photo_gallery_app/implement/FileStorageServiceImpl.dart';
import 'package:photo_gallery_app/implement/ImageServiceImpl.dart';
import 'package:photo_gallery_app/implement/PhotoRepositoryImpl.dart';
import 'package:photo_gallery_app/model/DeletePhotoUseCase.dart';
import 'package:photo_gallery_app/model/Photo.dart';
import 'package:photo_gallery_app/model/PickPhotoFromGalleryUseCase.dart';
import 'package:photo_gallery_app/model/TakePhotoUseCase.dart';
import 'package:photo_gallery_app/repository/FileStorageService.dart';
import 'package:photo_gallery_app/repository/ImageService.dart';
import 'package:photo_gallery_app/repository/PhotoRepository.dart';
import 'package:photo_gallery_app/screen/EmptyGalleryView.dart';
import 'package:photo_gallery_app/screen/GalleryScreen.dart';
import 'package:photo_gallery_app/screen/PhotoDetailScreen.dart';
import 'package:photo_gallery_app/screen/PhotoGridItem.dart';
import 'package:photo_gallery_app/screen/PhotoListItem.dart';

class GalleryScreenState extends State<GalleryScreen> {
  late final PhotoRepository _photoRepository;
  late final ImageService _imageService;
  late final FileStorageService _fileStorageService;
  late final TakePhotoUseCase _takePhotoUseCase;
  late final PickPhotoFromGalleryUseCase _pickPhotoUseCase;
  late final DeletePhotoUseCase _deletePhotoUseCase;

  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _photoRepository = PhotoRepositoryImpl();
    _imageService = ImageServiceImpl();
    _fileStorageService = FileStorageServiceImpl();
    _takePhotoUseCase = TakePhotoUseCase(
      imageService: _imageService,
      fileStorageService: _fileStorageService,
      photoRepository: _photoRepository,
    );
    _pickPhotoUseCase = PickPhotoFromGalleryUseCase(
      imageService: _imageService,
      fileStorageService: _fileStorageService,
      photoRepository: _photoRepository,
    );
    _deletePhotoUseCase = DeletePhotoUseCase(
      photoRepository: _photoRepository,
      fileStorageService: _fileStorageService,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Photo>('photos').listenable(),
        builder: (context, Box<Photo> box, _) {
          if (box.isEmpty) {
            return const EmptyGalleryView();
          }

          final photos = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return _isGridView
              ? _buildGridView(photos)
              : _buildListView(photos);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: _takePhoto,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: _pickFromGallery,
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Photo> photos) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PhotoGridItem(
          photo: photos[index],
          onTap: () => _openPhotoDetail(photos[index]),
          onDelete: () => _deletePhoto(photos[index]),
        );
      },
    );
  }

  Widget _buildListView(List<Photo> photos) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PhotoListItem(
          photo: photos[index],
          onTap: () => _openPhotoDetail(photos[index]),
          onDelete: () => _deletePhoto(photos[index]),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    final photo = await _takePhotoUseCase.call();
    if (photo != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo captured successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture photo')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final photo = await _pickPhotoUseCase.call();
    if (photo != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo added successfully!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No photo selected')),
      );
    }
  }

  Future<void> _deletePhoto(Photo photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deletePhotoUseCase.call(photo);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo deleted')),
        );
      }
    }
  }

  void _openPhotoDetail(Photo photo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(
          photo: photo,
          photoRepository: _photoRepository,
        ),
      ),
    );
  }
}