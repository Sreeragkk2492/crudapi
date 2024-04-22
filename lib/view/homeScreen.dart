import 'package:crudapi/model/employe_model.dart';
import 'package:crudapi/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController ncontroller = TextEditingController();
  final TextEditingController rcontroller = TextEditingController();
  List<Employee> _employees = [];
  bool isLoading = false;

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ncontroller,
                    decoration: InputDecoration(
                      labelText: 'name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: rcontroller,
                    decoration: InputDecoration(
                      labelText: 'role',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    addEmployee(name: ncontroller.text, role: rcontroller.text);
                    ncontroller.clear();
                    rcontroller.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateBottomSheet({required String id}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ncontroller,
                    decoration: InputDecoration(
                      labelText: 'name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: rcontroller,
                    decoration: InputDecoration(
                      labelText: 'role', 
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    patchEmployee(
                        id: id, name: ncontroller.text, role: rcontroller.text);

                    Navigator.pop(context);
                    setState(() {
                      fetchdata(); 
                    });
                  },
                  child: Text('Update data'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'employee details',
            style: TextStyle(fontSize: 22),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showBottomSheet();
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: (_employees.isEmpty || _employees.length == 0)
            ? Center(
                child: Text('add employees'),
              )
            : isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_employees[index].name ?? ''),
                        subtitle: Text(_employees[index].role ?? ''),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                onPressed: () {
                                  ncontroller.text =
                                      _employees[index].name ?? '';
                                  rcontroller.text =
                                      _employees[index].role ?? '';
                                  _updateBottomSheet(
                                      id: _employees[index].id.toString());
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  delete(id: _employees[index].id.toString());
                                  setState(() {
                                    fetchdata();
                                  });
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    }));
  }

  Future<void> fetchdata() async {
    setState(() {
      isLoading = true;
    });
    final response = await Apiservice.getdata();

    if (response != null) {
      final result = Employees.fromJson(response);
      _employees = result.employeelist ?? [];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch employee list")));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> delete({
    required String id,
  }) async {
    setState(() {
      isLoading = true;
    });
    final response = await Apiservice.deletedata(endpoint: "/employees/$id/");

    if (response != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully deleted")));
      await fetchdata();
    } else {
      print(response);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addEmployee({required String name, required String role}) async {
    setState(() {
      isLoading = true;
    });
    final response = await Apiservice.postdata(
        endpoint: 'employees/create/', data: {'name': name, 'role': role});

    if (response != null) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Successfully added")));
      });
      await fetchdata();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));

      throw Exception('Failed to load album');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> patchEmployee(
      {required String id, required String name, required String role}) async {
    setState(() {
      isLoading = true;
    });
    final response = await Apiservice.updatedata(
        endpoint: 'employees/update/$id/', data: {'name': name, 'role': role});

    if (response != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully Updated")));
      await fetchdata();
    } else {
      print(response);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));

      throw Exception('Failed to load album');
    }
    setState(() {
      isLoading = false;
    });
  }
}
