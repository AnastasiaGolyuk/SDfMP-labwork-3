import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:relax_app/consts/consts.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({Key? key}) : super(key: key);

  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(
      Slide(
          title: "Upload images",
          description: "Upload images to your profile!",
          pathImage: "assets/images/images_screen.png"),
    );
    slides.add(
      Slide(
          title: "View the horoscope",
          description: "See your and other horoscopes for today!",
          pathImage: "assets/images/horoscope_screen.png"),
    );
    slides.add(
      Slide(
          title: "Choose mood",
          description: "Choose your mood and listen to recommendations!",
          pathImage: "assets/images/rec_screen.png"),
    );
    slides.add(
      Slide(
          title: "Calculate BMI",
          description:
              "Calculate BMI for any weight and height!",
          pathImage: "assets/images/bmi_screen.png",
      ),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = [];
    int length = slides.length;
    for (int i = 0; i < length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(
        SizedBox(
          width: Consts.getWidth(context),
          height: Consts.getHeight(context),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 500,
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    currentSlide.pathImage.toString(),
                    width: 400,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      currentSlide.title.toString(),
                      style: const TextStyle(color: Consts.contrastColor, fontSize: 25),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      currentSlide.description.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      backgroundColorAllSlides: Consts.darkColor,
      renderSkipBtn:
          const Text("Skip", style: TextStyle(color: Colors.white)),
      renderNextBtn: const Text("Next", style: TextStyle(color: Consts.contrastColor)),
      renderDoneBtn: const Text("Done", style: TextStyle(color: Consts.contrastColor)),
      colorActiveDot: Consts.contrastColor,
      sizeDot: 8,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: renderListCustomTabs(),
      scrollPhysics: const BouncingScrollPhysics(),
      onDonePress: () {
        Navigator.pop(context);
      },
    );
  }
}
