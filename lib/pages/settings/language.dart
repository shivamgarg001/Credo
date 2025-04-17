import 'package:auto_size_text/auto_size_text.dart';
import 'package:credo/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // For Consumer
import 'package:credo/constants.dart';
import 'package:credo/widgets/custom_back_button.dart';
import '../../model/data.dart';  // Import the DataModel class

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const id = '/LanguagePage';

  @override
  Widget build(BuildContext context) {
    final datamodel = Provider.of<DataModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Consumer<DataModel>(
            builder: (context, value, child) {
              return Column(
                children: [
                  const CustomBackButton(title: 'Language'),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: value.languageList.length,
                    itemBuilder: (context, index) {

                      final String language = value.languageList[index][0];
                      final Locale locale = value.languageList[index][2];
                      
                      final bool isSelected = locale.languageCode == datamodel.currentLocale.languageCode &&
                                              locale.countryCode == datamodel.currentLocale.countryCode;
                      return ListTile(
                        onTap: () async{
                          value.updateAppLanguage(language);
                          Navigator.pop(context); // Close the LanguagePage after selection
                        },
                        leading: AutoSizeText(
                          language,
                          style: const TextStyle(fontFamily: 'SF-Pro', fontSize: 16.0),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: kPrimaryColor)
                            : null,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 10.0,
                        color: kHighLightColor,
                      );
                    },
                  ),
                  const Divider(
                    height: 10.0,
                    color: kHighLightColor,
                  ),
                  const SizedBox(height: 10.0),
                   AutoSizeText(S.of(context).chooseCredoAppLanguage,                               
                   overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
