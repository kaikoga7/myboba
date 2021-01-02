import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myboba/services/firebase/firestore_data_management_helper.dart';
import 'package:myboba/ui/staff/screens/status_page/create_update_status.dart';

class ReadStatus extends StatelessWidget {
  final _firestore = FirestoreDataManagementHelper.firestore;
  final _staffFirestoreHelper = FirestoreDataManagementHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'STATUS',
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('status').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot _status = snapshot.data.docs[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateUpdateStatus(statusDoc: _status),
                            ),
                          );
                        },
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        leading: CircleAvatar(
                          radius: 50.0,
                          child: FittedBox(
                            child: Text(
                              '${index + 1}',
                            ),
                          ),
                        ),
                        title: Text(_status['name']),
                        subtitle: Text(_status['description']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            bool _isError;
                            _isError = await _staffFirestoreHelper.deleteStatus(
                                docId: _status.id, status: _status['name']);
                            _isError
                                ? Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Failed to delete!')))
                                : Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Delete completed!')));
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateUpdateStatus()));
        },
      ),
    );
  }
}
