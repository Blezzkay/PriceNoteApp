import 'dart:io';

void main() {
  const String assetsPath = 'assets/icons';
  const String outputPath = 'lib/constants/imageAssets.dart';

  final Directory dir = Directory(assetsPath);

  if (!dir.existsSync()) {
    print('Error: The directory "$assetsPath" does not exist.');
    return;
  }

  final List<FileSystemEntity> files = dir.listSync(recursive: true);
  final List<String> imageFiles = [];

  for (var file in files) {
    if (file is File &&
        (file.path.endsWith('.png') ||
            file.path.endsWith('.jpg') ||
            file.path.endsWith('.webp') ||
            file.path.endsWith('.jpeg') ||
            file.path.endsWith('.svg'))) {
      // Normalize path for cross-platform compatibility
      String relativePath = file.path.replaceFirst(Directory.current.path + Platform.pathSeparator, '').replaceAll('\\', '/');
      imageFiles.add(relativePath);
    }
  }

  final StringBuffer buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE - DO NOT MODIFY MANUALLY');
  buffer.writeln('class Assets {');

  for (var image in imageFiles) {
    String varName = image
        .replaceFirst('$assetsPath/', '') // Remove "assets/images/" prefix
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_') // Replace special characters
        .replaceAll(RegExp(r'__+'), '_') // Avoid double underscores
        .replaceAll(RegExp(r'_$'), '') // Remove trailing underscores
        .toLowerCase();

    buffer.writeln('  static const String $varName = "$image";');
  }

  buffer.writeln('}');

  File(outputPath).writeAsStringSync(buffer.toString());

  print('✅ Assets file generated successfully: $outputPath');
}
