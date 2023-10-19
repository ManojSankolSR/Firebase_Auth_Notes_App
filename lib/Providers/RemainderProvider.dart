import 'package:bottom/Models/RemainderModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottom/Notification.dart';
import 'dart:convert';

class RemainderNotifer extends StateNotifier<List<RemainderModel>> {
  final Notificationservice _notificationservice = Notificationservice();
  RemainderNotifer() : super(const []);
  void addRemainder(RemainderModel remainder) {
    var a = jsonEncode({
      "rid": remainder.rid,
      "id": remainder.id,
      "Title": remainder.title,
      "Note": remainder.note,
      "Added_Date": remainder.date.toString(),
      "Remainder_date": remainder.rdate.toString(),
    });
    print(jsonDecode(a)["title"]);

    _notificationservice.sendscheduledNotfication(
        remainder.rid, remainder.rdate, remainder.title, remainder.note, a);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Remainders")
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

  Future<RemainderModel> delete(RemainderModel remainder) async {
    _notificationservice.delRemainder(remainder.rid);
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Remainders")
        .doc(remainder.id)
        .delete();
    int ind = state.indexOf(remainder);
    final delNote = state.removeAt(ind);
    state = [...state];
    print("deleted");
    return delNote;
  }

  void update(RemainderModel remainder) async {
    // ref.read(idustateprovider.notifier).state = true;
    var a = jsonEncode({
      "rid": remainder.rid,
      "id": remainder.id,
      "Title": remainder.title,
      "Note": remainder.note,
      "Added_Date": remainder.date.toString(),
      "Remainder_date": remainder.rdate.toString(),
    });
    _notificationservice.sendscheduledNotfication(
        remainder.rid, remainder.rdate, remainder.title, remainder.note, a);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Remainders")
        .doc(remainder.id)
        .set({
      "rid": remainder.rid,
      "id": remainder.id,
      "Title": remainder.title,
      "Note": remainder.note,
      "Added_Date": remainder.date.toString(),
      "Remainder_date": remainder.rdate.toString()
    });
    getData();
    // ref.read(idustateprovider.notifier).state = false;
  }

  Future<List<RemainderModel>> getData() async {
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Remainders")
        .get();
    print(data.docs);

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
    // final List<RemainderModel> dl1 = dataList.isEmpty
    //     ? dataList
    //     : dataList.where((element) {
    //         print(element.id);
    //         if (element.rdate.isAfter(DateTime.now())) {
    //           return true;
    //         } else {
    //           delete(element);
    //           return false;
    //         }
    //       }).toList();

    state = dataList;
    return dataList;
  }
}

final RemainderProvider =
    StateNotifierProvider<RemainderNotifer, List<RemainderModel>>(
        (ref) => RemainderNotifer());
