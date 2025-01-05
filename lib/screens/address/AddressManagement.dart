import 'package:flutter/material.dart';

import '../../models/address/AddressModel.dart';
import '../../models/address/CreateAddressDto.dart';
import '../../models/address/UpdateAddressDto.dart';
import '../../shared/services/address/AddressService.dart';


class AddressManagementScreen extends StatefulWidget {
  final int customerId;

  const AddressManagementScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  late Future<List<AddressModel>?> _addressesFuture;
  final AddressService _addressService = AddressService();

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    setState(() {
      _addressesFuture = _addressService.getAddressesByCustomerId(widget.customerId);
    });
  }

  Future<void> _setDefaultAddress(int addressId) async {
    final success = await _addressService.setDefaultAddress(widget.customerId, addressId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt địa chỉ mặc định thành công!')),
      );
      _loadAddresses();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể đặt địa chỉ mặc định.')),
      );
    }
  }

  Future<void> _deleteAddress(int addressId) async {
    final success = await _addressService.deleteAddress(addressId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa địa chỉ thành công!')),
      );
      _loadAddresses();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa địa chỉ.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Địa Chỉ'),
      ),
      body: FutureBuilder<List<AddressModel>?>(
        future: _addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có địa chỉ nào.'));
          }

          final addresses = snapshot.data!;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(address.address),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Người nhận: ${address.receiver}'),
                      Text('SĐT: ${address.numberPhone}'),
                      if (address.note != null) Text('Ghi chú: ${address.note}'),
                      if (address.isDefault)
                        const Text(
                          'Mặc định',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'setDefault') {
                        await _setDefaultAddress(address.id);
                      } else if (value == 'delete') {
                        await _deleteAddress(address.id);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!address.isDefault)
                        const PopupMenuItem(
                          value: 'setDefault',
                          child: Text('Đặt làm mặc định'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Xóa'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOrUpdateAddressScreen(customerId: widget.customerId)),
          ).then((_) => _loadAddresses());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
class AddOrUpdateAddressScreen extends StatelessWidget {
  final int customerId;
  final AddressModel? address;

  const AddOrUpdateAddressScreen({Key? key, required this.customerId, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController addressController =
    TextEditingController(text: address?.address ?? '');
    final TextEditingController receiverController =
    TextEditingController(text: address?.receiver ?? '');
    final TextEditingController numberPhoneController =
    TextEditingController(text: address?.numberPhone ?? '');
    final TextEditingController noteController =
    TextEditingController(text: address?.note ?? '');

    final AddressService addressService = AddressService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          address == null ? 'Thêm Địa Chỉ' : 'Cập Nhật Địa Chỉ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông Tin Địa Chỉ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: receiverController,
                    decoration: InputDecoration(
                      labelText: 'Người nhận',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: numberPhoneController,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(

                      onPressed: () async {
                        if (address == null) {
                          await addressService.createAddress(CreateAddressDto(
                            address: addressController.text,
                            receiver: receiverController.text,
                            numberPhone: numberPhoneController.text,
                            note: noteController.text,
                            customerId: customerId,
                          ));
                        } else {
                          // Cập nhật địa chỉ nếu có
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        address == null ? 'Thêm Địa Chỉ' : 'Cập Nhật',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

