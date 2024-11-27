import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CommentSection extends StatefulWidget {
  final List<Map<String, dynamic>> allComments;
  final String userId;
  final String organizerId;
  final String eventId;
  final dynamic dataController;

  CommentSection({
    required this.allComments,
    required this.userId,
    required this.organizerId,
    required this.eventId,
    required this.dataController,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController _commentController = TextEditingController();
  bool _showCommentInput = false;

  Future<void> _fetchComments() async {
    try {
      final querySnapshot =
          await widget.dataController.getComments(widget.eventId);
      List<Map<String, dynamic>> comments = [];
      if (querySnapshot.docs.isNotEmpty) {
        for (var commentDoc in querySnapshot.docs) {
          var commentData = commentDoc.data();
          String userId = commentData['userid'];
          commentData['commentId'] = commentDoc.id;
          var userData = await widget.dataController.getUserData(userId);
          commentData['username'] = userData['username'];
          commentData['image'] = userData['image'];
          comments.add(commentData);
        }
      }
      setState(() {
        widget.allComments.clear();
        widget.allComments.addAll(comments);
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _submitComment() async {
    if (_commentController.text.isNotEmpty) {
      await widget.dataController
          .loadComment(widget.eventId, _commentController.text);
      _commentController.clear();
      setState(() {
        _showCommentInput = false;
      });

      await _fetchComments();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success!'),
          content: Text('The comment was successfully added'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Comments (${widget.allComments.length})",
            style: TextStyle(color: Colors.black),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 225, 247, 219),
            ),
            width: double.infinity,
            child: Column(
              children: [
                if (!widget.allComments.isEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.allComments.length,
                    itemBuilder: (context, index) {
                      var commentData = widget.allComments[index];
                      var commentId = commentData['commentId'];
                      var commentText = commentData['text'];
                      var commentDate = DateTime.parse(commentData['date']);
                      var username = commentData['username'];
                      var userImage = commentData['image'];
                      var commentTimestamp = commentDate;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      userImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: AutoSizeText(
                                              "@$username,",
                                              style: TextStyle(
                                                  color: Colors.black),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 14,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            formatCommentTime(commentTimestamp),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onLongPress: () {
                                          if (commentData['userid'] ==
                                                  widget.userId ||
                                              widget.userId ==
                                                  widget.organizerId ||
                                              widget.dataController.userInfo!
                                                  .get('isAdmin')) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Delete Comment?'),
                                                content: Text(
                                                    'Are you sure you want to delete this comment?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Event')
                                                          .doc(widget.eventId)
                                                          .collection('review')
                                                          .doc(commentId)
                                                          .delete();

                                                      await _fetchComments();

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title:
                                                              Text('Success!'),
                                                          content: Text(
                                                              'The comment was successfully deleted'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context); // Close success dialog
                                                                Navigator.pop(
                                                                    context); // Close confirmation dialog
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.69,
                                          child: AutoSizeText(
                                            commentText,
                                            softWrap: true,
                                            style:
                                                TextStyle(color: Colors.black),
                                            maxLines: null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            index != widget.allComments.length - 1
                                ? Container(
                                    height: 1,
                                    color: Colors.black,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      );
                    },
                  ),
                (!_showCommentInput)
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.chat,
                                  size: 25, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _showCommentInput = true;
                                });
                              },
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showCommentInput = true;
                                });
                              },
                              child: Text(
                                "Add a comment...",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                TextField(
                                  style: TextStyle(color: Colors.black),
                                  controller: _commentController,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: 'Write a comment...',
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _submitComment,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 225, 247, 219),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
