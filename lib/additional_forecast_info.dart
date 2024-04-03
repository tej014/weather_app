import 'package:flutter/material.dart';

class Additionalforecastinfo extends StatelessWidget
 {
  final IconData icon;
  final String label; 
  final String value;
  const Additionalforecastinfo({
    super.key,
    required this.icon,
    required this.label, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return  Column(children: [ const SizedBox(height: 8,),Icon(icon,size: 40,),const SizedBox(height: 10,), Text(label,style:const TextStyle(fontSize: 16),),const  SizedBox(height: 8,), Text(value,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16))],);
  }
}