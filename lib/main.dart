import 'dart:async';
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

// ==== TUGAS 4: Menambah properti kategori (nullable, opsional) ====
class Kontak {
  final String nama;
  final String email;
  final String noHp;
  final String? kategori; // nullable karena tidak wajib diisi

  Kontak({
    required this.nama,
    required this.email,
    required this.noHp,
    this.kategori, // opsional, boleh tidak diisi saat membuat objek Kontak
  });
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
      nama: "Aldo Felicia Pratama",
      email: "aldofeliciapratama1000@gmail.com",
      noHp: "085681323455",
      kategori: "Diri Sendiri",
    ),
  ];

  // ==== TUGAS 6: Pencarian kontak real-time dengan Stream ====
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();
  final TextEditingController _searchFieldController =
      TextEditingController();

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

  // Fungsi bantu untuk membuat inisial dari nama (Tugas 3)
  String _ambilInisial(String nama) {
    if (nama.trim().isEmpty) return '?';
    return nama.trim()[0].toUpperCase();
  }

  // Filter kontak berdasarkan nama ATAU kategori (Tugas 6)
  List<Kontak> _filterKontak(String kataKunci) {
    if (kataKunci.isEmpty) return _daftarKontak;
    final kunci = kataKunci.toLowerCase();
    return _daftarKontak.where((kontak) {
      final namaCocok = kontak.nama.toLowerCase().contains(kunci);
      final kategoriCocok =
          (kontak.kategori ?? '').toLowerCase().contains(kunci);
      return namaCocok || kategoriCocok;
    }).toList();
  }

  @override
  void dispose() {
    // Tutup StreamController supaya tidak terjadi memory leak
    _searchController.close();
    _searchFieldController.dispose();
    super.dispose();
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
            // ==== TAB KONTAK: berisi search bar (Tugas 6) + daftar kontak ====
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchFieldController,
                    decoration: const InputDecoration(
                      labelText: 'Cari kontak (nama / kategori)',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (teks) {
                      // Setiap kali teks berubah, kirim ke stream
                      _searchController.add(teks);
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchController.stream,
                    initialData: '',
                    builder: (context, snapshot) {
                      final hasilFilter = _filterKontak(snapshot.data ?? '');

                      if (hasilFilter.isEmpty) {
                        return Center(
                          child: Text(
                            _daftarKontak.isEmpty
                                ? 'Belum ada kontak'
                                : 'Kontak tidak ditemukan',
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: hasilFilter.length,
                        itemBuilder: (context, index) {
                          final item = hasilFilter[index];
                          return daftarKontak(item);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // ==== TAB FAVORIT ====
            _daftarFavorit.isEmpty
                ? const Center(child: Text('Belum ada kontak favorit'))
                : ListView.builder(
                    itemCount: _daftarFavorit.length,
                    itemBuilder: (context, index) {
                      final item = _daftarFavorit[index];
                      return daftarKontak(item);
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

  // Widget ListTile satu kontak.
  // ==== TUGAS 3: leading diganti CircleAvatar berisi inisial ====
  // ==== TUGAS 4: kategori ditampilkan dengan null-aware operator (??) ====
  Widget daftarKontak(Kontak item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          _ambilInisial(item.nama),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(item.nama),
      subtitle: Text(
        '${item.email}\n${item.noHp}\nKategori: ${item.kategori ?? 'Tanpa kategori'}',
      ),
      isThreeLine: true,
    );
  }
}

class TambahKontakPage extends StatefulWidget {
  const TambahKontakPage({super.key});

  @override
  State<TambahKontakPage> createState() => _TambahKontakPageState();
}

class _TambahKontakPageState extends State<TambahKontakPage> {
  // ==== TUGAS 5: Form + GlobalKey<FormState> ====
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _hpController = TextEditingController();
  final _kategoriController = TextEditingController(); // Tugas 4

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  void _simpan() {
    // ==== TUGAS 5: validasi dijalankan dulu sebelum menyimpan ====
    if (_formKey.currentState!.validate()) {
      final kontakBaru = Kontak(
        nama: _namaController.text,
        email: _emailController.text,
        noHp: _hpController.text,
        // Kategori opsional: kalau kosong, disimpan sebagai null
        kategori: _kategoriController.text.trim().isEmpty
            ? null
            : _kategoriController.text.trim(),
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
        // ==== TUGAS 5: seluruh isi halaman dibungkus widget Form ====
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama wajib diisi
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // Email wajib diisi dan mengandung karakter '@'
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // No Handphone hanya boleh angka dan minimal 10 digit
              TextFormField(
                controller: _hpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'No Handphone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'No Handphone wajib diisi';
                  }
                  final hanyaAngka = RegExp(r'^[0-9]+$');
                  if (!hanyaAngka.hasMatch(value)) {
                    return 'No Handphone hanya boleh berisi angka';
                  }
                  if (value.length < 10) {
                    return 'No Handphone minimal 10 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // ==== TUGAS 4: input kategori, opsional, tanpa validator ====
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(
                  labelText: 'Kategori (Keluarga / Teman / Kerja) - opsional',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: const Text('Simpan'),
              ),
            ],
          ),
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
              'Aldo FP',
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
