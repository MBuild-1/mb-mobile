import '../../../domain/entity/province/province_map.dart';
import '../../../domain/entity/province/province_map_list_parameter.dart';
import '../../../misc/processing/future_processing.dart';

abstract class MapDataSource {
  FutureProcessing<List<ProvinceMap>> provinceMapList(ProvinceMapListParameter provinceMapParameter);
}