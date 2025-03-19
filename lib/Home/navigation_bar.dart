import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Featured Partners"),
      ),
      body: const Body(),
    );
  }
}

/// Just for show the scalton we use [StatefulWidget]
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  int demoDataLength = 4;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          // while we dont have our data bydefault we show 3 scalton
          itemCount: isLoading ? 3 : demoDataLength,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: isLoading
                ? const BigCardScalton()
                : RestaurantInfoBigCard(
                    // Images are List<String>
                    images: demoBigImages..shuffle(),
                    name: "McDonald's",
                    rating: 4.3,
                    numOfRating: 200,
                    deliveryTime: 25,
                    foodType: const ["Chinese", "American", "Deshi food"],
                    press: () {},
                  ),
          ),
        ),
      ),
    );
  }
}

class RestaurantInfoBigCard extends StatelessWidget {
  final List<String> images, foodType;
  final String name;
  final double rating;
  final int numOfRating, deliveryTime;
  final bool isFreeDelivery;
  final VoidCallback press;

  const RestaurantInfoBigCard({
    super.key,
    required this.name,
    required this.rating,
    required this.numOfRating,
    required this.deliveryTime,
    this.isFreeDelivery = true,
    required this.images,
    required this.foodType,
    required this.press,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pass list of images here
          BigCardImageSlide(images: images),
          const SizedBox(height: 8),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          PriceRangeAndFoodtype(foodType: foodType),
          const SizedBox(height: 4),
          Row(
            children: [
              RatingWithCounter(rating: rating, numOfRating: numOfRating),
              const SizedBox(width: 8),
              SvgPicture.string(
                clockIconSvg,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "$deliveryTime Min",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SmallDot(),
              ),
              SvgPicture.string(
                deliveryIconSvg,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(isFreeDelivery ? "Free" : "Paid",
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class PriceRangeAndFoodtype extends StatelessWidget {
  const PriceRangeAndFoodtype({
    super.key,
    this.priceRange = "\$\$",
    required this.foodType,
  });

  final String priceRange;
  final List<String> foodType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(priceRange, style: Theme.of(context).textTheme.bodyMedium),
        ...List.generate(
          foodType.length,
          (index) => Row(
            children: [
              buildSmallDot(),
              Text(foodType[index],
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildSmallDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SmallDot(),
    );
  }
}

class BigCardImageSlide extends StatefulWidget {
  const BigCardImageSlide({
    super.key,
    required this.images,
  });

  final List images;

  @override
  State<BigCardImageSlide> createState() => _BigCardImageSlideState();
}

class _BigCardImageSlideState extends State<BigCardImageSlide> {
  int intialIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.81,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                intialIndex = value;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) =>
                BigCardImage(image: widget.images[index]),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: List.generate(
                widget.images.length,
                (index) => DotIndicator(
                  isActive: intialIndex == index,
                  activeColor: Colors.white,
                  inActiveColor: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BigCardImage extends StatelessWidget {
  const BigCardImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class RatingWithCounter extends StatelessWidget {
  const RatingWithCounter({
    super.key,
    required this.rating,
    required this.numOfRating,
  });

  final double rating;
  final int numOfRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rating.toString(),
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: const Color(0xFF010F07).withOpacity(0.74)),
        ),
        const SizedBox(width: 8),
        SvgPicture.string(
          ratingIconSvg,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF22A45D),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text("$numOfRating+ Ratings",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xFF010F07).withOpacity(0.74))),
      ],
    );
  }
}

class SmallDot extends StatelessWidget {
  const SmallDot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}

class BigCardScalton extends StatelessWidget {
  const BigCardScalton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AspectRatio(
          aspectRatio: 1.81,
          child: BigCardImageSlideScalton(),
        ),
        const SizedBox(height: 16),
        ScaltonLine(
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const SizedBox(height: 16),
        const ScaltonLine(),
        const SizedBox(height: 16),
        const ScaltonLine(),
      ],
    );
  }
}

class BigCardImageSlideScalton extends StatelessWidget {
  const BigCardImageSlideScalton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            children: List.generate(4, (index) => const DotIndicator()),
          ),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.activeColor = const Color(0xFF22A45D),
    this.inActiveColor = const Color(0xFF868686),
  });

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 5,
      width: 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

class ScaltonLine extends StatelessWidget {
  const ScaltonLine({
    super.key,
    this.height = 15,
    this.width = double.infinity,
  });

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.black.withOpacity(0.08),
    );
  }
}

List<String> demoBigImages = [
  "https://i.postimg.cc/VsTTkQ1j/big-1.png",
  "https://i.postimg.cc/xTzZkxTB/big-2.png",
  "https://i.postimg.cc/jSKrR0QM/big-3.png",
  "https://i.postimg.cc/90TvjJ43/big-4.png",
];

const clockIconSvg = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M4 12C4 16.4183 7.58172 20 12 20C16.4183 20 20 16.4183 20 12C20 7.58172 16.4183 4 12 4C7.58172 4 4 7.58172 4 12ZM12.0422 7.11111H11.9671C11.7349 7.11111 11.5418 7.28991 11.524 7.52147L11.1393 12.5227C11.1229 12.7352 11.2598 12.9294 11.4655 12.9855L15.5712 14.1053C15.6003 14.1132 15.6304 14.1172 15.6605 14.1172C15.848 14.1172 16 13.9653 16 13.7778V13.5913C16 13.4318 15.9145 13.2845 15.7761 13.2054L12.8889 11.5556L12.4845 7.51133C12.4617 7.28413 12.2706 7.11111 12.0422 7.11111Z" fill="#010F07"/>
</svg>
''';

const deliveryIconSvg = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12ZM12.0422 4.5C11.6049 4.5 11.2505 4.85444 11.2505 5.29167V6.38655C11.1896 6.39982 11.1288 6.41399 11.0681 6.42908C10.5649 6.55408 10.1131 6.75158 9.71257 7.02158C9.31207 7.29158 8.9886 7.63658 8.74214 8.05658C8.49569 8.47658 8.37246 8.98158 8.37246 9.57158C8.37246 10.0516 8.45204 10.4591 8.61121 10.7941C8.77038 11.1291 8.9809 11.4141 9.24276 11.6491C9.50462 11.8841 9.80242 12.0766 10.1362 12.2266C10.4699 12.3766 10.8114 12.5066 11.1605 12.6166C11.5199 12.7266 11.8408 12.8291 12.1232 12.9241C12.4056 13.0191 12.6418 13.1241 12.8318 13.2391C13.0218 13.3541 13.1681 13.4816 13.2708 13.6216C13.3735 13.7616 13.4248 13.9316 13.4248 14.1316C13.4248 14.3416 13.3838 14.5216 13.3016 14.6716C13.2194 14.8216 13.1091 14.9416 12.9704 15.0316C12.8318 15.1216 12.6701 15.1866 12.4852 15.2266C12.3004 15.2666 12.1104 15.2866 11.9153 15.2866C11.484 15.2866 11.0501 15.1791 10.6137 14.9641C10.1772 14.7491 9.82553 14.4816 9.55853 14.1616L7.83333 15.8716C8.31598 16.3616 8.92185 16.7391 9.65096 17.0041C10.1711 17.1931 10.7043 17.3147 11.2505 17.3689V18.7083C11.2505 19.1456 11.6049 19.5 12.0422 19.5H12.0803C12.5175 19.5 12.8719 19.1456 12.8719 18.7083V17.324C13.074 17.2906 13.2737 17.2465 13.471 17.1916C13.9742 17.0516 14.4209 16.8366 14.8112 16.5466C15.2014 16.2566 15.512 15.8891 15.7431 15.4441C15.9741 14.9991 16.0896 14.4716 16.0896 13.8616C16.0896 13.3316 15.9818 12.8891 15.7662 12.5341C15.5505 12.1791 15.2784 11.8816 14.9498 11.6416C14.6212 11.4016 14.2566 11.2091 13.8561 11.0641C13.4556 10.9191 13.0706 10.7866 12.7009 10.6666C12.4441 10.5866 12.2131 10.5091 12.0077 10.4341C11.8023 10.3591 11.6252 10.2766 11.4763 10.1866C11.3274 10.0966 11.2144 9.99158 11.1374 9.87158C11.0604 9.75158 11.0219 9.60158 11.0219 9.42158C11.0219 9.21158 11.0707 9.03908 11.1682 8.90408C11.2658 8.76908 11.3864 8.65908 11.5302 8.57408C11.674 8.48908 11.8357 8.43158 12.0154 8.40158C12.1951 8.37158 12.3723 8.35658 12.5468 8.35658C12.8857 8.35658 13.2374 8.43908 13.602 8.60408C13.9665 8.76908 14.2618 8.99158 14.4877 9.27158L16.1667 7.54658C15.684 7.11658 15.1218 6.79158 14.48 6.57158C13.9347 6.38467 13.3987 6.27716 12.8719 6.24904V5.29167C12.8719 4.85444 12.5175 4.5 12.0803 4.5H12.0422Z" fill="#010F07"/>
</svg>
''';

const ratingIconSvg = '''
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12 17L8.59634 18.7894C8.18897 19.0036 7.68511 18.8469 7.47094 18.4396C7.38566 18.2774 7.35623 18.0916 7.38721 17.9109L8.03725 14.1209L5.28364 11.4368C4.95407 11.1155 4.94733 10.5879 5.26858 10.2584C5.3965 10.1271 5.56412 10.0417 5.74548 10.0154L9.55088 9.46243L11.2527 6.01415C11.4564 5.60144 11.9561 5.43199 12.3688 5.63568C12.5331 5.71679 12.6662 5.84981 12.7473 6.01415L14.4491 9.46243L18.2545 10.0154C18.7099 10.0816 19.0255 10.5044 18.9593 10.9599C18.933 11.1413 18.8476 11.3089 18.7163 11.4368L15.9627 14.1209L16.6128 17.9109C16.6906 18.3645 16.3859 18.7953 15.9323 18.8731C15.7517 18.9041 15.5659 18.8747 15.4036 18.7894L12 17Z" fill="#010F07"/>
</svg>
''';
