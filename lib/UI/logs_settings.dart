import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_logs/bloc/log-settings/log_setting_bloc.dart';
import 'package:flutter_logs/enums/log_level.dart';
import 'package:flutter_logs/enums/logging_mode.dart';

class SelectLoggingMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogSettingBloc, LogSettingState>(
        builder: (context, state) {
      return Container(
        height: 200,
        margin: EdgeInsets.only(top: 5),
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: AppLocalizations.of(context)
                              ?.logSettingsSelectLoggingMode,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )),
            Divider(),
            Padding(padding: EdgeInsets.all(5)),
            ...buildRadioButtons(context, state)
          ],
        ),
      );
    });
  }

  List<Widget> buildRadioButtons(BuildContext context, LogSettingState state) {
    var logSettingBloc = context.read<LogSettingBloc>();

    List<Widget> result = [];

    result.add(RadioListTile(
        title: Text(AppLocalizations.of(context)!.logSettingsFileMode),
        value: LoggingMode.LocalMode,
        activeColor: Colors.black,
        groupValue: state.loggingMode,
        onChanged: (value) {
          logSettingBloc.add(LoggingModeChangedEvent(value!));
        }));

    result.add(
      RadioListTile(
          title: Text(AppLocalizations.of(context)!.logSettingsOnlineMode),
          value: LoggingMode.OnlineMode,
          activeColor: Colors.black,
          groupValue: state.loggingMode,
          onChanged: (value) {
            logSettingBloc.add(LoggingModeChangedEvent(value!));
          }),
    );

    return result;
  }
}

class SelectLogLevels extends StatefulWidget {
  const SelectLogLevels({required Key key}) : super(key: key);

  @override
  SelectLogLevelsState createState() => SelectLogLevelsState();
}

class SelectLogLevelsState extends State<SelectLogLevels> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocBuilder<LogSettingBloc, LogSettingState>(
        buildWhen: (previous, current) {
      return previous.loggingLevel != null && current.loggingLevel != null;
    }, builder: (context, state) {
      if (state.loggingLevel != null)
        return Container(
          height: 350,
          margin: EdgeInsets.only(top: 5),
          color: Colors.white10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: AppLocalizations.of(context)!
                                .logSettingsSelectLogLevels,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )),
              Divider(),
              Padding(padding: EdgeInsets.all(5)),
              buildCheckBoxes(context, state)
            ],
          ),
        );
      return CircularProgressIndicator();
    });
  }

  Widget buildCheckBoxes(BuildContext context, LogSettingState state) {
    var logSettingBloc = context.read<LogSettingBloc>();
    return Expanded(
      child: ListView(
        children: state.loggingLevel!.keys.map((LogLevel key) {
          return CheckboxListTile(
            activeColor: Colors.black,
            checkColor: Colors.white,
            title: new Text(describeEnum(key)),
            subtitle: new Text(state.loggingLevel!.keys.toList().indexOf(key) ==
                    0
                ? AppLocalizations.of(context)!.logSettingsDefaultLevel
                : AppLocalizations.of(context)!.logSettingsLevel +
                    " " +
                    state.loggingLevel!.keys.toList().indexOf(key).toString()),
            value: state.loggingLevel![key],
            onChanged: (bool? value) {
              setState(() {
                var index = state.loggingLevel!.keys.toList().indexOf(key);
                for (int i = index; i >= 0; i--) {
                  if (key != state.loggingLevel!.keys.toList()[i] &&
                      (value ?? false)) {
                    state.loggingLevel![state.loggingLevel!.keys.toList()[i]] =
                        true;
                  }
                }
                state.loggingLevel![key] = value ?? false;
                logSettingBloc
                    .add(LoggingLevelChangedEvent(state.loggingLevel!));
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
