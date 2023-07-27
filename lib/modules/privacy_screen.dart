import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talki/shared/components/widgets/privacy_section.dart';
import 'package:talki/shared/components/widgets/text_widget.dart';
import 'package:talki/shared/constants/colors.dart';

class PrivacyScreen extends StatelessWidget {
  PrivacyScreen({Key? key}) : super(key: key);

  static String id = 'Privacy screen';
  ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.w,
        height: 450.h,
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'It is important that you understand what Talker app collects and uses.',
                      style: TextStyle(
                        fontSize: 12,
                        color: blackColor,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h,),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrivacySection(
                          privacyName: 'Email',
                          fontSize: 18.sp,
                          privacyDetails:
                              'App uses Email for login purposes and password recovery purpose ',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacySection(
                          privacyName: 'Contact List',
                          fontSize: 15.sp,
                          privacyDetails:
                              'App uses your contact list for chatting purposes',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacySection(
                          privacyName: 'First Name And Last Name',
                          fontSize: 15.sp,
                          privacyDetails:
                              'App uses First name and Last Name for login purposes and chatting purposes ',
                        ),
                        SizedBox(height: 10.h,),
                        PrivacySection(
                          privacyName: 'photos/Media',
                          fontSize: 15.sp,
                          privacyDetails:
                          'App uses your photos for login purposes for chatting purposes',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacySection(
                          privacyName: 'Documents',
                          fontSize: 15.sp,
                          privacyDetails:
                          'App uses your documents for chatting purposes',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacySection(
                          privacyName: 'Audio Files',
                          fontSize: 15.sp,
                          privacyDetails:
                          'App uses your audio files for chatting purposes',
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacySection(
                          privacyName: 'Voice or sound recordings',
                          fontSize: 15.sp,
                          privacyDetails:
                          'App uses your voice or sound recordings files for chatting purposes',
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              DefaultText(
                text: 'Important : Please be assure that Talker app doesn\'t collect or share any of your personal or sensitive data.',
                maxLines: 5,
                fontColor: blackColor,
              ),
              SizedBox(height: 10.h,),
              DefaultText(
                text: 'By continuing you agree to our',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
