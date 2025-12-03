import 'package:get/get.dart';
import 'package:second_life/models/auth/user_model.dart';
import 'package:second_life/services/auth/user_service.dart';

class KelolaUserViewModel extends GetxController {
  final UserService _userService = UserService();

  var allUsers = <UserModel>[].obs;
  var isLoading = true.obs;
  var filteredUsers = <UserModel>[].obs;
  var selectedFilter = "Semua".obs;
  var searchKeyword = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    isLoading.value = true;

    try {
      final users = await _userService.getAllUsersOnce();
      allUsers.value = users.where((u) => u.role == "user").toList();
      isLoading.value = false;
      applyFilter();
    } catch (e) {
      isLoading.value = false;
      print("Error loading users: $e");
    }
  }

  void searchUser(String keyword) {
    searchKeyword.value = keyword.toLowerCase();
    applyFilter();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    applyFilter();
  }

  void applyFilter() {
    List<UserModel> tempList = allUsers;

    if (selectedFilter.value == "Aktif") {
      tempList = tempList.where((u) => u.status == "aktif").toList();
    } else if (selectedFilter.value == "Banned") {
      tempList = tempList.where((u) => u.status == "banned").toList();
    }

    if (searchKeyword.value.isNotEmpty) {
      tempList = tempList.where((u) {
        return u.namaLengkap.toLowerCase().contains(searchKeyword.value) ||
            u.email.toLowerCase().contains(searchKeyword.value);
      }).toList();
    }

    filteredUsers.value = tempList;
  }

  Future<void> ubahStatus(String uid, String status) async {
    await _userService.users.doc(uid).update({'status': status});
    await loadUsers();
  }
}
