import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// بتعمل ChangeNotifier علشان تدير الحالة
class Counter with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();  // ده عشان تخلي الـ widgets تتحدث لما القيمة تتغير
  }
}

void main() {
  runApp(
    // بتعمل Provider عشان تدي كل الـ widgets في الـ app الوصول للـ Counter class
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Provider Example')),
        body: Center(
          // هنا بنستخدم Consumer عشان نعرض الـ counter
          child: Consumer<Counter>(
            builder: (context, counter, child) {
              return Text('Counter Value: ${counter.counter}');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // بنعمل Increment للـ counter لما الـ button يتضغط
            context.read<Counter>().increment();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
