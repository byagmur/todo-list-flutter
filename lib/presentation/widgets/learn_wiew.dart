import 'package:flutter/material.dart';

const data = 'selam';

class LearnWiew extends StatelessWidget {
  const LearnWiew({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("title"),
      ),
      body: Center(
        child: Column(
   children: [

     ElevatedButton(
       style: ElevatedButton.styleFrom(
         shadowColor: Colors.red,
         elevation: 5,

         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(32),

         ),
       ),

       onPressed: () {},
       child: Padding(padding: EdgeInsets.only(top:10,bottom:10,left:20,right:20),
     child: Text("click on me!",
     style: TextStyle
     (
       color: Colors.white,
       fontSize: 20,
       fontWeight: FontWeight.bold,
       fontFamily: 'Poppins',
     ),
     ),

       ))],

        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            // builder?? context???
            builder: (context) => Container(
              height: 200,
            ),
          );
        },

        child: const Icon(Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

     // drawer: const Drawer(), //drawer eklemek için (sol üstteki menü)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card_outlined),
            label: 'School',
          ),
        ],
      ),
    );
  }
}
