import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:storage_client/storage_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_client.dart';

class ListingMediaRepository {
  const ListingMediaRepository();

  static const maxPhotos = 6;
  static const targetKb = 300;

  Future<List<String>> uploadPhotos(List<File> files) async {
    final uid = supabase.auth.currentUser!.id;
    final urls = <String>[];
    final batch = files.take(maxPhotos).toList();
    for (var i = 0; i < batch.length; i++) {
      final bytes = await _compress(batch[i]);
      final path = '$uid/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      await supabase.storage.from('listing-images').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
          );
      urls.add(supabase.storage.from('listing-images').getPublicUrl(path));
    }
    return urls;
  }

  Future<Uint8List> _compress(File file) async {
    final out = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1280,
      minHeight: 1280,
      quality: 75,
    );
  if (out != null && out.length <= targetKb * 1024) return out;
    final out2 = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 60,
    );
    return Uint8List.fromList(out2 ?? await file.readAsBytes());
  }
}
