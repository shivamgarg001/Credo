import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';

import '../constants.dart';
import '../model/data.dart';
import './settings/share.dart';
import './settings/profile.dart';
import './settings/language.dart';
import './settings/security.dart';

import '../widgets/settings/setting_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

@override
Widget build(BuildContext context) {
  final appState = Provider.of<AppState>(context);
  String clientname = appState.clientName;
  String businessName = appState.businessname;
  print(clientname);
  print(businessName);

  return Scaffold(
    backgroundColor: Colors.grey.shade50,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Consumer<DataModel>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, ProfilePage.id),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'profile1',
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: appState.profileImagePath != null
                              ? FileImage(File(appState.profileImagePath!))
                              : const AssetImage('assets/images/user.png') as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180.0,
                            child: AutoSizeText(
                              clientname.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
                            ),
                          ),
                          SizedBox(
                            width: 150.0,
                            child: AutoSizeText(
                              businessName.toUpperCase(),
                              style: TextStyle(
                                color: kSecondaryAccent,
                                fontFamily: 'SF-Pro',
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      AutoSizeText(
                        S.of(context).edit,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: 'SF-Pro',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1, // Maximum of 1 line for 'Edit'
                        minFontSize: 5, // Minimum font size
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                const Divider(
                  color: kHighLightColor,
                  height: 3,
                  thickness: 2.0,
                ),
                const SizedBox(height: 15.0),
                AutoSizeText(
                  S.of(context).settings,
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Max of 1 line
                  minFontSize: 5, // Minimum font size
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: ListView(
                    children: [
                      // SettingTile(
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     SubscriptionPage.id,
                      //   ),
                      //   icon: Icons.stars,
                      //   title: 'credo Subscription Plan',
                      //   subTitle:
                      //       'Unlimited SMS, Ad Free, Priority Customer Support',
                      // ),
                      SettingTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          LanguagePage.id,
                        ),
                        icon: Icons.translate,
                        title: AutoSizeText(
                          'Language',
                          maxLines: 2, // Max of 2 lines
                          minFontSize: 5, // Minimum font size
                        ),
                      ),
                      // SettingTile(
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     UpdateNumberPage.id,
                      //   ),
                      //   icon: Icons.numbers,
                      //   title: AutoSizeText(
                      //     'Update Mobile Number',
                      //     maxLines: 2, // Max of 2 lines
                      //     minFontSize: 5, // Minimum font size
                      //   ),
                      //   subTitle: AutoSizeText(
                      //     '80XXXXX46',
                      //     maxLines: 1, // Max of 1 line
                      //     minFontSize: 5, // Minimum font size
                      //   ),
                      // ),
                      // SettingTile(
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     BackupPage.id,
                      //   ),
                      //   icon: Icons.cloud_done_rounded,
                      //   title: 'Backup',
                      //   subTitle: 'Sync info, recovery number',
                      // ),
                      SettingTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          SecurityPage.id,
                        ),
                        icon: Icons.lock,
                        title: AutoSizeText(
                          S.of(context).security,
                          maxLines: 2, // Max of 2 lines
                          minFontSize: 5, // Minimum font size
                        ),
                        subTitle: AutoSizeText(
                          "${S.of(context).signOut}, ${S.of(context).delete}",
                          maxLines: 1, // Max of 1 line
                          minFontSize: 5, // Minimum font size
                        ),
                      ),
                      // SettingTile(
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     HelpPage.id,
                      //   ),
                      //   icon: Icons.help,
                      //   title: 'Help',
                      //   subTitle: 'FAQs, contact us, privacy policy',
                      // ),
                      // SettingTile(
                      //   onTap: () => Navigator.pushNamed(
                      //     context,
                      //     FindDefaulterPage.id,
                      //   ),
                      //   icon: Icons.person_off,
                      //   title: 'Find Defaulter',
                      // ),
                      SettingTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          SharePage.id,
                        ),
                        icon: Icons.share,
                        title: AutoSizeText(
                          S.of(context).inviteOthers,
                          maxLines: 2, // Max of 2 lines
                          minFontSize: 5, // Minimum font size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

}
