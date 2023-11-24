import 'package:flutter/material.dart';
  var InputError = [
    "Không thể có ký tự đặc biệt",
    "Không thể có ký tự đặc biệt",
    "Không thể có ký tự đặc biệt",
    "Tiền hàng không thể có số",
    "Phí ship không thể có số",
    "Không đúng định dạng dd/MM/yyyy hh/mm",
  ];
  var regexCheckLength = RegExp(r"^.{2,45}$");
  var regexCheck = [
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]*)$"),
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]*)$"),
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ,]*)$"),
    RegExp(r"^([0-9]*)$"),
    RegExp(r"^([0-9]*)$"),
    RegExp(
        r"^\d{4}[-](0[1-9]|1[0-2])[-](0[1-9]|[12][0-9]|3[01]) (0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$"),
  ];
  var InputFieldAddService = [
    'Trạng thái nhiệm vụ',
    'Mục tiêu nhiệm vụ',
    'Địa chỉ đến',
    'Nhập tiền hàng',
    'Nhập phí ship',
    'Nhập thời gian kết thúc'
  ];

  var titleTextFiled = [
    'Trang thái',
    'Nhiệm vụ',
    'Địa chỉ',
    'Tiền hàng',
    'Phí ship',
    'Kết thúc',
  ];
List<String> myDetailTitle =['Điểm lấy hàng','Tiền hàng','Phí ship','Thời gian'];
List<String> taskIcon =["Đơn mới","Chờ lấy hàng"];
List<IconData> myViewIcon =[Icons.add_box_outlined , Icons.alarm_sharp];