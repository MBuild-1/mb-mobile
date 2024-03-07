import '../../domain/entity/faq/faq.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/response_wrapper.dart';

extension FaqEntityMappingExt on ResponseWrapper {
  List<Faq> mapFromResponseToFaqList() {
    return response.map<Faq>((faqResponse) => ResponseWrapper(faqResponse).mapFromResponseToFaq()).toList();
  }
}

extension NewsDetailEntityMappingExt on ResponseWrapper {
  Faq mapFromResponseToFaq() {
    return Faq(
      id: response["id"],
      titleMultiLanguageString: MultiLanguageString(response["title"]),
      contentMultiLanguageString: MultiLanguageString(response["description"]),
    );
  }
}