import 'dart:math';

import 'package:Xi_Zach/helper/appsetting.dart';
import 'package:Xi_Zach/helper/formater.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../router/route.dart';
import 'app_styles.dart';
import 'package:quickalert/quickalert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as cal;
import 'package:bot_toast/bot_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../new_ver/viewModel/zizach_Controller.dart';

class KSButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? fontColor;
  final Color border;
  final FontWeight fontWeight;
  final double fontSize;
  final double height;
  final bool isSelected;
  final bool lock;
  final bool disable;
  final String? icon;
  final bool? isSelectBorder;
  final void Function()? onTap;

  const KSButton(
    this.title, {
    super.key,
    this.onTap,
    this.isSelected = false,
    this.isSelectBorder = false,
    this.backgroundColor,
    this.fontColor,
    this.fontSize = 24,
    this.height = 6.5,
    this.border = Colors.transparent,
    this.icon,
    this.disable = false,
    this.fontWeight = FontWeight.w500,
    this.lock = false,
  });

  @override
  Widget build(BuildContext context) {
    // Background Color
    final Color resolvedBackgroundColor = lock
        ? AppColors.whiteBg
        : (isSelected ? AppColors.whiteBg : AppColors.primaryColor);

    // Border Color
    final Color resolvedBorderColor = lock
        ? AppColors.primaryColorGrey
        : (isSelected ? AppColors.primaryColor : AppColors.whiteBg);

    // Font Color
    final Color resolvedFontColor = lock
        ? AppColors.primaryColorGrey
        : (isSelected ? AppColors.primaryColor : AppColors.whiteBg);

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: resolvedBorderColor,
          width: 1.0,
        ),
      ),
      child: InkWellCir(
        radius: 8,
        onTap: () {
          if (lock) {
            if (onTap == null && disable == false) {
              showAlertIOS(context, "Thông báo", "Hiện tại đang phát triển");
            } else if (disable == true) {
              showAlertIOS(context, "Thông báo", "Chọn ngày");
            }

            return;
          }

          FocusScope.of(context).unfocus();
          loadDataWithLoading();
          onTap?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (icon != null)
                //   SvgPicture.asset(
                //     icon!,
                //     height: 22,
                //     width: 22,
                //     color: lock ? AppColors.primaryGray : AppColors.primaryColor,
                //   ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: fontWeight,
                    color: fontColor ?? resolvedFontColor,
                    // ),
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

class ThreeDotLoading extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotLoading({
    super.key,
    this.color = Colors.blue,
    this.size = 8,
  });

  @override
  State<ThreeDotLoading> createState() => _ThreeDotLoadingState();
}

class _ThreeDotLoadingState extends State<ThreeDotLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // lệch pha theo thứ tự trái → phải (0, 120, 240 độ)
        double phase = index * (2 * cal.pi / 3);

        // dao động sin từ 0 → 1
        double sine = (cal.sin(_controller.value * 2 * cal.pi - phase) + 1) / 2;

        // scale dao động 0.7 → 1.2
        double scale = 0.7 + sine * 0.5;

        // opacity dao động 0.4 → 1.0
        double opacity = 0.4 + sine * 0.6;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, _buildDot),
    );
  }
}

void showCustomLoading({bool moveRoute = false}) {
  BotToast.showCustomLoading(
    toastBuilder: (_) => Center(
      child: ThreeDotLoading(),
    ),
  );
}

Future<void> closeCustomLoading() async {
  await Future.delayed(Duration(milliseconds: 2000));
  BotToast.closeAllLoading();
}

Future<void> loadDataWithLoading(
    {Future<void> Function()? action,
    int milliseconds = 1000,
    bool moveRoute = false}) async {
  showCustomLoading(moveRoute: moveRoute);

  await Future.delayed(Duration(milliseconds: milliseconds));

  if (action != null) {
    await action(); // Chờ action hoàn tất
  }

  await closeCustomLoading(); // Cuối cùng, đóng loading
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

    required this.color,
  });

  final String image;
  final String icon;
  final String text1;
  final String text2;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                  Flexible(
                    // ⭐ Thay Column bằng Flexible để tránh overflow
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          text1,
                          style: const TextStyle(
                              color: Color(0xff2D2D2D),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          overflow:
                              TextOverflow.ellipsis, // ⭐ Thêm overflow handling
                        ),
                        Text(
                          text2,
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          overflow:
                              TextOverflow.ellipsis, // ⭐ Thêm overflow handling
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        showAlert(context, 'Thông báo', 'Phần này đang làm nha, đang lười qué');
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
    this.bottom,
    required this.context,
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
          onTap: () {
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
  final Color KSButton;
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
    required this.KSButton,
    this.textColor = const Color(0xFF000000),
    this.valueChoose = false,
    this.height = 10,
    this.width = 10,
    this.size = 450,
  });

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  late bool initialPosition = widget.valueChoose ? true : false;

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    return Container(
      width: size * 0.6,
      height: widget.height,
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
              height: widget.height,
              decoration: ShapeDecoration(
                color: widget.KSButton,
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
      ) ??
      false;
}

Future<bool> onBackPressed(BuildContext context) async {
  await showAlert(context, 'Thông báo', 'Đã chọn');
  // Return true or false based on your logic
  return true;
}

Future<void> showAlertIOS(BuildContext context, String title, String message,
    {bool? autoPop, void Function()? onTap, void Function()? onTapLeft}) async {
  await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              (onTapLeft != null)
                  ? CupertinoButton(
                      child: const Text('Không'),
                      onPressed: () {
                        if (autoPop == true) {
                          Navigator.pop(context);
                        }
                        onTapLeft();
                        Navigator.pop(context);
                      })
                  : CupertinoButton(
                      child: Text(onTap != null ? "Không" : "Đồng ý"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
              if (onTap != null)
                CupertinoButton(
                    child: const Text('Có'),
                    onPressed: () {
                      if (autoPop == true) {
                        Navigator.pop(context);
                      }
                      onTap();
                      Navigator.pop(context);
                    }),
            ],
          ));

  // if (onTap != null) {
  //   onTap();
  // }
}

void showExitDialog(BuildContext context) {
  QuickAlert.show(
    context: context,
    barrierDismissible: false,
    type: QuickAlertType.warning,
    title: 'Tạm dừng',
    text: 'Bạn có muốn thoát và lưu trò chơi?',
    textColor: const Color.fromARGB(255, 60, 60, 60),
    confirmBtnText: 'Có',
    confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
    onConfirmBtnTap: () async {
      // Chỉ quay lại màn hình trước mà KHÔNG xóa dữ liệu
      // Game vẫn ở trạng thái "in-progress" và có thể tiếp tục sau
      Navigator.popUntil(context, (route) {
        // Quay lại màn hình ZiZach (màn hình lịch sử)
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

void showEndGameDialog(BuildContext context) {
  final controller = Provider.of<ZiZackController>(context, listen: false);

  // Tính tổng điểm cho mỗi người chơi
  List<Map<String, dynamic>> playerScores = [];

  for (int i = 0; i < controller.listCharNew.length; i++) {
    int totalScore = 0;
    for (var round in controller.point) {
      if (i < round.length) {
        totalScore += round[i];
      }
    }
    playerScores.add({
      'name': controller.listCharNew[i],
      'score': totalScore,
    });
  }

  // Sắp xếp theo điểm từ cao xuống thấp
  playerScores.sort((a, b) => b['score'].compareTo(a['score']));

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        'Kết quả trò chơi',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playerScores.length,
                itemBuilder: (context, index) {
                  final player = playerScores[index];
                  final rank = index + 1;
                  Color rankColor = AppColors.primaryColor;
                  IconData? rankIcon;

                  if (rank == 1) {
                    rankColor = Colors.amber;
                    rankIcon = Icons.emoji_events;
                  } else if (rank == 2) {
                    rankColor = Colors.grey[400]!;
                    rankIcon = Icons.emoji_events;
                  } else if (rank == 3) {
                    rankColor = Colors.brown[300]!;
                    rankIcon = Icons.emoji_events;
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: rank <= 3
                          ? rankColor.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: rank <= 3 ? rankColor : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (rankIcon != null)
                            Icon(rankIcon, color: rankColor, size: 24)
                          else
                            CircleAvatar(
                              backgroundColor: AppColors.sixColor,
                              child: Text(
                                '$rank',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        player['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              rank <= 3 ? FontWeight.bold : FontWeight.normal,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      trailing: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              player['score'] >= 0 ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${player['score']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tổng số ván: ${controller.point.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Hủy',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            print('\n🎮 ========== KẾT THÚC GAME ==========');
            print('🎮 Point length: ${controller.point.length}');
            print('🎮 Players: ${controller.listCharNew.length}');
            print(
                '🎮 CurrentSession null? ${controller.currentSession == null}');

            if (controller.currentSession != null) {
              print('🎮 Session ID: ${controller.currentSession!.id}');
              print(
                  '🎮 Session status BEFORE: ${controller.currentSession!.status}');
            }

            // Đóng dialog kết quả
            Navigator.pop(context);

            // Hoàn thành session và lưu vào lịch sử TRƯỚC
            await controller.completeCurrentSession();

            print('🎮 After completeCurrentSession');
            print(
                '🎮 CurrentSession null? ${controller.currentSession == null}');

            // SAU ĐÓ mới reset dữ liệu
            controller.point.clear();
            controller.listOfMaps.clear();
            controller.calPoint.clear();
            controller.listCharNew.clear();
            controller.selectedIndex = -1;
            controller.currentSession = null;

            // Reset các cài đặt chế độ chơi về mặc định
            controller.fOrc = 0; // Tự do
            controller.dOrv = 0; // Điểm
            controller.limitValue = 0; // Không giới hạn
            controller.showTotalScore = false; // Không hiện tổng điểm

            controller.saveListCharNew();

            print('🎮 ========== DONE ==========\n');

            Navigator.popUntil(context, (route) {
              return route.settings.name == AppRoute.zizach;
            });
          },
          child: Text(
            'Kết thúc',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

class KSWindowAreaFittedBox extends StatelessWidget {
  final bool fitTop;
  final bool fitBottom;
  final bool fitLeft;
  final bool fitRight;
  final Color? color;

  const KSWindowAreaFittedBox(
      {this.fitTop = false,
      this.fitBottom = false,
      this.fitLeft = false,
      this.fitRight = false,
      this.color = Colors.transparent,
      super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final padding = media.padding;
    final size = media.size;
    if (fitTop) {
      return _fitBox(size.width, padding.top);
    } else if (fitBottom) {
      return _fitBox(size.width, padding.bottom);
    } else if (fitLeft) {
      return _fitBox(padding.left, null);
    } else if (fitRight) {
      return _fitBox(padding.right, null);
    }
    return Container();
  }

  Widget _fitBox(double width, double? height) => Container(
        width: width,
        height: height,
        color: color!,
      );
}

class KSScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Function? onBack;
  final Widget? bottomNavigationBar;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final EdgeInsets padding;
  final Color? statusBarBackgroundColor;
  final bool safeAreaTop;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final bool safeAreaBottom;
  final PreferredSizeWidget? appbar;
  final bool isDisableFitTop;
  final bool isFitTopAppbar;
  final bool isDisableFitBottom;
  final bool isFitBottomNav;
  final bool showLoadingPage;
  final Widget? floatingActionButton;
  final VoidCallback? onReady; // 👈 thêm callback khởi động sau 2s

  const KSScaffold({
    required this.child,
    this.floatingActionButton,
    this.backgroundColor,
    this.onTap,
    this.onBack,
    this.bottomNavigationBar,
    this.systemUiOverlayStyle = SystemUiOverlayStyle.light,
    this.padding = EdgeInsets.zero,
    this.statusBarBackgroundColor,
    this.safeAreaTop = false,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaBottom = false,
    this.isDisableFitTop = false,
    this.isDisableFitBottom = false,
    this.isFitTopAppbar = false,
    this.isFitBottomNav = false,
    this.showLoadingPage = true,
    this.appbar,
    this.onReady, // 👈 thêm vào constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ToastHelper.init(context);
    return AnnotatedRegion(
      value: systemUiOverlayStyle,
      child: WillPopScope(
        onWillPop: () async {
          // FocusScope.of(context).unfocus();
          // SystemNavigator.pop(); // Thoát app
          return true; // Không pop route vì mình đã thoát app
        },
        child: Scaffold(
          appBar: appbar,
          backgroundColor: backgroundColor ?? Colors.white,
          body: Padding(
            padding: EdgeInsets.only(
              top: !isFitTopAppbar
                  ? 0.0
                  : AppSetting.instance.ios
                      ? 55
                      : 40,
              bottom: !isFitBottomNav
                  ? 0.0
                  : AppSetting.instance.ios
                      ? 8
                      : 0,
            ),
            child: Column(
              children: [
                if (!isDisableFitTop)
                  KSWindowAreaFittedBox(
                    fitTop: true,
                    color: statusBarBackgroundColor ?? AppColors.primaryColor,
                  ),
                // child,
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTap?.call(),
                    child: SafeArea(
                      top: safeAreaTop,
                      left: safeAreaLeft,
                      right: safeAreaRight,
                      bottom: safeAreaBottom,
                      child: Container(
                        padding: padding,
                        color: Colors.transparent,
                        child: onReady != null
                            ? _LoadAndStart(
                                onReady: onReady,
                                showLoadingPage: showLoadingPage,
                                child: child,
                              )
                            : child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

class _LoadAndStart extends StatefulWidget {
  final Widget child;
  final VoidCallback? onReady;
  final bool? showLoadingPage;

  const _LoadAndStart(
      {required this.child, this.onReady, this.showLoadingPage = false});

  @override
  State<_LoadAndStart> createState() => _LoadAndStartState();
}

class _LoadAndStartState extends State<_LoadAndStart> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.showLoadingPage == true) {
      Future.delayed(const Duration(milliseconds: 3000)).then((_) {
        widget.onReady?.call(); // 👈 gọi hàm khởi động
        if (mounted) {
          setState(() => isDone = true);
        }
      });
    } else {
      if (mounted) {
        setState(() => isDone = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // String iconPath = LauncherIconHelper.getCurrentIcon();
    // Color loadingColor = LauncherIconHelper.getCurrentColor();
    return WillPopScope(
      onWillPop: () async => false,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isDone
            ? widget.child
            : Center(
                key: const ValueKey("loading"),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      // color: AppStyle.primaryColor,
                      width: 75,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 100,
                      height: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // 👈 Bo tròn 2 đầu
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFE0E0E0),
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
