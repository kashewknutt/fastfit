import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'UserModel.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Expanded(
              child: ProfileInfo(),
            ),
            Expanded(
              flex: 2,
              child: TabBarView(
                children: [
                  WeightHeightTable(),
                  Graph(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddDataDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            UserModel? userData = UserModel.fromJson((snapshot.data?.data() as Map<String, dynamic>?) ?? {});
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileField(label: 'Name', value: userData?.name ?? 'N/A'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black87),
          children: [
            TextSpan(text: '$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class WeightHeightTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataStream = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('entries').snapshots();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Weight and Height Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: dataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                return _buildTable(dataList);
              }
            },
          ),
        ],
      ),
    );
  }


  Widget _buildTable(List<Map<String, dynamic>> dataList) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Weight (kg)')),
        DataColumn(label: Text('Height (cm)')),
      ],
      rows: dataList.map((data) {
        return DataRow(
          cells: [
            DataCell(Text(data['date'].toString())),
            DataCell(Text(data['weight'].toString())),
            DataCell(Text(data['height'].toString())),
          ],
        );
      }).toList(),
    );
  }
}


class Graph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataStream = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('entries').snapshots();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Graph Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: dataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                return _buildGraph(dataList);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGraph(List<Map<String, dynamic>> dataList) {
    // Placeholder for graph implementation
    // You can use packages like 'fl_chart' or 'charts_flutter' to plot graphs
    // For demonstration purposes, let's return a placeholder container
    return Container(
      width: 300,
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Text('Placeholder for Graph'),
      ),
    );
  }
}

class AddDataDialog extends StatelessWidget {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Weight and Height'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Weight (kg)'),
          ),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Height (cm)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Upload data to Firestore
            String weight = weightController.text;
            String height = heightController.text;
            String? userId = FirebaseAuth.instance.currentUser?.uid;
            if (userId != null) {
              FirebaseFirestore.instance.collection('users').doc(userId).collection('entries').add({
                'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Format the date
                'height': double.parse(height),
                'weight': double.parse(weight),
              });
            }
            // Once uploaded, dismiss the dialog
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            // Dismiss the dialog without saving
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
