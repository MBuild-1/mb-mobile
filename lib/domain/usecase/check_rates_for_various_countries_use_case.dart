import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/cargo/cargo.dart';
import '../entity/cargo/cargo_list_parameter.dart';
import '../repository/cargo_repository.dart';

class CheckRatesForVariousCountriesUseCase {
  final CargoRepository cargoRepository;

  const CheckRatesForVariousCountriesUseCase({
    required this.cargoRepository
  });

  FutureProcessing<LoadDataResult<List<Cargo>>> execute(CargoListParameter cargoListParameter) {
    return cargoRepository.cargoList(cargoListParameter).map<LoadDataResult<List<Cargo>>>(
      onMap: (cargoListLoadDataResult) => cargoListLoadDataResult.map((cargoList) {
        List<Cargo> newCargoList = List.of(cargoList);
        newCargoList.sort((cargo1, cargo2) {
          return cargo1.minWeight.compareTo(cargo2.minWeight);
        });
        return newCargoList;
      })
    );
  }
}