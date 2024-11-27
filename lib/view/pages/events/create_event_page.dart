import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sweepspot/control/auth/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweepspot/main.dart';
import 'package:sweepspot/view/widget/events/map_widget.dart';

class CreateEventPage extends StatefulWidget {
  CreateEventPage({Key? key}) : super(key: key);
  AuthController authController = AuthController(FirebaseAuth.instance);
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  File? eventImage;
  final formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late MapWidget mapPage;

  bool isLoading = false;

  _CreateEventPageState() {
    mapPage = MapWidget();
  }

  void clear() {
    setState(() {
      eventImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 247, 219),
        automaticallyImplyLeading: true,
        title: Text('Create an event'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    color: Color.fromARGB(255, 165, 228, 198),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          // Input Name
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Name',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 225, 247, 219),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Center(
                                child: TextFormField(
                              controller: nameController,
                              validator: (name) =>
                                  name != null && name.isEmpty ? '' : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: TextStyle(color: Colors.black),
                              //textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: -20),
                                //hintText: 'Name',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                            )),
                          ),

                          SizedBox(height: 10),

                          // Date, Time e Capacity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),
                              _buildDateInputBox(screenHeight, screenWidth, ''),
                              Icon(
                                Icons.access_time,
                                color: Colors.black,
                              ),
                              _buildTimeInputBox(screenHeight, screenWidth, ''),
                              Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              _buildCapacityInputBox(
                                  screenHeight, screenWidth, ''),
                            ],
                          ),

                          SizedBox(height: 10),

                          // Input Description
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Description',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 225, 247, 219),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: descriptionController,
                              validator: (description) =>
                                  description != null && description.isEmpty
                                      ? ''
                                      : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: TextStyle(color: Colors.black),
                              maxLines: null, // Permite múltiplas linhas
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(),
                                //hintText: 'Description',
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(
                              height:
                                  10), // Espaço vazio (3% da altura da tela)

                          SizedBox(
                            height: 200,
                            child: mapPage,
                          ),
                          SizedBox(height: 10),
                          // Input de imagem

                          EventImagePicker(
                            eventImage: eventImage,
                            onTap: pickImage,
                            width: double.infinity,
                            height: 100.0,
                          ),
                          SizedBox(
                              height:
                                  10), // Espaço vazio (3% da altura da tela)

                          // Botões Create e Discard
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  LatLng? latlng =
                                      mapPage.getMarkerCoordinates();
                                  if (formKey.currentState!.validate() &&
                                      eventImage != null &&
                                      latlng != null) {
                                    try {
                                      String dateTime = _dateController.text +
                                          " " +
                                          _timeController.text;
                                      String uid = FirebaseAuth
                                          .instance.currentUser!.uid;
                                      String imageURL = await widget
                                          .authController
                                          .uploadImageToFirebaseStorage(
                                              eventImage!);
                                      CollectionReference eventsCollection =
                                          FirebaseFirestore.instance
                                              .collection('Event');

                                      eventsCollection.add({
                                        'organizer': uid,
                                        'image': imageURL,
                                        'name': nameController.text,
                                        'location': GeoPoint(
                                            latlng.latitude, latlng.longitude),
                                        'datetime': dateTime,
                                        'description':
                                            descriptionController.text,
                                        'maxCapacity': capacityController.text,
                                      }).then((DocumentReference
                                          documentRef) async {
                                        String neweventId = documentRef.id;
                                        CollectionReference usersCollection =
                                            FirebaseFirestore.instance
                                                .collection('users');
                                        DocumentReference userRef =
                                            usersCollection.doc(uid);
                                        await userRef
                                            .collection('events')
                                            .doc(neweventId)
                                            .set({});

                                        DocumentReference eventRef =
                                            eventsCollection.doc(neweventId);
                                        await eventRef
                                            .collection('participants')
                                            .doc(uid)
                                            .set({});
                                      });
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Success!'),
                                          content: Text(
                                              'Your event has been created.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      );
                                      navigatorKey.currentState!
                                          .popUntil((route) => route.isFirst);
                                    } on FirebaseAuthException catch (e) {
                                      print(e);
                                      showDialog(
                                          context: context,
                                          builder: ((context) => AlertDialog(
                                                title: Text('Warning!'),
                                                content: Text(
                                                  e.message ?? "Error",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text('OK'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ],
                                              )));
                                    }
                                  } else if (latlng == null) {
                                    showDialog(
                                        context: context,
                                        builder: ((context) => AlertDialog(
                                              title: Text('Warning!'),
                                              content: Text(
                                                  'Please add an address for the event'),
                                              actions: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            )));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: ((context) => AlertDialog(
                                              title: Text('Warning!'),
                                              content: Text(
                                                  'Please provide inputs to all boxes'),
                                              actions: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                ),
                                              ],
                                            )));
                                  }

                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child: Text(
                                  'Create',
                                  selectionColor: Colors.black,
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      Color.fromARGB(255, 188, 254, 172),
                                  minimumSize: Size(screenWidth * 0.45, 30),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //fazer reset das cenas
                                  clear();
                                },
                                child: Text('Discard photo'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      Color.fromARGB(255, 252, 169, 169),
                                  minimumSize: Size(screenWidth * 0.45, 30),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildCapacityInputBox(
      double screenHeight, double screenWidth, String hintText) {
    return Container(
      height: 30,
      width: screenWidth * 0.12,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 225, 247, 219),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: TextFormField(
        validator: (capacity) =>
            capacity != null && capacity.isEmpty ? '' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: capacityController,
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(vertical: 7),
        ),
      ),
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
        String formattedDate = _picked.year.toString() +
            '-' +
            _picked.month.toString().padLeft(2, '0') +
            '-' +
            _picked.day.toString().padLeft(2, '0');
        _dateController.text = formattedDate;
      });
    }
  }

  Widget _buildDateInputBox(
      double screenHeight, double screenWidth, String hintText) {
    return Container(
      height: 30,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 225, 247, 219),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: TextFormField(
          validator: (date) => date != null && date.isEmpty ? '' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 7),
          ),
          controller: _dateController,
          readOnly: true,
          onTap: () {
            _selectDate();
          }),
    );
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

  Widget _buildTimeInputBox(
      double screenHeight, double screenWidth, String hintText) {
    return Container(
      height: 30,
      width: screenWidth * 0.17,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 225, 247, 219),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: TextFormField(
        validator: (time) => time != null && time.isEmpty ? '' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 7)),
        controller: _timeController,
        readOnly: true,
        onTap: () async {
          _selectTime();
        },
      ),
    );
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
}

class EventImagePicker extends StatelessWidget {
  final Function()? onTap;
  final File? eventImage;
  final height;
  final width;
  const EventImagePicker(
      {Key? key,
      required this.onTap,
      required this.eventImage,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      InkWell(
        onTap: onTap,
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 225, 247, 219),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: eventImage == null
                ? Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.add_a_photo, color: Colors.black),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(eventImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
      ),
    ]);
  }
}
