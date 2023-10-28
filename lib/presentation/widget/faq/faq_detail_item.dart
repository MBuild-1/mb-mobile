import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../domain/entity/faq/faq.dart';
import '../../../misc/constant.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/string_util.dart';

class FaqDetailItem extends StatelessWidget {
  final Faq faq;

  const FaqDetailItem({
    super.key,
    required this.faq
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: HtmlWidget(
        faq.content,
        textStyle: const TextStyle(fontSize: 13),
        onTapUrl: (url) async {
          PageRestorationHelper.toWebViewerPage(
            context, <String, dynamic>{
              Constant.textEncodedUrlKey: StringUtil.encodeBase64String(url)
            }
          );
          return true;
        },
      )
    );
  }
}