
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_app/models/complaint_response_model.dart';
import 'package:test_app/repository/repository.dart';

part 'grievance_controller.g.dart';

@riverpod
class GrievanceController extends _$GrievanceController {
  @override
  FutureOr<GrievanceState> build() async {
    GrievanceState newState = GrievanceState();
    var repository = await ref.read(repositoryProvider.future);
    newState.complaintsList = await repository.getComplaints();
    // newState.

    return newState;
  }


}

class GrievanceState {

  ComplaintResponseModel? complaintsList;

 
}
