import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maaportal/core/utils/shared/component/widgets/custom_alert_box.dart';
import 'package:maaportal/features/login/controller/login_controller.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:provider/provider.dart';

import '../../../core/helpers/routes/app_route_name.dart';
import '../../../core/utils/config/styles/colors.dart';
import '../../../core/utils/shared/component/widgets/custom_text.dart';
import '../../../core/utils/shared/component/widgets/otp_vpn_alert.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<LoginController>(
      builder: (context, provider, child) {
        if (provider.loginSuccess != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(RoutesName.home);
          });
        }

        if (provider.resError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              CustomAlertDialog.showCustomAlertDialog(
                context: context,
                title: "Alert",
                message: provider.resError!,
                clearAction: () {
                  provider.clearError();
                  provider.isLoading = false;
                },
              );
            }
          });
        }

        if (provider.otpAlert != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              OtpVerificationDialogVpn.showCustomAlertDialog(
                context: context,
                title: "Verify OTP",
                message: provider.otpErrorMsg ?? '',
                controller: provider.pinController,
                cancelText: "Ok",
                onCancelPressed: () {
                  if (provider.pinController.text.length == 6) {
                    // provider.validateOtpVpn(curOtp: provider.pinController.text);
                  } else {
                    provider.otpErrorMsg = "Invalid OTP format";
                  }
                },
                clearAction: () {
                  provider.clearError();
                  provider.isLoading = false;
                },
              );
            }
          });
        }

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: screenWidth,
                      height: screenHeight,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: screenWidth * 0.65,
                              height: screenHeight,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/images/Capture.PNG'),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(150.0),
                                  topRight: Radius.circular(150.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Logo
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 20.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: screenWidth * 0.14,
                                          height: screenHeight * 0.07,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  'assets/images/logo.png'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: screenWidth * 0.55,
                                          height: screenHeight * 0.63,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/images/Black_BG.png'),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(120.0),
                                              topRight: Radius.circular(120.0),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Title
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'MANAPPURAM APPLICATION PORTAL',
                                                      style:
                                                          GoogleFonts.readexPro(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    // Punching Icon
                                                    Align(
                                                      alignment:
                                                          const Alignment(
                                                              -0.3, -0.15),
                                                      child: SizedBox(
                                                        width:
                                                            screenWidth * 0.2,
                                                        height:
                                                            screenHeight * 0.25,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      screenWidth *
                                                                          0.1,
                                                                  height:
                                                                      screenWidth *
                                                                          0.1,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          'assets/images/abcdd.gif'),
                                                                    ),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                              top: 9.0),
                                                                  child: Text(
                                                                    'PUNCHING',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // Login Form
                                                    SizedBox(
                                                      width: screenWidth * 0.34,
                                                      height:
                                                          screenHeight * 0.38,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 3.0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.0),
                                                            ),
                                                            child: Container(
                                                              width:
                                                                  screenWidth *
                                                                      0.26,
                                                              height:
                                                                  screenHeight *
                                                                      0.53,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      // Login Title
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                15.0),
                                                                        child:
                                                                            GradientText(
                                                                          'PORTAL LOGIN',
                                                                          style:
                                                                              GoogleFonts.monda(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          colors: const [
                                                                            Color(0xFF1C1B1F),
                                                                            Color(0xFFBB1818),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      // Username Field
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            35.0,
                                                                            10.0,
                                                                            35.0,
                                                                            0.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              provider.usernameController,
                                                                          focusNode:
                                                                              provider.usernameFocusNode,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                'USER ID',
                                                                            hintStyle:
                                                                                GoogleFonts.readexPro(
                                                                              color: Colors.black54,
                                                                              fontSize: 14,
                                                                            ),
                                                                            enabledBorder:
                                                                                const UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xFFBB1818),
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                const UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xFFBB1818),
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              GoogleFonts.readexPro(
                                                                            color:
                                                                                const Color(0xFF101213),
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatters: [
                                                                            provider.usernameMask
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      // Password Field
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            35.0,
                                                                            10.0,
                                                                            35.0,
                                                                            0.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              provider.passwordController,
                                                                          focusNode:
                                                                              provider.passwordFocusNode,
                                                                          obscureText:
                                                                              provider.passwordVisible,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText:
                                                                                'Password',
                                                                            hintStyle:
                                                                                GoogleFonts.readexPro(
                                                                              color: Colors.black54,
                                                                              fontSize: 14,
                                                                            ),
                                                                            enabledBorder:
                                                                                const UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xFFBB1818),
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                const UnderlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Color(0xFFBB1818),
                                                                                width: 1.0,
                                                                              ),
                                                                            ),
                                                                            suffixIcon:
                                                                                IconButton(
                                                                              onPressed: () {
                                                                                provider.togglePasswordVisibility();
                                                                              },
                                                                              icon: Icon(
                                                                                provider.passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                                color: const Color(0xFF757575),
                                                                                size: 22.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              GoogleFonts.readexPro(
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // Password Options
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            35.0,
                                                                            7.0,
                                                                            35.0,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                // Navigate to reset password
                                                                                // TODO: Implement reset password navigation
                                                                              },
                                                                              child: Text(
                                                                                'Reset Password ?',
                                                                                style: GoogleFonts.readexPro(
                                                                                  color: Colors.black,
                                                                                  fontSize: 10.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                // Navigate to change password
                                                                                // TODO: Implement change password navigation
                                                                              },
                                                                              child: Text(
                                                                                'Change Password ?',
                                                                                style: GoogleFonts.readexPro(
                                                                                  color: Colors.black,
                                                                                  fontSize: 10.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      // Login Button
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            top:
                                                                                8.0),
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed: provider.isLoading
                                                                              ? null
                                                                              : () {
                                                                                  provider.login();
                                                                                },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                const Color(0xFFFF0000),
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            minimumSize:
                                                                                const Size(80, 28),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            elevation:
                                                                                2.0,
                                                                          ),
                                                                          child: provider.isLoading
                                                                              ? const SizedBox(
                                                                                  width: 16,
                                                                                  height: 16,
                                                                                  child: CircularProgressIndicator(
                                                                                    strokeWidth: 2,
                                                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                  ),
                                                                                )
                                                                              : Text(
                                                                                  'LOGIN',
                                                                                  style: GoogleFonts.readexPro(
                                                                                    color: Colors.white,
                                                                                    fontSize: 11.0,
                                                                                  ),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  // Loading Indicator

                                                                  provider
                                                                          .isLoading
                                                                      ? Align(
                                                                          alignment: const Alignment(
                                                                              0.02,
                                                                              -0.3),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 50.0),
                                                                            child:
                                                                                Container(
                                                                              width: 75.0,
                                                                              height: 75.0,
                                                                              decoration: const BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: Image.asset(
                                                                                'assets/images/manappuram-loading-latest-unscreen.gif',
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox
                                                                          .shrink(),
                                                                ],
                                                              ),
                                                            ),
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right side with contact details
                          Container(
                            width: screenWidth * 0.35,
                            height: screenHeight,
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Contact Details',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),

                                // IT Helpdesk Card
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Color(0xFFE9EBE2),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenHeight * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'For Applications,Network & System Related Support:',
                                                    style: TextStyle(
                                                      color: Color(0xEAFE0808),
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Please Contact IT Helpdesk: (24X7)',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'PH : 0487-2437006 ',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.mail,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Mail : helpdesk@manappuram.com',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Electronic Security Card
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Color(0xFFE9EBE2),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenHeight * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'For Alarm,Centralized & IP Camera Related Support:',
                                                    style: TextStyle(
                                                      color: Color(0xEAFE0808),
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'Please Contact Electronic Security Helpdesk: (24X7)',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'PH : 0487-3050234 / 236 / 274',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.mail,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Mail : esecurityhelpdesk@manappuram.com',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // HR Helpdesk Card
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Color(0xFFE9EBE2),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenHeight * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'For Employee/HR/Salary/Leave Related Support:',
                                                    style: TextStyle(
                                                      color: Color(0xEAFE0808),
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Please Contact HR Helpdesk: (24X7)',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'PH :0487-3050105',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.mail,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Mail : hrhelpdesk@manappuram.com',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Grievance Cell Card
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Material(
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Color(0xFFE9EBE2),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenHeight * 0.18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    'For Employee Grievance Related Support:',
                                                    style: TextStyle(
                                                      color: Color(0xEAFE0808),
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Please Contact Grievance Cell:',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'PH :0487-3050135 ',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.mail,
                                                  color: Colors.black,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  'Mail : grievances@manappuram.com',
                                                  style: GoogleFonts.readexPro(
                                                    color: Colors.black,
                                                    fontSize: 9.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
