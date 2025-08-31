import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmt_project/core/widgets/thai/custom_appBar.dart';
import 'package:tmt_project/core/widgets/thai/custom_radioBtn.dart';
import 'package:tmt_project/core/widgets/tin/custom_button.dart';
import 'package:tmt_project/core/widgets/tin/custom_loading.dart';
import 'package:tmt_project/routers/app_route.dart';
import 'package:tmt_project/src/thai_src/pages/filter_page/filter_provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedCategory = 1;

  // background image url (tạm giữ nguyên)
  final Map<int, String> categoryImages = {
    12:
        "https://simg.zalopay.com.vn/zlp-website/assets/phim_phieu_luu_the_hobbit_085b1092d7.jpg",
    14:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAwht-dFeZ8NdoJehEGvM0wBTbahPZpmkIKw&s",
    16:
        "https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2021_8_16_637647225964305254_tonari-no-totoro-hang-xom-cua-toi-la-totoro-1988.jpg",
    18: "https://cdn.popsww.com/blog/sites/2/2023/09/phim-chinh-kich-hay.jpg",
    27: "https://kenh14cdn.com/2017/photo-1-1514637542645.jpg",
    28:
        "https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/2023_9_22_638310129453623127_phim-hanh-dong-my-0.jpg",
    35: "https://cdn-www.vinid.net/a8e88a45-phim-hai-hay.jpg",
    36:
        "https://cdn.mobilecity.vn/mobilecity-vn/images/2023/11/phim-lich-su-viet-nam-binh-tay-dai-nguyen-soai.jpg.webp",
    37: "https://kenh14cdn.com/2019/7/19/image-8-15635209052741434644953.png",
    53:
        "https://admin.vov.gov.vn/UploadFolder/KhoTin/Images/UploadFolder/VOVVN/Images/sites/default/files/styles/large/public/2022-08/mv5bmtcwmtmzodm5mf5bml5banbnxkftztgwody4oty2mje._v1_.jpg",
    80:
        "https://simg.zalopay.com.vn/zlp-website/assets/Phim_tam_ly_toi_pham_hay_mouse_cfcc200d13.jpg",
    99:
        "https://phimtailieutruyenhinh.wordpress.com/wp-content/uploads/2015/07/phim-tl.jpg",
    878:
        "https://bazaarvietnam.vn/wp-content/uploads/2021/07/phim-doat-giai-oscar-hay-nhat-moi-thoi-dai-1-e1627741688767.jpeg",
    9648: "https://ss-images.saostar.vn/wp700/pc/1604396475336/161878963.jpg",
    10402:
        "https://cdn.tgdd.vn/Files/2021/10/08/1388714/10-bo-phim-u-my-ve-am-nhac-giup-khoi-day-tinh-yeu-nghe-thuat-cho-cac-ban-tre-202110081225454143.jpg",
    10749:
        "https://cdn.tgdd.vn/Files/2022/02/10/1414724/10-bo-phim-hay-lang-man-nen-xem-cung-nguoi-yeu-trong-mua-valentine-202301101349143760.jpg",
    10751:
        "https://media.baoquangninh.vn/upload/image/202309/medium/2125057_a2376a31c3fd5091178e965e60ed2f94.jpg",
    10752:
        "https://bazaarvietnam.vn/wp-content/uploads/2022/10/harper-bazaar-nhung-bo-phim-hay-nhat-ve-chien-tranh-the-gioi-thu-2-070-e1703081806922.jpeg",
    10770:
        "https://afamilycdn.com/150157425591193600/2021/10/4/phim-kingdom-vuong-trieu-xac-song-phan-1-2-full-hd-vietsub-1-16333243807721978567362.jpg",
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<FilterProvider>(context, listen: false).layTheLoaiPhim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        textTitle: "Thể loại",
        listIcon: [],
        showLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<FilterProvider>(
          builder: (context, filterProvider, child) {
            if (filterProvider.isLoading) {
              return const Center(child: CustomLoading(width: 88, height: 88));
            }
            if (filterProvider.error != null) {
              return Center(child: Text(filterProvider.error!));
            }
            if (filterProvider.categories.isEmpty) {
              return const Center(child: Text("Không có dữ liệu"));
            }

            return Column(
              children: [
                SizedBox(
                  height: 680,
                  child: SingleChildScrollView(
                    child: CustomRadioButton(
                      options: filterProvider.categories,
                      selectedValue: selectedCategory,
                      onChanged:
                          (val) => setState(() => selectedCategory = val),
                      images: categoryImages,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CustomButton(
                  text: "Chọn",
                  onPressed: () {
                    final List<int> categoryIds = categoryImages.keys.toList();
                    Navigator.pushNamed(
                      context,
                      AppRouteNames.searchGenrePage,
                      arguments: [selectedCategory,categoryIds.indexOf(selectedCategory)],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
