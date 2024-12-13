import 'package:flutter/material.dart';


class PowerButton extends StatefulWidget {
  const PowerButton({super.key});



  @override
  State<PowerButton> createState() => _PowerButtonState();
}


class _PowerButtonState extends State<PowerButton> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(

          children: <Widget>[
                           Switch(
                              // thumb color (round icon)
                           activeColor: Colors.green.shade600,
                           activeTrackColor: Colors.green.shade200,
                           inactiveThumbColor: Colors.blueGrey.shade600,
                           inactiveTrackColor: Colors.grey.shade400,

                           splashRadius: 50.0,
                              // boolean variable value
                           value: isSwitched,
                             // changes the state of the switch
                           onChanged: (value) => setState(() => isSwitched = value),

                                    ),


          ],
        ),
      ),
    );
  }
}

class AutoButton extends StatefulWidget {
  const AutoButton({super.key});



  @override
  _AutoButtonState createState() => _AutoButtonState();
}

class _AutoButtonState extends State<PowerButton> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Row(

        children: <Widget>[
          Switch(
            // thumb color (round icon)
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade300,

            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            // boolean variable value
            value: isSwitched,
            // changes the state of the switch
            onChanged: (value) => setState(() => isSwitched = value),



          ),

        ],
      ),
    );
  }
}

class DisableSwitch extends StatefulWidget {
  const DisableSwitch({super.key});



  @override
  _DisableSwitchState createState() => _DisableSwitchState();
}

class _DisableSwitchState extends State<DisableSwitch> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Row(

        children: <Widget>[
          Switch(
            // thumb color (round icon)
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade300,

            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            // boolean variable value
            value: isSwitched,
            // changes the state of the switch
            onChanged: (value) => setState(() => isSwitched = value
            ),



          ),


        ],
      ),
    );
  }
}