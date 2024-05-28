import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir/models/data_detail_hp.dart';
import 'package:projek_akhir/services/api_data_source.dart';

class DetailHpPage extends StatefulWidget {
  final String slug;
  const DetailHpPage({required this.slug});

  @override
  State<DetailHpPage> createState() => _DetailHpPageState(slug: slug);
}

class _DetailHpPageState extends State<DetailHpPage> {
  final String slug;
  _DetailHpPageState({required this.slug});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
      ),
      body: Container(
        child:
            Padding(padding: EdgeInsets.all(8.0), child: _buildListPhoneBody()),
      ),
    );
  }

  Widget _buildListPhoneBody() {
    return Container(
      child: FutureBuilder(
          future: ApiDataSource.instance.loadDetailHP(slug),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              DataDetailHP dataDetailHP = DataDetailHP.fromJson(snapshot.data);
              return _buildSuccessSection(dataDetailHP);
            }
            return _buildLoadingSection();
          }),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(DataDetailHP datahp) {
    Data dataHP = datahp.data!;
    final List<String> listImg = dataHP.phoneImages ?? [];

    final CarouselOptions options = CarouselOptions(
      aspectRatio: 16 / 9,
      viewportFraction: 0.9,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 2),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: options,
            items: listImg.map((item) => Image.network(item)).toList(),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataHP.phoneName ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  dataHP.os ?? '',
                ),
                Text(
                  dataHP.storage ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
