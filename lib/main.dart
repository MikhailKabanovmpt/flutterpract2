import 'package:flutter/material.dart';
 
void main() {
  runApp(const NotesApp());
}
 
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}
 
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
 
  @override
  State<NotesPage> createState() => _NotesPageState();
}
 
class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _notes = [];
  int? _editingIndex;
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (_editingIndex == null) {
        _notes.add(text);
      } else {
        _notes[_editingIndex!] = text;
        _editingIndex = null;
      }
      _controller.clear();
    });
    FocusScope.of(context).unfocus();
  }
 
  void _startEdit(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = _notes[index];
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }
 
  void _cancelEdit() {
    setState(() {
      _editingIndex = null;
      _controller.clear();
    });
    FocusScope.of(context).unfocus();
  }
 
  void _delete(int index) {
    setState(() {
      _notes.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
        _controller.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final isEditing = _editingIndex != null;
 
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: isEditing ? 'Редактирование заметки' : 'Введите текст',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(isEditing ? 'Обновить' : 'Сохранить'),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _cancelEdit,
                    child: const Text('Отмена'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _notes.isEmpty
                  ? const Center(child: Text('Заметок пока нет'))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_notes[index]),
                            selected: _editingIndex == index,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _startEdit(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _delete(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}