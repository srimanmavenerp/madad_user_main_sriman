import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class NotificationController extends GetxController implements GetxService{
  bool _isLoading = false;

  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});


  NotificationModel? _notificationModel;
  NotificationModel? get notificationModel => _notificationModel;
  List<String> dateList = [];
  List allNotificationList=[];
  List<dynamic> notificationList=[];
  bool get isLoading => _isLoading;
  int _offset = 1;
  int get offset => _offset;
  final ScrollController scrollController = ScrollController();



  Future<void> getNotifications(int offset, {bool reload = true})async{
    _offset = offset;


    _isLoading = true;
    Response response = await notificationRepo.getNotificationList(offset);
    if(response.statusCode == 200){
      if(reload){
        allNotificationList = [];
        notificationList = [];
        dateList = [];
      }else{
        allNotificationList =[];
      }
      _notificationModel =  NotificationModel.fromJson(response.body);
      for (var data in notificationModel!.content!.data!) {
        if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
          dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
        }
      }

      for (var data in notificationModel!.content!.data!) {
        allNotificationList.add(data);
      }

      for(int i=0; i< dateList.length;i++){
        notificationList.add([]);
        for (var element in allNotificationList) {
          if(dateList[i] == DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            notificationList[i].add(element);
          }
        }
      }
      _isLoading =false;
    } else{
      _isLoading =false;
      ApiChecker.checkApi(response);
    }
    update();
  }
}
