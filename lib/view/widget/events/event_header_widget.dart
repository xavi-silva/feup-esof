import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EventHeader extends StatelessWidget {
  final String name;
  final String date;
  final String startTime;
  final String description;
  final int participantsCount;
  final String capacity;
  final bool isParticipant;

  const EventHeader({
    Key? key,
    required this.name,
    required this.date,
    required this.startTime,
    required this.description,
    required this.participantsCount,
    required this.capacity,
    required this.isParticipant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFA5E4C6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Icon(
                  Icons.place,
                  color: Colors.black,
                  size: 30,
                ),
                SizedBox(width: 3),
                Flexible(
                  child: AutoSizeText(
                    name,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                    maxLines: 2,
                    minFontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 7),
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black,
                  size: 14,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                    startTime,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                  child: Text(
                    '$participantsCount/$capacity',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                if (isParticipant)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Joined',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 40),
                decoration: BoxDecoration(
                  color: Color(0xFFE1F7DB),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    description,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
