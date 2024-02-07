import 'package:dio/dio.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/faq/faq.dart';
import '../../../domain/entity/faq/faq_list_parameter.dart';
import '../../../misc/constant.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/processing/dummy_future_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'faq_data_source.dart';

class DefaultFaqDataSource implements FaqDataSource {
  final Dio dio;

  DefaultFaqDataSource({
    required this.dio
  });

  @override
  FutureProcessing<List<Faq>> faqList(FaqListParameter faqListParameter) {
    return DummyFutureProcessing((parameter) async {
      return <Faq>[
        Faq(
          id: "1",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "What is Master Bagasi?",
            Constant.textInIdLanguageKey: "Apa itu Master Bagasi?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: """Master Bagasi is the first e-commerce created by the nation's youth, offering authentic Indonesian products for international distribution. Through its three main services, namely Marketplace, On-Demand Services, and Logistics, we facilitate the showcasing of these products and deliver them worldwide with affordable prices, easy processes, and fast shipping.""",
            Constant.textInIdLanguageKey: """Master Bagasi adalah e-commerce pertama karya anak bangsa yang menyediakan produk-produk asli buatan Indonesia untuk di-supply ke mancanegara. Melalui 3 layanan utamanya yaitu Marketplace, On-Demand Services, dan Logistic, kami membantu meng-etalase-kan produk-produk tersebut dan mengirimkannya ke seluruh penjuru dunia dengan harga terjangkau, proses yang mudah, dan pengiriman yang cepat."""
          })
        ),
        Faq(
          id: "2",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "How does Master Bagasi work?",
            Constant.textInIdLanguageKey: "Bagaimana Cara kerja Master Bagasi?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: """Master Bagasi's operation is very simple, as follows:<ol><li>You can directly select the products you want from the Master Bagasi showcase, then contact our Communication Team for confirmation regarding their availability. If the desired product is not available, leave a note to our Communication Team to assist in finding it according to your preferences. If you have items or packages ready for shipment, please deliver them to our address.</li><li>Once the items you want are complete, our Warehouse Team will carefully and meticulously pack your items to minimize damage during the shipping process.</li><li>After your items are ready to be shipped, our Office Team will create a shipping AWB for you, and we will hand over the items to our trusted logistics partner. The items will then safely fly to your destination country.</li><li>Upon arrival in the destination country, there is a possibility that the items will be inspected by local customs. During this process, our logistics partner will assist in the custom clearance process until completion and deliver your items right to your doorstep.</li><li>Embracing the slogan "Bringing Happiness Into Your Table," Master Bagasi will always strive to provide the best service to you because your happiness is our ultimate goal.</li></ol>""",
            Constant.textInIdLanguageKey: """Cara kerja kami sangat lah sederhana, yaitu:<ol><li>Anda bisa langsung memilih produk yang anda inginkan pada etalase Master Bagasi, lalu hubungi Tim Komunikasi kami untuk konfirmasi terkait ketersediannya. Jika produk yang anda inginkan tidak tersedia, beri catatan pada tim Komunikasi kami agar dibantu untuk dicarikan sesuai dengan yang anda inginkan, dan atau jika anda memiliki barang atau paket yang siap dikirimkan, silahkan antar paket/barang tersebut ke alamat kami.</li><li>Setelah barang yang anda inginkan lengkap, Tim Warehouse kami akan melakukan packing terhadap barang anda dengan sangat rapi dan teliti sehingga dapat meminimalisir kerusakan dalam proses pengiriman nantinya.</li><li>Setelah barang anda siap untuk dikirim, Tim Office kami akan membuatkan anda AWB pengiriman dan barang pun kami serahkan kepada mitra logistik kami yang terpercaya, barang pun terbang ke negara tujuan anda aman.</li>Setelah barang sampai di negara tujuan, terdapat kemungkinan barang diperiksa oleh pihak custom setempat. Selama proses ini, mitra logistik kami akan membantu proses custom clearance hingga selesai dan mengantarkan barang anda sampai tepat di depan pintu rumah anda.<li>Dengan mengusung slogan "Bringing Happiness Into Your Table", Master Bagasi akan selalu berusaha memberikan pelayanan terbaik kepada anda, karena kebahagiaan anda adalah tujuan kami berkarya.</li></ol>"""
          })
        ),
        Faq(
          id: "3",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "What Items Cannot Be Sent?",
            Constant.textInIdLanguageKey: "Barang Apa Saja Yang Tidak Bisa Dikirim?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Prohibited items such as Sharp Weapons, Narcotics, Alcohol, and the like, as well as fragile items and those with low durability, are not recommended for shipment. Master Bagasi is not responsible for any damage related to the shipment of such items.",
            Constant.textInIdLanguageKey: "Barang-barang terlarang seperti Senjata Tajam, Narkotika, Alkohol, dan Sejenisnya. Kemudian barang-barang pecah belah maupun barang dengan tingkat keawetan rendah tidak disarankan untuk dikirim. Karena Master Bagasi tidak bertanggung jawab atas kerusakan terkait pengiriman tersebut."
          })
        ),
        Faq(
          id: "4",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "What Payment Methods Are Available?",
            Constant.textInIdLanguageKey: "Metode Pembayaran Apa Saja Yang Tersedia?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "You can make payments through Bank Transfer, PayPal, Wise, and other agreed-upon payment methods.",
            Constant.textInIdLanguageKey: "Anda bisa membayar melalui Transfer Bank, PayPal, Wise, dan pembayaran lainya yang telah terlebih dahulu disepakati bersama."
          })
        ),
        Faq(
          id: "5",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "How long is the shipping process?",
            Constant.textInIdLanguageKey: "Berapa Lama Proses Pengirimannya?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "The estimated delivery time is 3 to 7 business days from the date of shipment. The actual delivery time may vary, depending on specific circumstances or conditions during the shipment to the destination country. Among these specific conditions are weather factors, flight disruptions, custom clearance factors, and so on.",
            Constant.textInIdLanguageKey: "Estimasi pengiriman adalah 3 sampai 7 hari kerja terhitung sejak barang dikirim. Lama waktu pengiriman sangat mungkin lebih cepat atau lebih lambat, tergantung keadaan atau kondisi tertentu pada saat pengiriman ke negara destinasi. Diantara kondisi tertentu tersebut adalah faktor cuaca, faktor gangguang penerbangan, faktor custom clearance, dan sebagainya."
          })
        ),
        Faq(
          id: "6",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Is the Price All-Inclusive?",
            Constant.textInIdLanguageKey: "Apakah Harga Sudah All-In?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "The prices provided are exclusive of taxes in the destination country. Regulations and conditions vary in each country. Regarding tax notifications, they will be directly communicated to you through email by the respective logistics partner or assisted by our Communication Team.",
            Constant.textInIdLanguageKey: "Harga yang di berikan di luar pajak di negara tujuan. Regulasi dan kondisi di setiap negara berbeda beda. Adapun untuk pemberitahuan perihal pajak akan di informasikan secara langsung melalui e-mail anda oleh mitra logistik terkait atau dibantu oleh Tim Komunikasi kami."
          })
        ),
        Faq(
          id: "7",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "How to Calculate Cardboard Volume?",
            Constant.textInIdLanguageKey: "Bagaimana Cara Menghitung Volume Kardus?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "The formula for calculating the box volume is Length x Width x Height divided by 5,000. If the resulting box volume is greater than the weight of the item, the higher value between the two becomes the benchmark.",
            Constant.textInIdLanguageKey: "Rumus menghitung volume kardus adalah Panjang x Lebar x Tinggi dibagi 5.000. Jika hasil volume kardus lebih besar dari berat barang maka yang menjadi tolak ukur adalah angka tertinggi di antara keduanya."
          })
        ),
        Faq(
          id: "8",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Is There a Minimum Delivery?",
            Constant.textInIdLanguageKey: "Apakah Ada Minimal Pengiriman?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "The minimum shipment weight is 1 kilogram. For items weighing less than 1 kilogram, it will still be counted as 1 kilogram. This applies to all other types of items.",
            Constant.textInIdLanguageKey: "Minimal pengiriman adalah 1 kilogram. Untuk barang dengan berat di bawah 1 kilogram akan tetap terhitung 1 kilogram. Berlaku untuk setiap jenis barang lain nya."
          })
        ),
        Faq(
          id: "9",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "How Much Is It To Send Items In Master Bagasi?",
            Constant.textInIdLanguageKey: "Berapa Harga Untuk Mengirim Barang Di Master Bagasi?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: """For information regarding shipping costs, you can find it on our website at <a href="https://masterbagasi.com/cargo">https://masterbagasi.com/cargo</a>, or you can consult directly with our Communication Team through <a href="https://masterbagasi.com/contactus">https://masterbagasi.com/contactus</a> for further information.""",
            Constant.textInIdLanguageKey: """Untuk informasi mengenai biaya pengiriman, bisa didapatkan melalui website kami di <a href="https://masterbagasi.com/cargo">https://masterbagasi.com/cargo</a> atau bisa berkonsultasi langsung melalui Tim Komunikasi kami langsung melalui <a href="https://masterbagasi.com/contactus">https://masterbagasi.com/contactus</a> untuk informasi lebih lanjut."""
          })
        ),
        Faq(
          id: "10",
          titleMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "How to Track My Parcel?",
            Constant.textInIdLanguageKey: "Bagaimana Melacak Paket Saya?"
          }),
          contentMultiLanguageString: MultiLanguageString({
            Constant.textEnUsLanguageKey: "After the payment is made, our Communication Team will provide you with the shipping AWB number, which can be used to track your package. But don't worry, without you requesting, our Communication Team will also regularly update you on the status of your package every day.",
            Constant.textInIdLanguageKey: "Setelah pembayaran dilakukan, Tim Komunikasi kami akan memberikan nomor AWB pengiriman yang nantinya bisa digunakan untuk melacak paket anda. Tapi tenang, tanpa anda minta, Tim Komunikasi kami juga akan secara rutin menginformasikan perihal posisi paket anda setiap harinya."
          })
        )
      ];
    });
  }
}