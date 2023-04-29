import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;

  double containerSize = 200;
  bool switchSize = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _heightAnimation =
        Tween<Size>(begin: const Size(300, 300), end: const Size(400, 400))
            .animate(
      CurvedAnimation(
        reverseCurve: Curves.easeOut,
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _heightAnimation.addListener(() {
      setState(() {});
    });
    _opacityAnimation = Tween(begin: 0.7, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 800,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (switchSize == false) {
                      setState(() {
                        switchSize = true;
                        containerSize = 200;
                      });
                    } else {
                      setState(() {
                        switchSize = false;
                        containerSize = 400;
                      });
                    }
                  },
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: AnimatedContainer(
                      height: containerSize,
                      width: containerSize,
                      color: Colors.pink,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInCirc,
                      child: const Text('Animation'),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_controller.status == AnimationStatus.forward ||
                        _controller.status == AnimationStatus.dismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _heightAnimation,
                    child: const Text('Animation'),
                    builder: (context, container) => Container(
                      alignment: Alignment.center,
                      color: primaryColor,
                      height: _heightAnimation.value.height,
                      width: _heightAnimation.value.width,
                      child: container,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: ((context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(),);
//           } else if (snapshot.hasError) {
//             return erroDialogue(context);
//           } else if (snapshot.hasData) {
//             return HomeScreen();
//           } else {