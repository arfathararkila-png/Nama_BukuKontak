import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kontak',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BerandaPage(),
    );
  }
}

class Kontak {
  final String nama;
  final String email;
  final String noHp;

  Kontak({required this.nama, required this.email, required this.noHp});
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final List<Kontak> _daftarKontak = [];
  
  // Data diri Mu ditambahkan ke dalam daftar favorit
 final List<Kontak> _daftarFavorit = [
  Kontak(
    nama: "Arfath Yoan Ndaru",
    email: "arfathararkila@gmail.com",
    noHp: "088902813477",
  ),
  Kontak(
    nama: "Aldo Felicia Pratama",
    email: "aldofeliciapratama1000@gmail.com",
    noHp: "088903513897",
  ),
];

  void _navigasiKeTambahKontak() async {
    final Kontak? kontakBaru = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahKontakPage()),
    );

    if (kontakBaru != null) {
      setState(() {
        _daftarKontak.add(kontakBaru);
      });
    }
  }

  void _navigasiKeTentang() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TentangPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BUKU KONTAK'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.purpleAccent,
            tabs: [
              Tab(icon: Icon(Icons.account_circle), text: 'Kontak'),
              Tab(icon: Icon(Icons.star), text: 'Favorit'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'BUKU KONTAK',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Kontak'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Tambah Kontak'),
                onTap: () {
                  Navigator.pop(context);
                  _navigasiKeTambahKontak();
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Favorit'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Tentang'),
                onTap: _navigasiKeTentang,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _daftarKontak.isEmpty
                ? const Center(child: Text('Belum ada kontak'))
                : ListView.builder(
                    itemCount: _daftarKontak.length,
                    itemBuilder: (context, index) {
                      final item = _daftarKontak[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(item.nama),
                        subtitle: Text('${item.email}\n${item.noHp}'),
                      );
                    },
                  ),
            _daftarFavorit.isEmpty
                ? const Center(child: Text('Belum ada kontak favorit'))
                : ListView.builder(
                    itemCount: _daftarFavorit.length,
                    itemBuilder: (context, index) {
                      final item = _daftarFavorit[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(item.nama),
                        subtitle: Text('${item.email}\n${item.noHp}'),
                      );
                    },
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigasiKeTambahKontak,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();

  void _simpan() {
    if (_namaController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _hpController.text.isNotEmpty) {
      final kontakBaru = Kontak(
        nama: _namaController.text,
        email: _emailController.text,
        noHp: _hpController.text,
      );
      Navigator.pop(context, kontakBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kontak'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'No Handphone'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            SizedBox(height: 15),
            Text(
              'Arfath FP',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('XII PPLG / RPL'),
            SizedBox(height: 5),
            Text('SMK Negeri 5 Surakarta'),
          ],
        ),
      ),
    );
  }
}