
import 'package:madaduser/api/local/cache_response.dart';
import 'package:madaduser/helper/get_di.dart';

class DbHelper{
  static insertOrUpdate({required String id, required CacheResponseCompanion data}) async {
    final response = await database.getCacheResponseById(id);

    if(response != null){
      await database.updateCacheResponse(id, data);
    }else{
      await database.insertCacheResponse(data);
    }
  }


}