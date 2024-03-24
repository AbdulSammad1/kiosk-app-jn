import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderWidgetInDialog extends StatefulWidget {
  final List<String> imageUrls;

  const SliderWidgetInDialog({super.key, required this.imageUrls});

  @override
  State<SliderWidgetInDialog> createState() => _SliderWidgetInDialogState();
}

class _SliderWidgetInDialogState extends State<SliderWidgetInDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          items: widget.imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.025),
                      child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage('assets/food_placeholder_image.jpg'),
                          image: NetworkImage(imageUrl)),
                    ));
              },
            );
          }).toList(),
        ),
        widget.imageUrls.length != 1
            ? Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.imageUrls.length,
                    (index) => buildIndicator(index),
                  ),
                ),
              )
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? Colors.white : Colors.grey,
      ),
    );
  }

  int currentIndex = 0; // Track the current index
}
