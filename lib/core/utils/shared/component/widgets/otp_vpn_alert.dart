import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../../../../features/login/controller/login_controller.dart';
import '../../../config/styles/colors.dart';
import 'custom_text.dart';

class OtpVerificationDialogVpn {
  static void showCustomAlertDialog({
    required BuildContext context,
    required TextEditingController? controller,
    required String title,
    required String message,
    String? cancelText,
    // Remove provider as parameter
    final VoidCallback? onCancelPressed,
    final VoidCallback? clearAction,
  }) {
    final FocusNode focusNode = FocusNode();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Consumer<LoginController>(
          builder: (context, provider, _) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Center(
                child: CustomText(
                  text: title,
                  fontSize: 18,
                  fontFamily: 'poppinsSemiBold',
                  fontWeight: FontWeight.bold,
                  color: AppColor.cardTitleColor,
                ),
              ),
              content: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'OTP has been sent to MaToken Mobile application',
                          style: GoogleFonts.readexPro(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF5E627A),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth,
                          height: 100,
                          child: Center(
                            child: KeyboardListener(
                              focusNode: focusNode,
                              autofocus: true,
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                  Navigator.of(context).pop(); // Add this line
                                  if (onCancelPressed != null) {
                                    onCancelPressed();
                                  }
                                }
                              },
                              child: PinCodeTextField(
                                autoDisposeControllers: false,
                                appContext: context,
                                length: 6,
                                textStyle: GoogleFonts.monda(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                enableActiveFill: false,
                                autoFocus: true,
                                onCompleted: (value) {
                                  // Handle OTP completion if needed
                                },
                                enablePinAutofill: false,
                                errorTextSpace: 16.0,
                                showCursor: true,
                                cursorColor: Colors.black,
                                obscureText: false,
                                hintCharacter: '●',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                pinTheme: PinTheme(
                                  fieldHeight: 40.0,
                                  fieldWidth: 40.0,
                                  borderWidth: 2.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  shape: PinCodeFieldShape.box,
                                  activeColor: const Color(0xFFFF0000),
                                  inactiveColor: const Color(0xFF5E627A),
                                  selectedColor: Colors.black,
                                ),
                                controller: controller,
                                onChanged: (value) {
                                  if (controller?.text.length == 6) {
                                    Navigator.of(context).pop();
                                    if (onCancelPressed != null) {
                                      onCancelPressed();
                                    }
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {},
                              ),
                            ),
                          ),
                        ),
                        Text(
                          provider.otpErrorMsg == null
                              ? ''
                              : provider.otpErrorMsg!,
                          style: GoogleFonts.readexPro(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF51840),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KeyboardListener(
                      focusNode: focusNode,
                      autofocus: true,
                      onKeyEvent: (event) {
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.enter) {
                          Navigator.of(context).pop();
                          if (onCancelPressed != null) {
                            onCancelPressed();
                          }
                        }
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onCancelPressed != null) {
                            onCancelPressed();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            cancelText ?? 'Ok',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.black,
                              fontFamily: "poppinsSemiBold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      if (clearAction != null) {
        clearAction();
      }
      focusNode.dispose();
    });
  }
}
