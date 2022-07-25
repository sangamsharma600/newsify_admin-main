import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({Key? key, required this.message}) : super(key: key);

  final String message;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blue,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: 15.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),

        ),
        child: Padding(
          padding:  const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const SizedBox(
                width: 6.0,
              ),
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              const SizedBox(width: 26.0,),
              Text(message,style: const TextStyle(
                color: Colors.black,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}