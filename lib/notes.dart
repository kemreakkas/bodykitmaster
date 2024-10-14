// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class NotesSection extends StatefulWidget {
  final List<String> notes;
  final ValueChanged<List<String>> onNotesChanged;

  const NotesSection({required this.notes, required this.onNotesChanged});

  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController _textEditingController = TextEditingController();

  void _addNote() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        widget.notes.add(_textEditingController.text);
        _textEditingController.clear();
        widget.onNotesChanged(widget.notes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            labelText: 'Yeni Not',
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addNote,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: TextField(
                  controller: TextEditingController(text: widget.notes[index]),
                  onChanged: (text) {
                    setState(() {
                      widget.notes[index] = text;
                    });
                    widget.onNotesChanged(widget.notes);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.notes.removeAt(index);
                    });
                    widget.onNotesChanged(widget.notes);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
