import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sbhconst/Components/Navigators.dart';
import 'package:sbhconst/Login/LoginWidget.dart';

class InitialSetup extends StatefulWidget {
  const InitialSetup({super.key});

  @override
  State<InitialSetup> createState() => _InitialSetupState();
}

class _InitialSetupState extends State<InitialSetup> {
  final images = [
  "https://via.placeholder.com/313x281",
  "https://via.placeholder.com/357x281",
  "https://via.placeholder.com/221x228",
  "https://via.placeholder.com/379x295",
  ];
  final messages = [
    "Get connected with a college buddy from your dream universities!",
    "Have one on one live sessions with your college buddy!",
    "Get Answers to all your Questions!",
    "Let's Get Started!"
  ];
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit:StackFit.loose,
      children: [
        PageView.builder(
          physics: const ScrollPhysics(),
          controller: _pageController,
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            if(index <=2){
              return
                Scaffold(
                    backgroundColor: HexColor("#1b2a61"),
                    body:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                          Image.asset("assets/const.png"),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          const Text("Welcome To Const",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Center(child: Image.network(images[index])),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(messages[index],
                                style:const  TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              textAlign: TextAlign.center,),
                            ),
                          ),


                        ]
                    )
                );
            }
            else {
              return Scaffold(
                  backgroundColor: HexColor("#1b2a61"),
                  body:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Image.asset("assets/const.png"),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        const Text("Welcome To Const",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Center(child: Image.network(images[index])),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Center(
                          child: ElevatedButton(
                            onPressed: ()
                            {
                              navigation().navigateToPage(context, LoginWidget());
                            },
                            child:Text(messages[index],
                              style:const  TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,


                            ),

                          ),
                        )


                      ]
                  )
              );
            }
          },
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          right:0.5,
          left:0.5,

          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.jumpToPage(index);
                  },
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
