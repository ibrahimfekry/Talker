import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class MenuScreen extends StatefulWidget {
  static String id = 'MenuScreen';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      await fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  Future fetchContacts() async {
    contacts = await ContactsService.getContacts();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {}, child: const Text('Upload Contacts')),
            SizedBox(
              height: 20.h,
            ),
            ListView.builder(
                itemCount: contacts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(contacts[index].displayName!),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(contacts[index].phones![0].value.toString()),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
