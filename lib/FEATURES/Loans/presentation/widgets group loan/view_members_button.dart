// import 'package:flutter/material.dart';

// class ViewMembersButton
//     extends StatelessWidget {
//   final VoidCallback onTap;

//   const ViewMembersButton({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 52,
//       child: ElevatedButton(
//         onPressed: onTap,
//         child: const Text(
//           "View Members",
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ViewMembersButton extends StatelessWidget {
  final VoidCallback onTap;

  const ViewMembersButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF38B2AC),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          "View Members",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}