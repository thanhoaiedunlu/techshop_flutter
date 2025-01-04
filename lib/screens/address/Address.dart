import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/address/AddressModel.dart';
import 'package:techshop_flutter/shared/services/address/AddressService.dart';
import 'package:techshop_flutter/shared/utils/shared_preferences.dart';
import 'package:techshop_flutter/routes/routes.dart';

class AddressListPage extends StatefulWidget {
  const AddressListPage({super.key});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  late Future<List<AddressModel>> _addressesFuture;
  final AddressService _addressService = AddressService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addressesFuture = _getAllAddresses();
  }

  Future<List<AddressModel>> _getAllAddresses() async {
    final customerId = await SharedPreferencesHelper.getUserId();
    if (customerId == null) return [];
    final addresses = await _addressService.getAddressesByCustomerId(customerId);
    return addresses ?? [];
  }

  Future<void> _setDefaultAddress(int addressId) async {
    setState(() {
      _isLoading = true;
    });

    final customerId = await SharedPreferencesHelper.getUserId();
    if (customerId == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin người dùng.')),
      );
      return;
    }

    bool success = await _addressService.setDefaultAddress(customerId, addressId);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt địa chỉ mặc định thành công!')),
      );
      Navigator.pop(context, true); // Trả về true để thông báo rằng địa chỉ đã thay đổi
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt địa chỉ mặc định thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách Địa chỉ'),
        ),
        body: FutureBuilder<List<AddressModel>>(
          future: _addressesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Lỗi: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Không có địa chỉ nào. Vui lòng thêm địa chỉ mới.'),
              );
            } else {
              final addresses = snapshot.data!;
              return Stack(
                children: [
                  ListView.separated(
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text('${address.receiver} - ${address.numberPhone}'),
                        subtitle: Text(address.address),
                        trailing: address.isDefault
                            ? const Chip(
                          label: Text(
                            'Mặc định',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        )
                            : ElevatedButton(
                          onPressed: () {
                            _setDefaultAddress(address.id);
                          },
                          child: const Text('Đặt làm mặc định'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            }
          },
        ));
  }
}
