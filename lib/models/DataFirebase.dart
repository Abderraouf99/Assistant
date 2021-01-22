import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/DataEvents.dart';
import 'package:to_do_app/models/DataNotes.dart';
import 'package:to_do_app/models/DataTask.dart';
import 'package:to_do_app/models/Note.dart';
import 'Tasks.dart';

const String kArchivedTasks = 'archiveTask';
const String kTask = 'tasks';
const String kDeletedTasks = "binTasks";

const String kNote = 'notes';
const String kArchivedNotes = 'archiveNotes';
const String kDeletedNotes = 'binNotes';

class FirebaseController extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestoreReference = FirebaseFirestore.instance.collection('users');
  FirebaseAuth get auth => _auth;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  FirebaseAuth getAuthInstance() {
    return _auth;
  }

  void createNewUserDocument() async {
    await _firestoreReference.doc('${_auth.currentUser.email}').set(
      {'id': '${_auth.currentUser.email}'},
    );
  }

  /// ***********************************Task related actions**************************************/

  Future<void> addTask(Task task) async {
    await _addTask(task: task, dataBase: kTask);
  }

  Future<void> _addTask({Task task, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .add(
      {
        'taskText': task.getTask(),
        'taskStatus': task.getState(),
      },
    );
  }

  Future<QuerySnapshot> _getTaskQuery({String dataBase}) async {
    QuerySnapshot tasks = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    return tasks;
  }

  Future<String> _findTask({Task task, String dataBase}) async {
    String docID;
    QuerySnapshot tasks = await _getTaskQuery(dataBase: dataBase);
    for (var document in tasks.docs) {
      if (document.data()['taskText'] == task.getTask()) {
        docID = document.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteTask({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _fetchTasks(BuildContext context, {String dataBase}) async {
    var task = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    List<Task> taskList = [];
    for (var doc in task.docs) {
      taskList.add(
        Task(
          task: doc.get('taskText'),
          status: doc.get('taskStatus'),
        ),
      );
    }
    if (dataBase == kTask) {
      Provider.of<TaskController>(context, listen: false).setTasks(taskList);
    } else if (dataBase == kArchivedTasks) {
      Provider.of<TaskController>(context, listen: false).setArchived(taskList);
    } else {
      Provider.of<TaskController>(context, listen: false).setDeleted(taskList);
    }
  }

  Future<void> moveTaskTobin(Task task, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findTask(dataBase: kArchivedTasks, task: task);
      await _deleteTask(dataBase: kArchivedTasks, docID: docID);
    } else {
      docID = await _findTask(dataBase: kTask, task: task);
      await _deleteTask(docID: docID, dataBase: kTask);
    }
    await _addTask(task: task, dataBase: kDeletedTasks);
  }

  Future<void> archiveTask(Task task) async {
    String docID = await _findTask(dataBase: kTask, task: task);
    await _deleteTask(dataBase: kTask, docID: docID);
    await _addTask(task: task, dataBase: kArchivedTasks);
  }

  Future<void> unArchiveTask(Task task) async {
    String docID = await _findTask(
      dataBase: kArchivedTasks,
      task: task,
    );
    await _deleteTask(
      docID: docID,
      dataBase: kArchivedTasks,
    );
    await _addTask(task: task, dataBase: kTask);
  }

  Future<void> purgeTask(Task task) async {
    String docID = await _findTask(
      dataBase: kDeletedTasks,
      task: task,
    );
    await _deleteTask(
      dataBase: kDeletedTasks,
      docID: docID,
    );
  }

  Future<void> recoverTask(Task task) async {
    String docID = await _findTask(dataBase: kDeleted, task: task);
    await _deleteTask(
      dataBase: kDeletedTasks,
      docID: docID,
    );
    await _addTask(task: task, dataBase: kTask);
  }

  Future<void> fetchData(BuildContext context) async {
    await _fetchTasks(context, dataBase: kTask);
    await _fetchTasks(context, dataBase: kArchivedTasks);
    await _fetchTasks(context, dataBase: kDeletedTasks);
    await _fetchNotes(context, dataBase: kNote);
    await _fetchNotes(context, dataBase: kArchivedNotes);
    await _fetchNotes(context, dataBase: kDeletedNotes);

  }

  Future<void> _toggleTaskStatus({Task task, bool isArchived}) async {
    String dataBase = (isArchived) ? kArchivedTasks : kTask;
    String docID = await _findTask(
      dataBase: dataBase,
      task: task,
    );
    var document = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .get();
    document.reference.update(
      {
        'taskStatus': task.getState(),
      },
    );
  }

  Future<void> toggleStatusTasks(Task task, bool isArchived) async {
    await _toggleTaskStatus(isArchived: isArchived, task: task);
  }

  /// *****************************************************Event related actions *************************/


  /// *************************************************Notes related Events***************************/

  Future<void> addNote(Note note) async {
    await _addNote(
      note: note,
      dataBase: kNote,
    );
  }

  Future<void> _addNote({Note note, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .add(
      {
        'noteTitle': note.getTitle,
        'noteText': note.getNote,
        'noteDate': note.getDate,
      },
    );
  }

  Future<String> _findNote({Note note, String dataBase}) async {
    String docID = '';
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();

    for (var doc in notes.docs) {
      if (doc.data()['noteTitle'] == note.getTitle) {
        docID = doc.id;
        break;
      }
    }
    return docID;
  }

  Future<void> _deleteNote({String docID, String dataBase}) async {
    await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .doc(docID)
        .delete();
  }

  Future<void> _fetchNotes(BuildContext context, {String dataBase}) async {
    var notes = await _firestoreReference
        .doc('${_auth.currentUser.email}')
        .collection(dataBase)
        .get();
    List<Note> notesList = [];
    for (var doc in notes.docs) {
      notesList.add(
        Note(doc.get('noteText'), doc.get('noteTitle'),
            doc.get('noteDate').toDate()),
      );
    }
    if (dataBase == kNote) {
      Provider.of<NotesController>(context, listen: false).setNote(notesList);
    } else if (dataBase == kArchivedNotes) {
      Provider.of<NotesController>(context, listen: false)
          .setArchivedNotes(notesList);
    } else {
      Provider.of<NotesController>(context, listen: false)
          .setDeletedNotes(notesList);
    }
  }

  Future<void> moveNoteToBin(Note note, bool isArchived) async {
    String docID = '';
    if (isArchived) {
      docID = await _findNote(
        note: note,
        dataBase: kArchivedNotes,
      );
      await _deleteNote(
        docID: docID,
        dataBase: kArchivedNotes,
      );
    } else {
      docID = await _findNote(
        dataBase: kNote,
        note: note,
      );
      await _deleteNote(
        dataBase: kNote,
        docID: docID,
      );
    }
    await _addNote(
      note: note,
      dataBase: kDeletedNotes,
    );
  }

  Future<void> archiveNote(Note note) async {
    String docID = await _findNote(dataBase: kNote, note: note);
    await _deleteNote(
      dataBase: kNote,
      docID: docID,
    );
    await _addNote(
      note: note,
      dataBase: kArchivedNotes,
    );
  }

  Future<void> unArchiveNote(Note note) async {
    String docID = await _findNote(
      note: note,
      dataBase: kArchivedNotes,
    );
    await _deleteNote(
      docID: docID,
      dataBase: kArchivedNotes,
    );
    await addNote(note);
  }

  Future<void> deleteNoteForever(Note note) async {
    String docID = await _findNote(dataBase: kDeletedNotes, note: note);
    await _deleteNote(
      dataBase: kDeletedNotes,
      docID: docID,
    );
  }

  Future<void> recoverNote(Note note) async {
    String docID = await _findNote(dataBase: kDeletedNotes, note: note);
    await _deleteNote(
      dataBase: kDeletedNotes,
      docID: docID,
    );
    await addNote(note);
  }
}
