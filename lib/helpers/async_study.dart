import 'dart:math';

asyncStudy() {
  //execucaoNoraml();
  //assincronismoBasico();
  //usandoFuncoesAssincronas();
  esperandoFuncoesAssicronas();
}

void execucaoNoraml() {
  print("\nExecucao normal.");
  for (int i = 1; i <= 5; i++) {
    print("0$i");
  }
}

void assincronismoBasico() {
  print("\nAssincronismoBasico");
  print("01");
  print("02");
  Future.delayed(Duration(seconds: 2), () {
    print("03");
  });
  print("04");
  print("05");
}

void usandoFuncoesAssincronas() {
  print("\nUsando funções assíncronas");
  print("A");
  print("B");
  getRandomInt(3, 10).then((value) {
    print("O número aleatório é $value");
  });
  print("C");
  print("D");
}

void esperandoFuncoesAssicronas() async {
  print("A");
  print("B");
  int number = await getRandomInt(4, 10);
  print("O outro número aleatório é $number.");
  print("C");
  print("D");
}

Future<int> getRandomInt(int time, int max) async {
  await Future.delayed(Duration(seconds: time));
  Random rng = Random();
  return rng.nextInt(max);
}
