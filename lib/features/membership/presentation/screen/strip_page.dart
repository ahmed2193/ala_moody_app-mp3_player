import 'dart:developer';

import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class StripPage extends StatelessWidget {
  const StripPage({
    Key? key,
    this.value,
  }) : super(key: key);
  final String? value;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        BlocProvider.of<PlanCubit>(context).getPlans(
          accessToken:
              context.read<LoginCubit>().authenticatedUser!.accessToken!,
        );

        return BlocProvider.of<ProfileCubit>(context).getUserProfile(
          accessToken:
              context.read<LoginCubit>().authenticatedUser!.accessToken!,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          centerTitle: true,
          leading: BackArrow(
            onPressed: () {
              Navigator.pop(context);
              BlocProvider.of<PlanCubit>(context).getPlans(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken!,
              );

              BlocProvider.of<ProfileCubit>(context).getUserProfile(
                accessToken:
                    context.read<LoginCubit>().authenticatedUser!.accessToken!,
              );
            },
          ),
        ),
        body: SafeArea(
          child:CustomHtmlWebView(htmlContent: value!,),
          
          
     
        ),
      ),
    );
  }
}


class CustomHtmlWebView extends StatefulWidget {
  final String htmlContent;

  const CustomHtmlWebView({
    Key? key,
    required this.htmlContent,
  }) : super(key: key);

  @override
  _CustomHtmlWebViewState createState() => _CustomHtmlWebViewState();
}

class _CustomHtmlWebViewState extends State<CustomHtmlWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    log(widget.htmlContent);

    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.htmlContent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            debugPrint("Page Loaded: $url");
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
        log(widget.htmlContent);
    return WebViewWidget(controller: _controller);
    
  }
}
