import 'package:flutter/material.dart';

import '../../../../core/widgets/thai/custom_appBar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: const CustomAppbar(
        textTitle: "Chính sách bảo mật",
        showLeading: true,
        listIcon: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Phần 1
            Text(
              "Điều khoản sử dụng",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Khi sử dụng ứng dụng đặt vé phim, người dùng cần cung cấp một số thông tin cơ bản "
                  "như họ tên, email, số điện thoại nhằm mục đích tạo tài khoản, mua vé và hỗ trợ khách hàng. "
                  "Thông tin này sẽ chỉ được sử dụng để xác nhận giao dịch, liên hệ khi cần thiết và cải thiện trải nghiệm dịch vụ.\n\n"
                  "Người dùng có trách nhiệm bảo mật tài khoản và mật khẩu của mình, "
                  "đồng thời cam kết không sử dụng dịch vụ cho các mục đích vi phạm pháp luật hoặc gây ảnh hưởng xấu tới hệ thống.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20),

            // Phần 2
            Text(
              "Thay đổi dịch vụ và/hoặc điều khoản",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Chúng tôi có thể cập nhật, thay đổi hoặc bổ sung nội dung của ứng dụng "
                  "cũng như các điều khoản sử dụng để phù hợp với quy định pháp luật hoặc nhu cầu kinh doanh. "
                  "Mọi thay đổi quan trọng sẽ được thông báo trên ứng dụng hoặc qua email đã đăng ký.\n\n"
                  "Người dùng cần thường xuyên theo dõi để nắm rõ các điều chỉnh mới nhất. "
                  "Việc tiếp tục sử dụng dịch vụ sau khi điều khoản được cập nhật đồng nghĩa với việc bạn đã đồng ý với những thay đổi đó.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20),

            // Phần 3
            Text(
              "Bảo mật thông tin cá nhân",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Mọi dữ liệu cá nhân của người dùng được chúng tôi lưu trữ và bảo mật theo tiêu chuẩn an toàn. "
                  "Thông tin sẽ không được chia sẻ cho bên thứ ba nếu không có sự đồng ý của bạn, ngoại trừ các trường hợp cần thiết "
                  "như yêu cầu từ cơ quan chức năng theo quy định của pháp luật.\n\n"
                  "Chúng tôi cam kết sử dụng các biện pháp kỹ thuật và tổ chức để bảo vệ dữ liệu cá nhân, "
                  "giúp người dùng yên tâm khi trải nghiệm dịch vụ đặt vé phim trực tuyến.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
