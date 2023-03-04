import 'package:flutter/material.dart';

Widget inputField(
    String title, String hintText, dynamic icon, dynamic controller) {
  return Container(
    padding:
        const EdgeInsets.only(top: 5.0, left: 30.0, right: 30.0, bottom: 10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(35, 61, 77, 1)),
        ),
        const Padding(padding: EdgeInsets.all(5.0)),
        TextFormField(
          controller: controller,
          cursorWidth: 2,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            contentPadding: const EdgeInsets.all(5),
            fillColor: Colors.grey[200],
            prefixIcon: Icon(
              icon,
              color: Colors.red,
            ),
          ),
        ),
      ],
    ),
  );
}
