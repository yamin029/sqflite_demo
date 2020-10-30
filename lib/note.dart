import 'package:flutter/material.dart';
import 'package:sqlite_demo/constants.dart';
import 'package:sqlite_demo/providers/note_provider.dart';


enum NoteMode { Editing, Adding }

class Note extends StatefulWidget {
  final Map<String, dynamic> note;
  final NoteMode _noteMode;
  Note(this._noteMode,this.note);

  @override
  _NoteState createState() => _NoteState(_noteMode);
}

class _NoteState extends State<Note> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  final NoteMode noteMode;
  _NoteState(this.noteMode);

  @override
  void didChangeDependencies() {
    if (widget._noteMode == NoteMode.Editing) {
      _titleController.text = widget.note['title'];
      _textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noteMode == NoteMode.Adding ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: kTextFieldDecoration,
              controller: _titleController,
            ),
            SizedBox(
              height: 14,
            ),
            TextField(
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Note Text', labelText: 'Enter Note Text'),
              controller: _textController,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton(
                  text: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    if (widget?._noteMode == NoteMode.Adding) {
                      final title = _titleController.text;
                      final text = _textController.text;
                      print(title);
                      print(text);
                      setState(() {
                        NoteProvider.insertNote({
                          'title':title,
                          'text' : text
                        });
                      });

                    }
                    else if(widget._noteMode == NoteMode.Editing){
                      NoteProvider.updateNote(
                        {
                          'id' : widget.note['id'],
                          'title': _titleController.text,
                          'text': _textController.text
                        }
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
                _NoteButton(
                  text: Text(
                    'Discard',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                noteMode == NoteMode.Editing
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _NoteButton(
                          onPressed: () {
                            NoteProvider.deleteNote(widget.note['id']);

                            Navigator.pop(context);
                          },
                          text: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                          color: Colors.redAccent,
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final Text text;
  final Color color;
  final Function onPressed;
  _NoteButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: text,
      color: color,
      height: 50,
      minWidth: 100,
    );
  }
}
