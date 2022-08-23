import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ummah/utils/constant.dart';
import 'package:ummah/methods/firestore_methods.dart';
import 'package:ummah/utils/utils.dart';

import '../models/user_model.dart';
import '../providers/user_proider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  final TextEditingController _caption = TextEditingController();
  bool _isLoading = false;

  void postImg(String uid, String username) async {
    setState(() => _isLoading = true);
    try {
      String res = await FirestoreMethods()
          .uploadPost(_caption.text, _file!, uid, username);

      if (res == "Sucesssull") {
        setState(() => _isLoading = false);
        clearImg();
        showSnackBar("Posted!", context);
      } else {
        setState(() => _isLoading = false);
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImg() {
    setState(() => _file = null);
    _caption.clear();
  }

  Dispose() {
    super.dispose();
    _caption.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              iconSize: 70,
              icon: Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            backgroundColor: kBackgroundClr,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: clearImg,
              ),
              backgroundColor: kBgColourOfBars,
              title: const Text("Post To"),
              actions: [
                OutlinedButton(
                  onPressed: () => postImg(user!.uid!, user.username!),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.amber)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      maxRadius: 30,
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d2FsbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&w=1000&q=80"),
                    ),
                    SizedBox(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _caption,
                        decoration: const InputDecoration(
                            label: Text(
                              "Write a caption...",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  // NetworkImage(
                                  //     "https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8d2FsbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&w=1000&q=80"),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    Divider()
                  ],
                )
              ],
            ),
          );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() => _file = file);
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Choose From Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() => _file = file);
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
