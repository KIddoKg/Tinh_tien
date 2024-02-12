import 'dart:math';

import 'package:Xi_Zach/helper/formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../router/route.dart';
import 'app_styles.dart';
import 'package:quickalert/quickalert.dart';

class ButtonColor extends StatelessWidget {
  String title;
  Color? backgroundColor;
  Color? fontColor;
  FontWeight fontWeight;
  double fontSize;
  double height;
  bool isSelected;
  void Function()? onTap;

  ButtonColor(this.title,
      {super.key,
      this.onTap,
      this.isSelected = false,
      this.backgroundColor = Colors.transparent,
      this.fontColor = Colors.blue,
      this.fontSize = 20,
      this.height = 60,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: backgroundColor == Colors.transparent
                ? AppColors.primaryColor
                : backgroundColor,
            border: Border.all(
                width: 1,
                color: backgroundColor == Colors.transparent
                    ? AppColors.primaryColor
                    : backgroundColor!),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: !isSelected ? Colors.white : AppColors.primaryColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperTwo(flip: true, reverse: true),
      child: Container(
          height: 50, width: double.infinity, color: AppColors.secondColor),
    );
  }
}

class TextFieldNormal extends StatelessWidget {
  TextEditingController controller;
  bool lock;
  String labelText;

  TextFieldNormal({
    Key? key,
    required this.controller,
    this.lock = false,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 18.0, left: 8.0, right: 8.0, bottom: 10),
        child: TextField(
          // textAlignVertical: TextAlignVertical.center,
          readOnly: lock,
          enableInteractiveSelection: false,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              top: 10, left: 10, // HERE THE IMPORTANT PART
            ),
            labelText: labelText,
            filled: true,
            fillColor: Colors.white,
            // Change the fill color here
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              // Change the border color here
              borderRadius: BorderRadius.circular(20.0),
              // Adjust the border radius as needed
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              // Border color when focused
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFiledWeb extends StatelessWidget {
  TextEditingController controller;
  bool lock;
  String labelText;
  IconData icon;
  bool so;
  int maxline;
  void Function()? onTap;
  void Function()? onTapSub;

  TextFiledWeb({
    super.key,
    required this.controller,
    this.lock = false,
    required this.labelText,
    required this.icon,
    this.onTap,
    this.onTapSub,
    this.so = false,
    this.maxline = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 20),
      child: TextFormField(
        readOnly: lock,
        enableInteractiveSelection: false,
        controller: controller,
        keyboardType: so ? TextInputType.phone : TextInputType.name,
        maxLines: maxline,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryColor,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onEditingComplete: () {
          print("hoan thanh");
        },
        onChanged: (value) {
          if (!value!.isEmpty) {
            print("dddđ");
          }
          return null;
        },
        onTap: () {
          onTap?.call();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "$labelText không được bỏ trống";
          }
          return null;
        },
        onFieldSubmitted: (value) {
          // Check validation when the field loses focus (e.g., submitted)
          if (value.isEmpty) {
            // Update the validation message if needed
            // You can use a state variable to update the message
            print("LLL");
          } else {
            onTapSub?.call();
            print("LLaaL");
          }
        },
      ),
    );
  }
}

class Shadow extends StatelessWidget {
  Widget child;
  Offset direction;
  double radius;

  Shadow(
      {super.key,
      required this.child,
      this.direction = Offset.zero,
      this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(27, 0, 0, 0),
            blurRadius: 12,
            offset: this.direction, // Shadow position
          ),
        ],
      ),
      child: child,
    );
  }
}

class CustomStack extends StatelessWidget {
  const CustomStack({
    required this.image,
    required this.icon,
    required this.text1,
    required this.text2,
    required this.padding_top,
    required this.padding_left,
    required this.padding,
    required this.color,
  });

  final String image;
  final String icon;
  final String text1;
  final String text2;
  final double padding_top;
  final double padding_left;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: padding_top),
          child: Container(
            alignment: Alignment.bottomCenter,
            width: 250,
            height: 380,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset(
                          icon,
                          width: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text1,
                              style: const TextStyle(
                                  color: Color(0xff2D2D2D),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(
                              text2,
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(padding_left, padding, 0, 0),
          child: Image.asset(
            image,
            height: 380,
          ),
        ),
      ],
    );
  }
}

class Room extends StatelessWidget {
  const Room({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(AppRoute.welcome);
        showAlert(context, 'Thông báo',
            'Phần này đang làm nha, đang lười qué');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Stack(
                children: const [
                  Positioned(
                    left: 40,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://john-mohamed.com/wp-content/uploads/2018/05/Profile_avatar_placeholder_large.png'),
                      radius: 25,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://as1.ftcdn.net/v2/jpg/02/88/79/62/1000_F_288796275_NAlmJ0IESWj9EpsuVcSRnOAA79wPCQPQ.jpg'),
                      radius: 25,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.fineartamerica.com/images-medium-5/lost-astronaut-roberta-ferreira.jpg'),
                    radius: 25,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Chơi online',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Tạo phòng chơi ZiZach nào',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff767070)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppBarCus extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String title;
  final Widget? extendBody;
  final Widget? leading;
  final Widget? actions;
  final Widget? bottom;

  const AppBarCus({
    super.key,
    required this.context,
    required this.title,
    this.extendBody,
    this.leading,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Shadow(
// direction: Offset(0, -5),
      child: Container(
// color: Colors.white,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 10.0]),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .07,
            bottom: 25,
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leading != null) leading ?? Container(),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightNeutral5),
                    ),
                    const Spacer(),
                    if (actions == null)
                      const SizedBox(
                        width: 40,
                      ),
                    if (actions != null) actions!,
                  ],
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
// Your existing AppBarCus widget implementation
  }

  @override
  Size get preferredSize => Size.fromHeight(
        MediaQuery.of(context).size.height * 0.07 + 20,
      );
}
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;
  final Widget? extendBody;
  final Widget? leading;
  final Widget? actions;
  final Widget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.extendBody,
    this.leading,
    this.actions,
    this.bottom, required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Shadow(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 10.0],
            ),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (leading != null) leading!,
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                if (actions == null) SizedBox(width: 40),
                if (actions != null) actions!,
              ],
            ),
            if (bottom != null) bottom!,
          ],
        ),
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.07 + 20,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    MediaQuery.of(context).size.height * 0.07 + 20,
  );
}

class HorizontalListView extends StatelessWidget {
  final int index;
  final String time;
  final List<String> data;
  void Function()? onTap;

  HorizontalListView({
    required this.data,
    required this.index,
    this.time = "1707421472765",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shadow(
        radius: 16,
        child: InkWellCir(
          onTap: (){
            onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.sixColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                            10.0), // Set your desired border radius
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: AppColors.sixColor,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  // Set your desired border color
                                  width: 2.0, // Set your desired border width
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Center(
                                  child: Text(
                                "$index",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ))),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Center(
                                child: Text(
                              int.parse(time)
                                  .toDateString(format: 'hh:mm dd/MM/yyyy'),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.sixColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(
                                10.0), // Set your desired border radius
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Đã kết thúc",
                              style: TextStyle(
                                  color: AppColors.primaryRedOr,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 135,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (data.length / 2).ceil(), // Số cột
                    itemBuilder: (context, colIndex) {
                      return Column(
                        children: List.generate(
                          2, // Số hàng trong mỗi cột
                          (rowIndex) {
                            int dataIndex = colIndex * 2 + rowIndex;
                            if (dataIndex < data.length) {
                              return Container(
                                width: 100.0,
                                height: 50.0,
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.sevenColor,
                                  border: Border.all(
                                    color: Colors.white,
                                    // Set your desired border color
                                    width: 2.0, // Set your desired border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Set your desired border radius
                                ),
                                child: Center(
                                  child: Text(
                                    'Item ${data[dataIndex]}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                ),
                              );
                            } else {
                              return Container(); // Trường hợp không có dữ liệu đủ để hiển thị
                            }
                          },
                        ),
                      );
                    },
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

class InkWellCir extends StatelessWidget {
  Widget child;
  void Function()? onTap;
  double radius;
  bool sameColor;

  InkWellCir(
      {super.key,
      required this.child,
      this.radius = 16,
      this.onTap,
      this.sameColor = false});

  @override
  Widget build(BuildContext context) {
    return Material(
// Wrap InkWell with Material and Ink
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          splashColor:
              !sameColor ? AppColors.primaryColor.withOpacity(0.2) : null,
// Màu sẽ xuất hiện khi nhấn và giữ
          highlightColor:
              !sameColor ? AppColors.primaryColor.withOpacity(0.2) : null,
          onTap: () {
            onTap?.call();
          },
          child: child),
    );
  }
}

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final bool valueChoose;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final bool lock;
  final double height;
  final double width;
  final double size;


  AnimatedToggle({
    required this.values,
    this.lock = false,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    required this.buttonColor,
    this.textColor = const Color(0xFF000000), this.valueChoose = false,  this.height=10,  this.width =10, this.size = 450,
  });

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  late bool initialPosition =  widget.valueChoose ? true: false;

  @override
  Widget build(BuildContext context) {

    double size = widget.size;
    return Container(
      width: size*0.6,
      height:widget.height,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (widget.lock == false) {
                initialPosition = !initialPosition;
                var index = 0;
                if (!initialPosition) {
                  index = 1;
                }
                widget.onToggleCallback(index);
              }
              setState(() {});
            },
            child: Container(
              width: size * 0.6,
              height: widget.height,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.values.length,
                      (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: size * 0.08),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.values[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xAA000000),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
            initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: size * 0.33,
              height:widget.height,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: TextStyle(
                  fontSize: 18,
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> showAlertAction(
    BuildContext context, String title, String message, Function()? onTap,
    {List<CupertinoButton>? actions,
      List<ElevatedButton>? actionAndroids}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionAndroids != null)
          ...actionAndroids
        else
          ElevatedButton(
              onPressed: () {
                // Call the onTap function if provided
                onTap?.call();

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Đồng ý'))
      ],
    ),
  );
}
Future<dynamic> showAlert(BuildContext context, String title, String message,
    {List<CupertinoButton>? actions,
      List<ElevatedButton>? actionAndroids}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (actionAndroids != null)
          ...actionAndroids
        else
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Đồng ý'))
      ],
    ),
  );
}

class InkwellCirTap extends StatefulWidget {
  final Widget child;
  final Function onTap;

  InkwellCirTap({required this.child, required this.onTap});

  @override
  _InkwellCirTapState createState() => _InkwellCirTapState();
}

class _InkwellCirTapState extends State<InkwellCirTap> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isTapped ? Colors.green : Colors.transparent,
        ),
        child: widget.child,
      ),
    );
  }
}

Future<bool> onWilldPop(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Yes'),
        ),
      ],
    ),
  ) ?? false;
}

Future<bool> onBackPressed(BuildContext context) async {
  await showAlert(context, 'Thông báo', 'Đã chọn');
  // Return true or false based on your logic
  return true;
}

void showExitDialog(BuildContext context) {
  QuickAlert.show(
    context: context,
    barrierDismissible: false,
    type: QuickAlertType.warning,
    title: 'Cảnh báo',
    text: 'Bạn có muốn thoát khỏi trò chơi?',
    textColor: const Color.fromARGB(255, 60, 60, 60),
    confirmBtnText: 'Có',
    confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
    onConfirmBtnTap: () async {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const LanguageScreen()));
      // Navigator.of(context).popUntil(AppRoute.homeGameZiZach);
      Navigator.popUntil(context, (route) {
        // Replace the condition with your logic
        return route.settings.name == AppRoute.zizach;
      });
    },
    confirmBtnTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    showCancelBtn: true,
    cancelBtnText: 'Không',
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
    cancelBtnTextStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
  );
}

class LoadingDot extends StatelessWidget {
  LoadingDot(
      {super.key, this.text = 'Đang tải dữ liệu', this.style, this.linkLogo});

  String? text;
  TextStyle? style;
  String? linkLogo;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (linkLogo != null)
              Transform.scale(
                  scale: 2,
                  child: Image.network(
                    linkLogo!,
                    width: 40,
                    height: 40,
                  )),
            ColorLoader3(
              radius: 10,
              dotRadius: 6.0,
              centerDot: false,
              dotColor2: AppColors.primaryColor,
              dotColor: AppColors.primaryColor,
              dotQuality: 8,
            ),
            Text(
              text!,
              style: style ?? const TextStyle(color: Colors.grey),
            )
          ],
        ));
  }
}

class ColorLoader2 extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color color3;

  const ColorLoader2(
      {super.key,
        this.color1 = Colors.deepOrangeAccent,
        this.color2 = Colors.yellow,
        this.color3 = Colors.lightGreen});

  @override
  _ColorLoader2State createState() => _ColorLoader2State();
}

class _ColorLoader2State extends State<ColorLoader2>
    with TickerProviderStateMixin {
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    controller2 = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);

    controller3 = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller1,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    animation2 = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller2,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn)));

    animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller3,
        curve: const Interval(0.0, 1.0, curve: Curves.decelerate)));

    controller1.repeat();
    controller2.repeat();
    controller3.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          children: <Widget>[
            RotationTransition(
              turns: animation1,
              child: CustomPaint(
                painter: Arc1Painter(widget.color1),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            RotationTransition(
              turns: animation2,
              child: CustomPaint(
                painter: Arc2Painter(widget.color2),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            RotationTransition(
              turns: animation3,
              child: CustomPaint(
                painter: Arc3Painter(widget.color3),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}

class Arc1Painter extends CustomPainter {
  final Color color;

  Arc1Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p1 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect1 = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    canvas.drawArc(rect1, 0.0, 0.5 * pi, false, p1);
    canvas.drawArc(rect1, 0.6 * pi, 0.8 * pi, false, p1);
    canvas.drawArc(rect1, 1.5 * pi, 0.4 * pi, false, p1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc2Painter extends CustomPainter {
  final Color color;

  Arc2Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p2 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect2 = Rect.fromLTWH(
        0.0 + (0.2 * size.width) / 2,
        0.0 + (0.2 * size.height) / 2,
        size.width - 0.2 * size.width,
        size.height - 0.2 * size.height);

    canvas.drawArc(rect2, 0.0, 0.5 * pi, false, p2);
    canvas.drawArc(rect2, 0.8 * pi, 0.6 * pi, false, p2);
    canvas.drawArc(rect2, 1.6 * pi, 0.2 * pi, false, p2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc3Painter extends CustomPainter {
  final Color color;

  Arc3Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p3 = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect3 = Rect.fromLTWH(
        0.0 + (0.4 * size.width) / 2,
        0.0 + (0.4 * size.height) / 2,
        size.width - 0.4 * size.width,
        size.height - 0.4 * size.height);

    canvas.drawArc(rect3, 0.0, 0.9 * pi, false, p3);
    canvas.drawArc(rect3, 1.1 * pi, 0.8 * pi, false, p3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorLoader3 extends StatefulWidget {
  final double radius;
  final double dotRadius;
  final Color? dotColor;
  final Color? dotColor2;
  final bool centerDot;
  final int dotQuality;

  const ColorLoader3(
      {super.key,
        this.radius = 30.0,
        this.dotRadius = 3.0,
        this.centerDot = true,
        this.dotColor = Colors.white,
        this.dotColor2 = Colors.yellow,
        this.dotQuality = 0});

  @override
  _ColorLoader3State createState() => _ColorLoader3State();
}

class _ColorLoader3State extends State<ColorLoader3>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation_rotation;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  late int visibleDotCount; // Number of visible dots
  int time = 3000;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;
    visibleDotCount = widget.dotQuality;
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleDotCount++; // Show the next dot
          if (visibleDotCount <= 8) {
            controller.forward(from: 0.0); // Start the animation again
          } else {
            controller.repeat(); // Repeat the rotation animation
          }
        });
      }
    });

    controller.forward(); // Start the loading animation
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: <Widget>[
              if (widget.centerDot)
                Transform.translate(
                  offset: const Offset(0.0, 0.0),
                  child: Dot(
                    radius: radius,
                    color: widget.dotColor,
                  ),
                ),
              for (var i = 0; i < 8; i++)
                if (i < visibleDotCount)
                  Transform.translate(
                    offset: Offset(
                      (radius + 10) * cos(i * pi / 4),
                      (radius + 10) * sin(i * pi / 4),
                    ),
                    child: Dot(
                      radius: dotRadius,
                      color: i % 2 == 0 ? widget.dotColor : widget.dotColor2,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  const Dot({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}