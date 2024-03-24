import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/kiosk_slider_items_model.dart';

class ImageCarouselSlider extends StatefulWidget {
  final List<KioskSliderItemsModel> sliderItems;
  final int timer;
  const ImageCarouselSlider({super.key, required this.sliderItems, required this.timer});

  @override
  State<ImageCarouselSlider> createState() => _ImageCarouselSliderState();
}

class _ImageCarouselSliderState extends State<ImageCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        enableInfiniteScroll: false, // Disable infinite scrolling
        viewportFraction: 1.0, // Each image takes full width
        autoPlay: true,
        autoPlayInterval: Duration(seconds: widget.timer),
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      items: widget.sliderItems.map((sliderItem) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(size.height * 0.04)),
                  child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('assets/food_placeholder_image.jpg'),
                      image: NetworkImage(sliderItem.imageUrl)),
                ));
          },
        );
      }).toList(),
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
