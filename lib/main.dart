import 'package:flutter/material.dart';
import 'package:otif_input/components/background';
import 'package:date_time_picker/date_time_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class _MyHomePage extends StatefulWidget {
  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  bool _useCurrentDateBegin = true;
  bool _useCurrentDateEnd = true;
  final String? title = 'Lançamento OTIF Expedição';
  late TextEditingController controller1;
  late TextEditingController controller2;

  void _handleRadioChangedBegin(bool? value) {
    setState(() {
      _useCurrentDateBegin = value ?? true;
    });
  }

  void _handleRadioChangedEnd(bool? value) {
    setState(() {
      _useCurrentDateEnd = value ?? true;
    });
    DateTimePicker(
      initialValue: '',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dateLabelText: 'Date',
      onChanged: (val) => print(val),
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );
  }

  @override
  void initState() {
    controller1 = TextEditingController(text: DateTime.now().toString());
    controller2 = TextEditingController(text: DateTime.now().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title!,
          style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(fit: StackFit.expand, children: [
        const ContainerBackground(),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2.0,
                blurRadius: 2.0,
                offset: const Offset(-1, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //ENTRADA
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data de entrada:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Usar data/hora atual'),
                            value: true,
                            groupValue: _useCurrentDateBegin,
                            onChanged: _handleRadioChangedBegin,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Inserir manualmente'),
                            value: false,
                            groupValue: _useCurrentDateBegin,
                            onChanged: _handleRadioChangedBegin,
                          ),
                        ),
                      ],
                    ),
                    if (_useCurrentDateBegin == false)
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            controller: controller2,
                            //initialValue: _initialValue,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'Date',
                            timeLabelText: "Hour",
                            //use24HourFormat: false,
                            //locale: Locale('pt', 'BR'),
                            selectableDayPredicate: (date) {
                              if (date.weekday == 6 || date.weekday == 7) {
                                return false;
                              }
                              return true;
                            },
                            onChanged: (val) =>
                                setState(() => print("changed")),
                            validator: (val) {
                              setState(() => print("validating"));
                              return null;
                            },
                            onSaved: (val) => print("saved")),
                      ),
                  ],
                ),
              ),

              // SAIDA
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data de saída:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Usar data/hora atual'),
                            value: true,
                            groupValue: _useCurrentDateEnd,
                            onChanged: _handleRadioChangedEnd,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Inserir manualmente'),
                            value: false,
                            groupValue: _useCurrentDateEnd,
                            onChanged: _handleRadioChangedEnd,
                          ),
                        ),
                      ],
                    ),
                    if (_useCurrentDateEnd == false)
                      Container(
                        margin: EdgeInsets.all(15),
                        child: DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM, yyyy',
                            controller: controller1,
                            //initialValue: _initialValue,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            icon: const Icon(Icons.event),
                            dateLabelText: 'Date',
                            timeLabelText: "Hour",
                            //use24HourFormat: false,
                            //locale: Locale('pt', 'BR'),
                            selectableDayPredicate: (date) {
                              if (date.weekday == 6 || date.weekday == 7) {
                                return false;
                              }
                              return true;
                            },
                            onChanged: (val) =>
                                setState(() => print("changed")),
                            validator: (val) {
                              setState(() => print("validating"));
                              return null;
                            },
                            onSaved: (val) => print("saved")),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
