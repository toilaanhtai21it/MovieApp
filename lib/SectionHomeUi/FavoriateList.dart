import 'package:flutter/material.dart';
import 'package:r08fullmovieapp/SqfLitelocalstorage/NoteDbHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../DetailScreen/checker.dart';

class FavoriateMovies extends StatefulWidget {
  const FavoriateMovies({super.key});

  @override
  State<FavoriateMovies> createState() => _FavoriateMoviesState();
}

class _FavoriateMoviesState extends State<FavoriateMovies> {
  int svalue = 1;

  SortByChecker(int sortvalue) {
    if (sortvalue == 1) {
      return FavMovielist().queryAllSortedDate();
    } else if (sortvalue == 2) {
      return FavMovielist().queryAllSorted();
    } else if (sortvalue == 3) {
      return FavMovielist().queryAllSortedRating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
      appBar: AppBar(
        elevation: MediaQuery.of(context).size.height * 0.06,
        backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
        title: Text('Favoriate Movies'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sort By',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownButton(
                  iconEnabledColor: Colors.white,
                  focusColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  dropdownColor: Color.fromRGBO(18, 18, 18, 0.5),
                  value: svalue,
                  items: [
                    DropdownMenuItem(
                      child: Text('View All',
                          style: TextStyle(color: Colors.white)),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Sort by Name',
                          style: TextStyle(color: Colors.white)),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text('Sort by Rating',
                          style: TextStyle(color: Colors.white)),
                      value: 3,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      svalue = value as int;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              //query all data from database and show in listview builder here
              child: FutureBuilder(
                future: SortByChecker(svalue),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            tileColor: Color.fromRGBO(24, 24, 24, 1),
                            textColor: Colors.white,
                            title: Text(snapshot.data![index]['tmdbname']),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(snapshot.data![index]['tmdbrating']),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(snapshot.data![index]['tmdbtype']),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    // Xác nhận xóa
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor:
                                            Color.fromRGBO(24, 24, 24, 1),
                                        title: Text(
                                          'Remove from Favorites?',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Are you sure you want to remove "${snapshot.data![index]['tmdbname']}" from your favorites?',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    color: Colors.amber)),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      // Xóa mục khỏi cơ sở dữ liệu
                                      await FavMovielist()
                                          .delete(snapshot.data![index]['id']);

                                      // Hiển thị thông báo
                                      Fluttertoast.showToast(
                                        msg: "Removed from Favorites",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor:
                                            Color.fromRGBO(18, 18, 18, 1),
                                        textColor: Colors.white,
                                      );

                                      // Cập nhật danh sách sau khi xóa
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
