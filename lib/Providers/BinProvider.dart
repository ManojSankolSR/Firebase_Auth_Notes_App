import 'package:bottom/Models/DataModel.dart';
import 'package:bottom/Models/RemainderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemainderBinNotifier extends StateNotifier<List<RemainderModel>> {
  RemainderBinNotifier() : super(const []);
  Future getData() async {
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("RemainderBin")
        .collection("RemainderBin")
        .get();
    final dataList = data.docs
        .map((row) => RemainderModel(
              rid: row['rid'] as int,
              id: row['id'] as String,
              date: DateTime.parse(row['Added_Date'] as String),
              title: row['Title'] as String,
              note: row['Note'] as String,
              rdate: DateTime.parse(row["Remainder_date"] as String),
            ))
        .toList();
    state = dataList;
  }

  Future addRemainder(RemainderModel remainder) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("RemainderBin")
        .collection("RemainderBin")
        .doc(remainder.id)
        .set({
      "rid": remainder.rid,
      "id": remainder.id,
      "Title": remainder.title,
      "Note": remainder.note,
      "Added_Date": remainder.date.toString(),
      "Remainder_date": remainder.rdate.toString(),
    });
    state = [remainder, ...state];
  }

  Future delRemainder(RemainderModel remainder) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("RemainderBin")
        .collection("RemainderBin")
        .doc(remainder.id)
        .delete();
    int index = state.indexOf(remainder);
    state.removeAt(index);
    state = [...state];
  }
}

final BinRemainderProvider =
    StateNotifierProvider<RemainderBinNotifier, List<RemainderModel>>(
        (ref) => RemainderBinNotifier());

class NoteBinNotifier extends StateNotifier<List<DataModel>> {
  NoteBinNotifier() : super(const []);

  Future getData() async {
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("NotesBin")
        .collection("NotesBin")
        .get();
    final dataList = data.docs.map((row) {
      return DataModel(
          id: row['Id'] as String,
          date: DateTime.parse(row['Date'] as String),
          title: row['Title'] as String,
          note: row['Note'] as String);
    }).toList();
    print(dataList);
    state = dataList;
  }

  Future addNote(DataModel Note) async {
    print(FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("NotesBin")
        .collection("NotesBin")
        .doc(Note.id)
        .set({
      'Id': Note.id,
      'Date': Note.date.toString(),
      'Title': Note.title,
      'Note': Note.note,
    });
    state = [Note, ...state];
  }

  Future delNote(DataModel Note) async {
    print(FirebaseAuth.instance.currentUser!.uid);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Bin")
        .doc("NotesBin")
        .collection("NotesBin")
        .doc(Note.id)
        .delete();
    int index = state.indexOf(Note);
    state.removeAt(index);
    state = [...state];
  }
}

final BinNoteProvider = StateNotifierProvider<NoteBinNotifier, List<DataModel>>(
    (ref) => NoteBinNotifier());
