import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:techshop_flutter/models/customer/CustomerModel.dart';
import 'package:techshop_flutter/routes/routes.dart';
import 'package:techshop_flutter/screens/forgotPassword/enterUsername.dart';
import 'package:techshop_flutter/screens/login/signUp.dart';
import 'package:techshop_flutter/shared/services/customer/customerService.dart';
import '../../shared/constant/constants.dart';
import '../../shared/utils/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final customerServices = CustomerService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Đăng Nhập',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6495ED),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tên đăng nhập',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  prefixIcon: Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng điền tên đăng nhập';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng điền mật khẩu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    checkLogin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6495ED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Đăng Nhập'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final customer = await customerServices.loginWithGoogle();

                      if (customer != null) {
                        await SharedPreferencesHelper.saveUserData(customer);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Welcome, ${customer.fullname}!')),
                        );

                        Future.delayed(const Duration(seconds: 1), () {
                          if (customer.role) {
                            Navigator.pushReplacementNamed(context, Routes.adminPage);
                          } else {
                            Navigator.pushReplacementNamed(context, Routes.home);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng nhập Google thất bại.')),
                        );
                      }
                    },
                    icon: Image.network(
                      'https://images.squarespace-cdn.com/content/v1/5b1590a93c3a53e49c6d280d/1528490305937-PKLYPXTEPO7RB0DSEOBJ/google-plus-social-media-management.jpg',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    label: const Text('Đăng nhập bằng Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final customer = await customerServices.loginWithFacebook();

                      if (customer != null) {
                        await SharedPreferencesHelper.saveUserData(customer);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Welcome, ${customer.fullname}!')),
                        );

                        Future.delayed(const Duration(seconds: 1), () {
                          if (customer.role) {
                            Navigator.pushReplacementNamed(context, Routes.adminPage);
                          } else {
                            Navigator.pushReplacementNamed(context, Routes.home);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng nhập Facebook thất bại.')),
                        );
                      }
                    },
                    icon: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-lBS5KCmOn8JZFW3cgQocYCaheksYP5hGQw&s',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                    label: const Text('Đăng nhập bằng Facebook'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3b5998), // Màu xanh của Facebook
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Bạn đã có tài khoản',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EnterUsername()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Quên mật khẩu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final customer = await customerServices.checkLogin(
      username: username,
      password: password,
    );
    if (customer != null) {
      await SharedPreferencesHelper.saveUserData(customer);
      CustomerModel? savedCustomer =
          await SharedPreferencesHelper.getUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${savedCustomer?.fullname}!')),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (customer.role) {
          Navigator.pushReplacementNamed(context, Routes.adminPage);
        } else {
          Navigator.pushReplacementNamed(context, Routes.home);
        }

      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

}
