import 'package:absensi_app/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PengajuanIzin extends StatefulWidget {
  const PengajuanIzin({Key? key}) : super(key: key);

  @override
  State<PengajuanIzin> createState() => _PengajuanIzinState();
}

class _PengajuanIzinState extends State<PengajuanIzin> {

  final _formKey = GlobalKey<FormState>();
  final _fromDateContoller = TextEditingController();
  final _untilDateContoller = TextEditingController();

  DateTime? _selectedFromDate;
  DateTime? _selectedUntilDate;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked =  await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _selectedFromDate ?? DateTime.now(),
    );

    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;

        _fromDateContoller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectUntilDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _selectedUntilDate ?? DateTime.now(),
    );

    if (picked != null && picked != _selectedUntilDate) {
      setState(() {
        _selectedUntilDate = picked;

        _untilDateContoller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUi(context),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Pengajuan Izin'),
    );
  }

  Widget _buildUi(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.04,
        vertical: MediaQuery.sizeOf(context).height * 0.02
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _inputForm(context),
            _actionForm(context)
          ],
        ),
      ),
    );
  }

  Widget _inputForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _fromDateContoller,
          readOnly: true,
          decoration: const InputDecoration(
            label: Text("Dari Tanggl"),
          ),
          onTap: () => _selectFromDate(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a date';
            }
            return null;
          },
        ),
        
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.03,
        ),

        TextFormField(
          controller: _untilDateContoller,
          readOnly: true,
          decoration: const InputDecoration(
            label: Text("Sampai Tanggl"),
          ),
          onTap: () => _selectUntilDate(context),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a date';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _actionForm(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.1,
      width: MediaQuery.sizeOf(context).width * 0.04,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).height * 0.04,
            ),
          )
        ],
      ),
    );
  }
}