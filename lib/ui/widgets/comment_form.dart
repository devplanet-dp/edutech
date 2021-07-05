import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/utils/device_utils.dart';

class CommentForm extends StatefulWidget {
  final Function(String) onSendMessage;

  final Function(File) onImageMessage;

  final bool isDark;

  final Function onTyping;

  final Function onStopTyping;

  final String hintText;

  final bool isLoading;

  final Function(String) onReplyTapped;

  const CommentForm({
    Key key,
    @required this.onSendMessage,
    @required this.onImageMessage,
    @required this.onTyping,
    @required this.onStopTyping,
    @required this.isDark,
    this.hintText = 'Write a message...',
    this.isLoading = false,
    this.onReplyTapped,
  }) : super(key: key);

  @override
  CommentFormState createState() => CommentFormState();
}

class CommentFormState extends State<CommentForm> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController;

  Timer _typingTimer;

  bool _isTyping = false;

  void _sendMessage() {
    if (_textEditingController.text.isEmpty) return;

    widget.onSendMessage(_textEditingController.text);
    setState(() {
      _textEditingController.text = "";
    });
  }

  void onReplyTapped({@required String name}) async {
    if(name!=null) {
      _focusNode.unfocus();
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        _textEditingController.text = '$name ';
      });
    }else{
      _focusNode.unfocus();
      DeviceUtils.hideKeyboard(context);
      setState(() {
        _textEditingController.clear();
      });
    }
  }

  void _getImage() async {
    PickedFile _file =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (_file == null) return;
    widget.onImageMessage(File(_file.path));
  }

  void _runTimer() {
    if (_typingTimer != null && _typingTimer.isActive) _typingTimer.cancel();
    _typingTimer = Timer(Duration(milliseconds: 600), () {
      if (!_isTyping) return;
      _isTyping = false;
      widget.onStopTyping();
    });
    _isTyping = true;
    widget.onTyping();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: _getImage,
            icon: Icon(Icons.camera_alt_rounded),
            color: widget.isDark
                ? kAltWhite.withOpacity(0.7)
                : kAltBg.withOpacity(0.7),
            iconSize: 24,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2))
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                textInputAction: TextInputAction.done,
                focusNode: _focusNode,
                onChanged: (_) {
                  _runTimer();
                },
                onSubmitted: (_) {
                  _sendMessage();
                },
                controller: _textEditingController,
                decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 12)),
              ),
            ),
          ),
          Container(
            child: widget.isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator()),
                  )
                : IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send),
                    color: widget.isDark
                        ? kAltWhite.withOpacity(0.7)
                        : kAltBg.withOpacity(0.7),
                    iconSize: 24,
                  ),
          ),
        ],
      ),
    );
  }
}
