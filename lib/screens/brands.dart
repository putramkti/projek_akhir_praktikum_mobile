import 'package:flutter/material.dart';
import 'package:projek_akhir/models/data_brands.dart';
import 'package:projek_akhir/screens/brands.dart';
import 'package:projek_akhir/screens/detail_brand.dart';
import 'package:projek_akhir/screens/detail_hp.dart';
import 'package:projek_akhir/screens/home.dart';
import 'package:projek_akhir/services/api_data_source.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BrandsPage()),
        );
        break;
      case 2:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => NotificationsPage()),
        // );
        break;
      case 3:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfilePage()),
      // );
      // break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Brands")),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _buildListPhoneBody(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.branding_watermark, color: Colors.blue),
            label: 'Brands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.grey),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
        ],
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildListPhoneBody() {
    return Container(
      child: FutureBuilder(
          future: ApiDataSource.instance.loadBrands(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              DataBrands dataBrands = DataBrands.fromJson(snapshot.data);
              return _buildSuccessSection(dataBrands);
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

  Widget _buildSuccessSection(DataBrands data) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildItemPhone(data.data![index]);
      },
      itemCount: data.data!.length,
    );
  }

  Widget _buildItemPhone(Data data) {
    // String imageUrl = hp.image!.replaceFirst('http://', 'https://');
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailBrandPage(
                    slugBrand: data.brandSlug!,
                  ))),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.brandName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${data.deviceCount.toString()} devices',
                // style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
