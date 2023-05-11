import 'package:flutter/material.dart';
import 'package:otif_input/components/background';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';
import 'package:otif_input/function/insertExcelRow.dart';
import 'package:otif_input/components/save_button.dart';

// import 'package:otif_input/function/insertExcelRow';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final String? title = 'SGA Logística';
  late TextEditingController controller1;
  late TextEditingController controller2;
  DateTime _selectedDate = DateTime.now();
  DateTime selectedDateBegin = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  TextEditingController occurrence = TextEditingController();
  xlsx excel = xlsx();

  void sendDatatoExcel() {
    String id = "";
    String orderStart = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateEnd);
    String orderFinished =
        DateFormat('dd/MM/yyyy HH:mm').format(selectedDateEnd);
    String insertedAt = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    String myOcurrences = occurrence.text.toString();
  
    List<String> dataList = [
      id,
      insertedAt,
      orderStart,
      orderFinished,
      "myOcurrences"
    ];
    excel.insertExcelRow(dataList);
  }

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

  Future<void> _selectDate(BuildContext context, String process) async {
    final DateTime? selected = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: _selectedDate.toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    selectableDayPredicate: (date) {
                      if (date.weekday == 6 || date.weekday == 7) {
                        return false;
                      }
                      return true;
                    },
                    onChanged: (val) {
                      if (process == "start") {
                        setState(() => selectedDateBegin = DateTime.parse(val));
                      } else {
                        setState(() => selectedDateEnd = DateTime.parse(val));
                      }
                    },
                    validator: (val) {
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, _selectedDate),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
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
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ), actions: [
         SaveUrlButton(),
      ],
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
              const Image(
                image: AssetImage('images/logo.png'),
                width: 200,
                height: 120,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Lançamento OTIF Expedição',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.grey,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  children: [
                    const Text("Horário de entrada"),
                    ElevatedButton(
                        onPressed: () => _selectDate(context, "start"),
                        child: Text(DateFormat('dd/MM/yyyy HH:mm')
                            .format(selectedDateBegin))),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                child: Column(
                  children: [
                    const Text("Horário de saída"),
                    ElevatedButton(
                      onPressed: () => _selectDate(context, "end"),
                      child: Text(DateFormat('dd/MM/yyyy HH:mm')
                          .format(selectedDateEnd)),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () => sendDatatoExcel(),
                  child: const Text("teste")),
              const Text("Ocorrências:"),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 120),
                child: TextField(
                  controller: occurrence,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
