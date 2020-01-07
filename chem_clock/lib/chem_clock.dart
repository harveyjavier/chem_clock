import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_clock_helper/model.dart';
import 'package:chem_clock/particles.dart';
import 'package:chem_clock/draw_particles.dart';

enum _Element { background, text, shadow, particle, gradient }

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.black,
  _Element.shadow: Colors.white,
  _Element.particle: Colors.white.withAlpha(150),
  _Element.gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE4EFE9),
      Color(0xFF93A5CF),
    ],
  ),
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
  _Element.particle: Colors.black.withAlpha(150),
  _Element.gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF434343),
      Color(0xFF000000),
    ],
  ),
};

class ChemClock extends StatefulWidget {
  const ChemClock(this.model);

  final ClockModel model;

  @override
  _ChemClockState createState() => _ChemClockState();
}

class _ChemClockState extends State<ChemClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _elements;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _fetchData();
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(ChemClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _fetchData() async {
    String e = await DefaultAssetBundle.of(context)
        .loadString("assets/json/elements.json");
    setState(() {
      _elements = json.decode(e);
    });
    print(_elements);
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  _returnElement(str, key) {
    int number = int.parse(str);
    String element;

    _elements.forEach((e) {
      int atomic_number = int.parse(e["atomic_number"]);
      if (atomic_number == number) {
        element = key == "atomic_number" ? e[key].toString() : e[key];
      }
    });

    return element;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final hour =
        DateFormat(widget.model.is24HourFormat ? "HH" : "h").format(_dateTime);
    final minute = DateFormat("mm").format(_dateTime);
    final second = DateFormat("ss").format(_dateTime);
    final am_pm = DateFormat("a").format(_dateTime);
    final defaultTextStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: "Quicksand_Medium",
      fontSize: 23,
    );
    final detailsTextStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: "Quicksand_Medium",
      fontSize: 17,
    );
    final symbolTextStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: "Quicksand_Bold",
      fontSize: 50,
    );

    return Container(
      decoration: BoxDecoration(gradient: colors[_Element.gradient]),
      child: CircularParticle(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: colors[_Element.text]),
                ),
                width: (width / 4),
                height: (width / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: int.parse(hour) == 0
                      ? <Widget>[
                          Icon(
                            FontAwesomeIcons.atom,
                            color: colors[_Element.text],
                            size: 60,
                          ),
                        ]
                      : <Widget>[
                          Text(
                            _returnElement(hour, "atomic_number"),
                            style: detailsTextStyle,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            _returnElement(hour, "symbol"),
                            style: symbolTextStyle,
                          ),
                          Text(
                            _returnElement(hour, "name"),
                            style: detailsTextStyle,
                          ),
                        ],
                ),
              ),
              Text("   "),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: colors[_Element.text]),
                ),
                width: (width / 4),
                height: (width / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: int.parse(minute) == 0
                      ? <Widget>[
                          Icon(
                            FontAwesomeIcons.atom,
                            color: colors[_Element.text],
                            size: 60,
                          ),
                        ]
                      : <Widget>[
                          Text(
                            _returnElement(minute, "atomic_number"),
                            style: detailsTextStyle,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            _returnElement(minute, "symbol"),
                            style: symbolTextStyle,
                          ),
                          Text(
                            _returnElement(minute, "name"),
                            style: detailsTextStyle,
                          ),
                        ],
                ),
              ),
              Text("   "),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 5, color: colors[_Element.text]),
                ),
                width: (width / 4),
                height: (width / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: int.parse(second) == 0
                      ? <Widget>[
                          Icon(
                            FontAwesomeIcons.atom,
                            color: colors[_Element.text],
                            size: 60,
                          ),
                        ]
                      : <Widget>[
                          Text(
                            _returnElement(second, "atomic_number"),
                            style: detailsTextStyle,
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            _returnElement(second, "symbol"),
                            style: symbolTextStyle,
                          ),
                          Text(
                            _returnElement(second, "name"),
                            style: detailsTextStyle,
                          ),
                        ],
                ),
              ),
            ]),
            SizedBox(height: 20.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(hour + ":" + minute + ":" + second + " " + am_pm,
                  style: defaultTextStyle),
            ]),
          ],
        ),
        awayRadius: 80,
        numberOfParticles: 200,
        speedOfParticles: 1,
        height: height,
        width: width * 0.82,
        particleColor: colors[_Element.particle],
        awayAnimationDuration: Duration(milliseconds: 600),
        maxParticleSize: 8,
        isRandSize: true,
        isRandomColor: false,
        awayAnimationCurve: Curves.easeInOutBack,
        enableHover: true,
        hoverColor: Colors.white,
        hoverRadius: 90,
        connectDots: true,
      ),
    );
  }
}
