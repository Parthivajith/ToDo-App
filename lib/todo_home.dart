import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  List<String> todolist = [];
  String text = "";

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('todolist');
    if (jsonString != null) {
      setState(() {
        todolist = List<String>.from(json.decode(jsonString));
      });
    }
  }

  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(todolist);
    await prefs.setString('todolist', jsonString);
    print("Todo list saved: $jsonString"); // Debug print
  }

  void addString(String content) {
    setState(() {
      text = content;
    });
  }

  void addList() {
    if (text.isNotEmpty) {
      setState(() {
        todolist.add(text);
        text = ""; // Clear the text field
        _saveTodoList(); // Save the updated list
      });
    }
  }

  void deleteItem(int index) {
    setState(() {
      todolist.removeAt(index);
      _saveTodoList(); // Save the updated list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
        title: Center(
          child: Text(
            "ToDo App",
            style: GoogleFonts.roboto(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(121, 121, 121, 1),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: ListView.builder(
              itemCount: todolist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(21, 21, 21, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: const Color.fromRGBO(21, 21, 21, 1),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                todolist[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  color: const Color.fromRGBO(214, 214, 214, 1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    const Color.fromRGBO(42, 42, 42, 1),
                                child: TextButton(
                                  onPressed: () {
                                    deleteItem(index);
                                  },
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(0, 0),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    onChanged: (content) {
                      addString(content);
                    },
                    style: GoogleFonts.roboto(
                      color: const Color.fromARGB(198, 255, 255, 255),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(92, 131, 116, 1),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blue.shade700,
                          width: 2.0,
                        ),
                      ),
                      fillColor: const Color.fromRGBO(146, 147, 166, 1),
                      prefixIcon: const Icon(
                        Icons.task,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      labelText: 'Create Task....',
                      labelStyle: GoogleFonts.roboto(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                      isDense: true,
                      filled: false,
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      addList();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
