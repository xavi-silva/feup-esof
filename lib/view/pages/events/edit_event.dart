import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'dart:io';

import 'package:sweepspot/main.dart';
import 'package:sweepspot/view/pages/events/create_event_page.dart';

class EditEvent extends StatefulWidget {
  final String EventId;
  final String capacity;
  final String description;
  final String date;
  final String time;

  EditEvent(
      {required this.EventId,
      required this.capacity,
      required this.date,
      required this.description,
      required this.time});

  @override
  _EditEventState createState() => _EditEventState();
  AuthController authController = AuthController(FirebaseAuth.instance);
}

class _EditEventState extends State<EditEvent> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _capacityController = TextEditingController();
  File? eventImage;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    _capacityController.text = widget.capacity;
    _dateController.text = widget.date;
    _timeController.text = widget.time;

    _descriptionController.text = widget.description;
  }

  pickImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload your Event Photo'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    eventImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    eventImage = File(image.path);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.image,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.year.toInt().toString() +
            '-' +
            _picked.month.toInt().toString().padLeft(2, '0') +
            '-' +
            _picked.day.toInt().toString().padLeft(2, '0');
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? _picked = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 12, minute: 30));
    if (_picked != null) {
      setState(() {
        _timeController.text =
            _picked.hour.toString().split(' ')[0].padLeft(2, '0') +
                ':' +
                _picked.minute.toString().split(' ')[0].padLeft(2, '0');
      });
    }
  }

  Widget _buildDateInputBox(double screenHeight) {
    return Container(
        height: 30,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 225, 247, 219),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextFormField(
              validator: (date) => date != null && date.isEmpty ? '' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.symmetric(vertical: 7),
              ),
              controller: _dateController,
              readOnly: true,
              onTap: () {
                _selectDate();
              }),
        ));
  }

  Widget _buildTimeInputBox(double screenHeight) {
    return Container(
        height: 30,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 225, 247, 219),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextFormField(
            validator: (time) => time != null && time.isEmpty ? '' : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.symmetric(vertical: 7)),
            controller: _timeController,
            readOnly: true,
            onTap: () async {
              _selectTime();
            },
          ),
        ));
  }

  Widget _buildCapacityInputBox(double screenHeight) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 225, 247, 219),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: TextFormField(
        controller: _capacityController,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Capacity',
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 7),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    String url = ''; // Inicialize a URL com uma string vazia por padrão

    if (eventImage != null) {
      // Se uma nova imagem foi selecionada, faça o upload para o Firebase Storage
      url =
          await widget.authController.uploadImageToFirebaseStorage(eventImage!);
    }

    try {
      Map<String, dynamic> updateData = {
        'description': _descriptionController.text,
        'maxCapacity': _capacityController.text,
        'datetime': _dateController.text.split('-')[2] +
            '-' +
            _dateController.text.split('-')[1].padLeft(2, '0') +
            '-' +
            _dateController.text.split('-')[0].padLeft(2, '0') +
            ' ' +
            _timeController.text,
      };

      if (url.isNotEmpty) {
        updateData['image'] = url;
      }
      await _firestore
          .collection('Event')
          .doc(widget.EventId)
          .update(updateData);

      print('Dados atualizados com sucesso no Firebase!');
    } catch (e) {
      print('Erro ao atualizar dados no Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 165, 228, 198),
      appBar: AppBar(
        title: Text('Edit Event', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 225, 247, 219),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Description', style: TextStyle(color: Colors.black)),
              TextFormField(
                minLines: 5,
                maxLines: 10,
                controller: _descriptionController,
                style: TextStyle(color: Colors.black), // Cor do texto
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 225, 247, 219),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('Date', style: TextStyle(color: Colors.black)),
              _buildDateInputBox(10),
              SizedBox(height: 10),
              Text('Time', style: TextStyle(color: Colors.black)),
              _buildTimeInputBox(10),
              SizedBox(height: 10),
              Text('Capacity', style: TextStyle(color: Colors.black)),
              _buildCapacityInputBox(10),
              SizedBox(height: 10),
              Text('Photo', style: TextStyle(color: Colors.black)),
              EventImagePicker(
                eventImage: eventImage,
                onTap: pickImage,
                width: double.infinity,
                height: 100.0,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: SizedBox(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () async {
              await _saveChanges();
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Success!'),
                  content: Text('Your event has been edited.'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
            },
            shape: CircleBorder(eccentricity: 1),
            backgroundColor: Color.fromARGB(255, 225, 247, 219),
            child: Icon(Icons.save, size: 40),
          ),
        ),
      ),
    );
  }
}
