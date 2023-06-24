enum QuizStartType {
  today('오늘의 단어, 문장'),
  todayWord('오늘의 단어'),
  todaySentence('오늘의 문장'),
  todayWrong('오늘 틀린 단어, 문장'),
  todayTried('오늘 배운 단어, 문장'),
  todayTriedWord('오늘 배운 단어'),
  todayTriedSentence('오늘 배운 문장'),
  important('중요한 단어, 문장'),
  importantWord('중요한 단어'),
  importantSentence('중요한 문장');

  final String text;
  const QuizStartType(this.text);
}
