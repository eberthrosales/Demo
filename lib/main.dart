import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileUploadPage(),
    );
  }
}

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Método para elegir imagen
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Método para subir la imagen al servidor
  Future<void> _uploadImage() async {
    if (_image != null) {
      bool isUploaded = await ApiService.uploadFile(_image!);
      if (isUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo subido con éxito!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir el archivo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Imagen o Archivo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _image == null
                  ? Text('No se ha seleccionado ningún archivo')
                  : Container(
                width: double.infinity,
                height: 250,
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Subir Imagen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
