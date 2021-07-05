import 'package:edutech/constants/app_assets.dart';
import 'package:edutech/ui/widgets/busy_overlay.dart';
import 'package:edutech/viewmodel/startup/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartupView extends StatefulWidget {
  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      onModelReady: (model) {
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            model.handleStartUpLogic();
          }
        });
      },
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: _controller,
                              curve: Interval(.3, 1.0, curve: Curves.easeOut))),
                      child: Image.asset(
                        kIcLogo,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => StartupViewModel(),
    );
  }
}
