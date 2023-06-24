import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finglish/data/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get quizCollection => _firestore.collection('quiz');

  Future<bool> createQuiz(Quiz quiz) async {
    bool result = false;
    try {
      await quizCollection.doc(quiz.quizId.toString()).set(quiz.toJson());
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<List<Quiz>?> getAllQuizData() async {
    List<Quiz>? result;
    try {
      await quizCollection.get().then((value) {
        List<Quiz> quizs = [];
        for (var i = 0; i < value.docs.length; i++) {
          Map<String, dynamic> json =
              value.docs[i].data() as Map<String, dynamic>;
          quizs.add(Quiz.fromJson(json));
        }
        result = quizs;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<List<Quiz>?> getAllAfter(int id) async {
    List<Quiz>? result;
    try {
      await quizCollection
          .where('quizId', isGreaterThan: id)
          .get()
          .then((value) {
        List<Quiz> quizs = [];
        for (var i = 0; i < value.docs.length; i++) {
          Map<String, dynamic> json =
              value.docs[i].data() as Map<String, dynamic>;
          quizs.add(Quiz.fromJson(json));
        }
        result = quizs;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }
}
