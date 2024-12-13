import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<FirebaseApp> _aqua = Firebase.initializeApp();

  String realtimeValue = "0";// default realtime value
  String waterFlowRate = "0";// default water flow rate value
  String realtimeUsage = "0";// default realtime usage value
  String _dropdownValue = '10';// variable for set default quota value
  String? customQuota; // variable for set quota text field

  final user = FirebaseAuth.instance.currentUser!;

  bool isSwitchedPower = false;
  bool isSwitchedAuto = false;
  bool isQuotaClicked = false;

  final TextEditingController _numberInputController = TextEditingController();

  late DatabaseReference powerRef;//Reference to "powerRef"
  late DatabaseReference autoPowerRef;//Reference to "autopower" field
  late DatabaseReference notificationRef;// Reference to "notification" field
  late DatabaseReference waterRef;//Reference to "water" field
  late DatabaseReference flowRateRef;//Reference to "flow rate" field
  late DatabaseReference realtimeUsageRef;//Reference to "realtime" field
  late DatabaseReference usedRef; // Reference to "used" field

  StreamSubscription<DatabaseEvent>? waterSubscription;
  StreamSubscription<DatabaseEvent>? flowRateSubscription;
  StreamSubscription<DatabaseEvent>? realtimeUsageSubscription;

  @override
  void initState() {

    super.initState();
    _loadPreferences();
    _initializeDatabaseReferences();
    _initializeDatabaseListeners();

  }

  void _initializeDatabaseReferences() {

    powerRef = FirebaseDatabase.instance.ref().child('power');// Initialize "power" reference
    autoPowerRef = FirebaseDatabase.instance.ref().child('autopower');// Initialize "auto" reference
    notificationRef = FirebaseDatabase.instance.ref().child('notification');// Initialize "notification" reference
    waterRef = FirebaseDatabase.instance.ref().child('water');// Initialize "water" reference
    flowRateRef = FirebaseDatabase.instance.ref().child('flow_rate');// Initialize "flow_rate" reference
    realtimeUsageRef = FirebaseDatabase.instance.ref().child('usage');// Initialize "usage" reference
    usedRef = FirebaseDatabase.instance.ref().child('used'); // Initialize "used" reference
  }

  void _initializeDatabaseListeners() {

    waterSubscription = waterRef.onValue.listen((event) {
      _onRealtimeValueChange(event.snapshot.value.toString());
    });

    flowRateSubscription = flowRateRef.onValue.listen((event) {
      setState(() {
        waterFlowRate = event.snapshot.value.toString();
      });
    });

    realtimeUsageSubscription = realtimeUsageRef.onValue.listen((event) {
      setState(() {
        realtimeUsage = event.snapshot.value.toString();
      });
    });


  }

  @override
  void dispose() {
    waterSubscription?.cancel();
    flowRateSubscription?.cancel();
    realtimeUsageSubscription?.cancel();
    super.dispose();
  }


  // get the  previous state of the application
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {

      _dropdownValue = prefs.getString('dropdownValue') ?? '10';
      customQuota = prefs.getString('customQuota'); // Load custom quota if set
      isSwitchedPower = prefs.getBool('isSwitchedPower') ?? false;//
      isSwitchedAuto = prefs.getBool('isSwitchedAuto') ?? false;
      realtimeValue = prefs.getString('realtimeValue') ?? "0";

    });

  }

  // save the  previous state of the application
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dropdownValue', _dropdownValue);
    if (customQuota != null) {
      await prefs.setString('customQuota', customQuota!);
    }
    await prefs.setBool('isSwitchedPower', isSwitchedPower);
    await prefs.setBool('isSwitchedAuto', isSwitchedAuto);
    await prefs.setString('realtimeValue', realtimeValue);
  }



  void _checkAndUpdatePowerStatus() {
    double cloudValue = double.parse(realtimeValue);
    double presetValue = double.parse(customQuota ?? _dropdownValue); // Use custom quota if set

    if (cloudValue > presetValue) {

      // Update the "used" field in Firebase
      _updateUsedField(cloudValue);

      if (isSwitchedAuto) {
        autoPowerRef.set(true);
        isSwitchedPower = false;
        powerRef.set(isSwitchedPower);
      }

    } else {
      autoPowerRef.set(false);
    }
  }

//----------------------------------------------------------------------

  Future<void> _updateUsedField(double cloudValue) async {
    try {
      await usedRef.set(customQuota); // update the "used" field
    } catch (e) {
      print("Failed to update 'used' field: $e"); // otherwise print error message in the console
    }
  }
//------------------------------------------------------------------------



  void _notificationTrue() {
    notificationRef.set(true);
  }

  void _notificationFalse() {
    notificationRef.set(false);
  }

  void _onRealtimeValueChange(String newValue) {
    setState(() {
      realtimeValue = newValue;
      _savePreferences();
      _checkAndUpdatePowerStatus();
    });
  }

  void _onAutoPowerSwitchChange(bool value) {
    setState(() {
      isSwitchedAuto = value;
      _savePreferences();
      _checkAndUpdatePowerStatus();
    });
  }

  void _signUserOut() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        );
      },
    );

    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double litres = double.parse(realtimeUsage) / 1000.0;
    double cloudValue = double.parse(realtimeValue);
    double percentValue = double.parse(customQuota ?? _dropdownValue); // Use custom quota if set
    int intPercentValue = percentValue.toInt();

    if (cloudValue > percentValue) {
      cloudValue = percentValue;
    }

    double newValue = percentValue;
    double newPercentValue = newValue / percentValue;
    double cloudValuePercent = cloudValue / percentValue;
    double updatedPercentValue = (newPercentValue - cloudValuePercent);

    if (updatedPercentValue == 0.2) {
      _notificationTrue();
    } else {
      _notificationFalse();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(color: Colors.white, height: 0),
        ),
        actions: [
          IconButton(
            onPressed: _signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue, Colors.grey]),
          ),
        ),
        centerTitle: false,
        title: const Text(
          "Dashboard",
          style: TextStyle(fontFamily: "roboto", color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.blueGrey]),
              ),
              child: Text(
                "Welcome,",
                style: TextStyle(fontFamily: "roboto", fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white, Colors.white]),
            ),
            child: Column(
              children: [
                const Text(
                  "Water Quota",
                  style: TextStyle(fontFamily: "kinetika", fontSize: 18, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CircularPercentIndicator(
                    key: const PageStorageKey('percentIndicator'),
                    radius: 90,
                    lineWidth: 15,
                    percent: updatedPercentValue,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.blue.shade100,
                    circularStrokeCap: CircularStrokeCap.round,
                    animateFromLastPercent: true,
                    animation: true,
                    center: Text(
                      "$cloudValue/$intPercentValue L",
                      style: const TextStyle(
                        fontFamily: "kinetika",
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Realtime Usage: $realtimeUsage L",
                    style: const TextStyle(
                      fontFamily: "kinetika",
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      _buildActionButton(
                        label: 'Reset Usage',
                        onPressed: () {
                          setState(() {
                            realtimeUsage = '0';
                            _savePreferences();
                          });
                        },
                      ),
                      _buildActionButton(
                        label: 'Clear Quota',
                        onPressed: () {
                          setState(() {
                            _dropdownValue = '10';
                            customQuota = null; // Reset custom quota
                            realtimeValue = '0';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Water Flow Rate: $waterFlowRate ml/min",
                    style: const TextStyle(
                      fontFamily: "kinetika",
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSwitchColumn(),
                    _buildQuotaColumn(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          child: Text(label),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[600],
            textStyle: const TextStyle(fontFamily: 'kinetika', fontSize: 16),
            minimumSize: const Size(10, 40),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildSwitchColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const Text(
            "Valve On/Off",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "kinetika"),
          ),
          Switch(
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade300,
            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            value: isSwitchedPower,
            onChanged: (value) {
              setState(() {
                isSwitchedPower = value;
                powerRef.set(isSwitchedPower); // Update the database's power variable
                _savePreferences();
              });
            },
          ),
          const SizedBox(height: 10),
          const Text(
            "Auto On/Off",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "kinetika"),
          ),
          const SizedBox(height: 10),
          Switch(
            activeColor: Colors.green.shade600,
            activeTrackColor: Colors.green.shade200,
            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            value: isSwitchedAuto,
            onChanged: _onAutoPowerSwitchChange,
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Set Quota (ml)",
            style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: "kinetika"),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            height: 40,
            child: TextField(
              controller: _numberInputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorText: _numberInputController.text.isEmpty ? '' : null, // Error text for empty input
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text('Set'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue[600],
              textStyle: const TextStyle(fontFamily: 'kinetika', fontSize: 16),
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              if (_numberInputController.text.isEmpty) return;

              final waterSnapshot = await waterRef.once();
              realtimeValue = waterSnapshot.snapshot.value.toString(); // update the UI with newly updated quota with Firebase upcoming value
              FocusScope.of(context).unfocus();
              setState(() {
                customQuota = _numberInputController.text;
                _savePreferences();
                _checkAndUpdatePowerStatus();
              });
            },
          ),
        ],
      ),
    );
  }
}
