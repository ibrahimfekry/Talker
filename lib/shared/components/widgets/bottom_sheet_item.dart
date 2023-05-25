import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class BottomSheetItem extends StatelessWidget{
  var onTap;
  String? backgroundUrl;
  String? imageUrl;
  String? imageUrl2;

  BottomSheetItem({super.key, this.backgroundUrl, this.imageUrl, this.imageUrl2, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('$backgroundUrl'),
          SvgPicture.asset('$imageUrl'),
          if(imageUrl2 != null)
            SvgPicture.asset('$imageUrl2'),
        ],
      ),
    );
  }
}