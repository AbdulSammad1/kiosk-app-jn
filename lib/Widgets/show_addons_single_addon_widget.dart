import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/add_ons_model.dart';

class ShowAddonsSingleAddonWidget extends StatefulWidget {
  const ShowAddonsSingleAddonWidget(
      {super.key, required this.addon, required this.ontap});
  final AddOnsModel addon;
  final Function() ontap;

  @override
  State<ShowAddonsSingleAddonWidget> createState() =>
      _ShowAddonsSingleAddonWidgetState();
}

class _ShowAddonsSingleAddonWidgetState
    extends State<ShowAddonsSingleAddonWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.height * 0.006)),
              elevation: 5,
              margin: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.006),
                ),
                width: size.width * 0.33,
                height: size.height * 0.075,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.height * 0.006),
                      bottomLeft: Radius.circular(size.height * 0.006)),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.addon.image),
                    placeholder:
                        const AssetImage('assets/food_placeholder_image.jpg'),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                border: widget.addon.quantity == 0
                    ? null
                    : Border.all(width: 5, color: Colors.green),
                borderRadius: BorderRadius.circular(size.height * 0.006),
              ),
              width: size.width * 0.33,
              height: size.height * 0.075,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.addon.title,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    '\$${widget.addon.salePrice.toStringAsFixed(1)}',
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.003,
              right: size.width * 0.01,
              child: Icon(
                widget.addon.quantity == 1
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: widget.addon.quantity == 1 ? Colors.green : Colors.white,
                size: size.height * 0.025,
              ),
            )
          ],
        ),
      ),
    );
  }
}
