import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIKERJA',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Menyesuaikan warna utama
      ),
      home: const AuthPage(), // Halaman autentikasi
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------- AuthPage -----------------------
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Menentukan apakah sedang di halaman login atau signup

  // Controller untuk form login
  final TextEditingController loginUsernameController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // Controller untuk form signup
  final TextEditingController signupUsernameController =
      TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController =
      TextEditingController();

  // URL dasar backend PHP Anda
  final String baseUrl = "http://10.0.2.2/db/"; // Ganti dengan URL server Anda

  // Fungsi untuk menangani login
  Future<void> handleLogin() async {
    String username = loginUsernameController.text.trim();
    String password = loginPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Username dan Password tidak boleh kosong');
      return;
    }

    final url = Uri.parse('${baseUrl}login.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _showMessage(
              'Login berhasil! Selamat datang, ${data['user']['username']}');
          // Navigasi ke HomePage setelah login berhasil
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomePage(username: data['user']['username']),
            ),
          );
        } else {
          _showMessage(data['message'] ?? 'Login gagal');
        }
      } else {
        _showMessage('Terjadi kesalahan pada server');
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      _showMessage('Tidak dapat terhubung ke server');
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  bool loginPasswordVisible = false;
  bool signupPasswordVisible = false;

  // Fungsi untuk menangani signup
  Future<void> handleSignup() async {
    String username = signupUsernameController.text.trim();
    String email = signupEmailController.text.trim();
    String password = signupPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Semua field harus diisi');
      return;
    }

    // Validasi format email
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
            r"[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      _showMessage('Format email tidak valid');
      return;
    }

    // Validasi panjang password
    if (password.length < 6) {
      _showMessage('Password minimal 6 karakter');
      return;
    }

    final url = Uri.parse('${baseUrl}signup.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _showMessage('Signup berhasil! Silakan login.');
          setState(() {
            isLogin = true;
          });
        } else {
          _showMessage(data['message'] ?? 'Signup gagal');
        }
      } else {
        _showMessage('Terjadi kesalahan pada server');
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      _showMessage('Tidak dapat terhubung ke server');
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // Fungsi untuk menangani forgot password
  Future<void> handleForgotPassword() async {
    // Langsung menavigasi ke VerificationPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerificationPage()),
    );
  }

  // Fungsi untuk menampilkan pesan snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihapus
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    signupUsernameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengatur warna AppBar menjadi oranye
      appBar: AppBar(
        title: const SizedBox.shrink(), // Menghilangkan teks di AppBar
        centerTitle: true,
        elevation: 0, // Menghilangkan bayangan AppBar jika diinginkan
        backgroundColor: Colors.transparent, // Mengatur warna AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Teks "SIKERJA" di atas logo
            const Text(
              'SIKERJA',
              style: TextStyle(
                fontSize: 30.0, // Ukuran font lebih besar
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            // Logo
            Image.asset(
              'assets/images/accident.png',
              width: 250, // Sesuaikan ukuran sesuai kebutuhan
              height: 250,
            ),
            const SizedBox(height: 5.0),
            // Teks "Sistem Data Kecelakaan Kerja" di bawah logo
            const Text(
              'Sistem Data Kecelakaan Kerja',
              style: TextStyle(
                fontSize: 22.0, // Ukuran font lebih kecil
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Warna teks orange
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            // Form Login atau Signup
            isLogin ? buildLoginForm() : buildSignupForm(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color:
            Colors.transparent, // Menetapkan warna latar belakang BottomAppBar
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin; // Beralih antara login dan signup
                });
              },
              child: isLogin
                  ? RichText(
                      text: const TextSpan(
                        text: 'Belum punya akun? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Daftar',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RichText(
                      text: const TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Masuk',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk form login
  Widget buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username
        TextField(
          controller: loginUsernameController,
          decoration: const InputDecoration(
            labelText: 'Nama Pengguna',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
            hintText: 'Masukkan nama pengguna',
          ),
        ),
        const SizedBox(height: 16.0),
        // Password
        TextField(
          controller: loginPasswordController,
          obscureText: !loginPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Kata Sandi',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                loginPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  loginPasswordVisible = !loginPasswordVisible;
                });
              },
            ),
            border: const OutlineInputBorder(),
            hintText: 'Kata sandi minimal 6 karakter',
          ),
        ),
        const SizedBox(height: 8.0),
        // Tautan Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: handleForgotPassword,
            child: const Text(
              'Lupa kata sandi?',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Tombol Login dengan warna oranye dan teks putih
        ElevatedButton(
          onPressed: handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Warna latar belakang tombol
            foregroundColor: Colors.white, // Warna teks tombol
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Masuk'),
        ),
      ],
    );
  }

  // Widget untuk form signup
  Widget buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Username
        TextField(
          controller: signupUsernameController,
          decoration: const InputDecoration(
            labelText: 'Nama Pengguna',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
            hintText: 'Masukkan nama pengguna',
          ),
        ),
        const SizedBox(height: 16.0),
        // Email
        TextField(
          controller: signupEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(),
            hintText: 'Masukkan email',
          ),
        ),
        const SizedBox(height: 16.0),
        // Password
        TextField(
          controller: signupPasswordController,
          obscureText: !signupPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Kata Sandi',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                signupPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  signupPasswordVisible = !signupPasswordVisible;
                });
              },
            ),
            border: const OutlineInputBorder(),
            hintText: 'Kata sandi minimal 6 karakter',
          ),
        ),

        const SizedBox(height: 24.0),
        // Tombol Signup dengan warna oranye dan teks putih
        ElevatedButton(
          onPressed: handleSignup,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Warna latar belakang tombol
            foregroundColor: Colors.white, // Warna teks tombol
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Daftar'),
        ),
      ],
    );
  }
}

// ----------------------- VerificationPage -----------------------
class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  // ignore: unused_field
  String? _phone; // Nomor handphone terkait dengan OTP

  // URL dasar backend PHP Anda
  final String baseUrl = "http://10.0.2.2/db/"; // Ganti dengan URL server Anda

  // Fungsi untuk meminta OTP berdasarkan nomor handphone
  Future<void> requestOtp() async {
    const String apiUrl =
        "http://10.0.2.2/verification/otp.php"; // Sesuaikan path jika diperlukan

    String phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi nomor handphone Anda')),
      );
      return;
    }

    // Validasi format nomor handphone
    if (!RegExp(r'^62\d{9,15}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Format nomor handphone tidak valid. Harus diawali dengan 62')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'submit-otp': 'true',
          'nomor': phone,
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final result = json.decode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200 && result['success'] != null) {
        setState(() {
          _phone = phone; // Menyimpan nomor handphone yang dikirim OTP
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['success'] ?? 'OTP telah dikirim!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['error'] ?? 'Gagal meminta OTP.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat meminta OTP!')),
      );
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memverifikasi OTP
  Future<void> verifyOtp() async {
    const String apiUrl =
        "http://10.0.2.2/verification/verify.php"; // Sesuaikan path jika diperlukan

    String phone = _phoneController.text.trim();
    String otp = _otpController.text.trim();

    if (phone.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi nomor handphone dan OTP')),
      );
      return;
    }

    // Validasi format nomor handphone
    if (!RegExp(r'^62\d{9,15}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Format nomor handphone tidak valid. Harus diawali dengan 62')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'submit-login': 'true',
          'nomor': phone,
          'otp': otp,
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final result = json.decode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200 && result['status'] == 'success') {
        // Navigasi ke ResetPasswordPage setelah OTP diverifikasi
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(phone: phone),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'OTP tidak valid.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Terjadi kesalahan saat memverifikasi OTP!')),
      );
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk mengirim ulang OTP
  Future<void> resendOtp() async {
    await requestOtp();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi OTP'),
        centerTitle: true,
        elevation: 0, // Menghilangkan bayangan bawah AppBar jika diinginkan
        backgroundColor: Colors.orange, // Sesuaikan warna AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Gambar Logo atau Ilustrasi (Opsional)
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/otp.png'), // Pastikan path benar
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Judul
              const Text(
                'Verifikasi OTP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              // Deskripsi
              const Text(
                'Kami akan mengirimkan OTP\nke nomor Whatsapp Anda,\nMasukkan OTP untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // Input Nomor Handphone
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Handphone',
                  hintText: '62xxxxxxxxxx',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Request OTP
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: requestOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Warna tombol
                        foregroundColor: Colors.white, // Warna teks tombol
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50), // Tinggi tombol
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Minta OTP'),
                    ),
              const SizedBox(height: 20),

              // Input OTP
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan OTP',
                  hintText: 'XXXXXX',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Tombol Verify OTP
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Warna tombol
                        foregroundColor: Colors.white, // Warna teks tombol
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50), // Tinggi tombol
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Verifikasi OTP'),
                    ),
              const SizedBox(height: 20),

              // Teks Resend OTP dengan "Tidak mendapat kode?" berwarna hitam dan "Kirim Ulang" berwarna biru
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tidak mendapat kode? ",
                    style: TextStyle(
                      color: Colors.black, // Warna hitam untuk teks pertama
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        resendOtp, // Fungsi yang dipanggil saat "Kirim Ulang" ditekan
                    child: const Text(
                      "Kirim Ulang",
                      style: TextStyle(
                        color: Colors.blue, // Warna biru untuk teks link
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- ResetPasswordPage -----------------------

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required String phone});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _identifierController =
      TextEditingController(); // Username atau Email
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  // URL dasar backend PHP Anda
  final String baseUrl = "http://10.0.2.2/db/"; // Ganti dengan URL server Anda

  // Fungsi untuk mengatur ulang password
  Future<void> resetPassword() async {
    const String apiUrl =
        "http://10.0.2.2/db/forgot_password.php"; // Sesuaikan path jika diperlukan

    String identifier = _identifierController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (identifier.isEmpty || newPassword.isEmpty) {
      _showMessage('Semua field harus diisi');
      return;
    }

    // Jika identifier adalah email, validasi format email
    bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
            r"[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(identifier);

    if (!isEmail) {
      // Jika bukan email, asumsi sebagai username
      // Anda dapat menambahkan validasi tambahan untuk username jika diperlukan
    }

    // Validasi panjang password
    if (newPassword.length < 6) {
      _showMessage('Password minimal 6 karakter');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Debug: Cetak identifier dan newPassword sebelum dikirim
      if (kDebugMode) {
        print('Identifier: $identifier');
        print('New Password: $newPassword');
      }

      // Mengirimkan data ke backend sebagai JSON
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identifier': identifier,
          'new_password': newPassword,
        }),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      final result = json.decode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200 && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Password berhasil diubah')),
        );
        // Navigasi kembali ke halaman Login setelah reset password berhasil
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Gagal mengubah password.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Terjadi kesalahan saat mengubah password!')),
      );
      if (kDebugMode) {
        print('Error: $error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool newPasswordVisible = false;

  // Fungsi untuk menampilkan pesan snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur ulang kata sandi'),
        centerTitle: true,
        elevation: 0, // Menghilangkan bayangan bawah AppBar jika diinginkan
        backgroundColor: Colors.orange, // Sesuaikan warna AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/otp.png'), // Pastikan path benar
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input Username atau Email
              TextField(
                controller: _identifierController,
                decoration: const InputDecoration(
                  labelText: 'Nama pengguna atau Email',
                  hintText: 'Masukkan nama pengguna atau email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: !newPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        newPasswordVisible = !newPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  hintText: 'Kata sandi minimal 6 karakter',
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Reset Password
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Warna tombol
                        foregroundColor: Colors.white, // Warna teks tombol
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: const Size.fromHeight(50), // Tinggi tombol
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Simpan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- HomePage -----------------------
class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange, // Menyesuaikan warna AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Menempatkan elemen di tengah secara vertikal
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Logo atau Ilustrasi (Opsional)
              Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/home.png'), // Pastikan path benar
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selamat Datang, $username!',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              // Tombol Laporkan Kecelakaan
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman ReportAccidentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportAccidentPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  minimumSize: const Size.fromHeight(50), // Tinggi tombol
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Laporkan Kecelakaan'),
              ),
              const SizedBox(height: 20.0),
              // Tombol Lihat Status Laporan
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman ViewReportStatusPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewReportStatusPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  minimumSize: const Size.fromHeight(50), // Tinggi tombol
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Lihat Status Laporan'),
              ),
              const SizedBox(height: 40.0),
              // Tombol Logout dengan warna merah
              ElevatedButton(
                onPressed: () {
                  // Navigasi kembali ke halaman AuthPage dan menghapus semua halaman sebelumnya
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna tombol logout
                  foregroundColor: Colors.white, // Warna teks tombol
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  minimumSize: const Size.fromHeight(50), // Tinggi tombol
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Keluar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportAccidentPage extends StatefulWidget {
  const ReportAccidentPage({super.key});

  @override
  _ReportAccidentPageState createState() => _ReportAccidentPageState();
}

class _ReportAccidentPageState extends State<ReportAccidentPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  // URL dasar backend PHP Anda
  final String baseUrl = "http://10.0.2.2/db/"; // Ganti dengan URL server Anda

  // Fungsi untuk melaporkan kecelakaan
  Future<void> reportAccident() async {
    String nik = _nikController.text.trim();
    String nama = _namaController.text.trim();
    String date = _dateController.text.trim();
    String time = _timeController.text.trim();
    String location = _locationController.text.trim();
    String description = _descriptionController.text.trim();

    if (nik.isEmpty ||
        nama.isEmpty ||
        date.isEmpty ||
        time.isEmpty ||
        location.isEmpty ||
        description.isEmpty) {
      _showMessage('Semua field harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${baseUrl}report_accident.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'nama': nama,
          'date': date,
          'time': time,
          'location': location,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          _showMessage('Laporan kecelakaan berhasil dikirim');
          // Navigasi kembali ke HomePage setelah laporan berhasil
          Navigator.pop(context);
        } else {
          _showMessage(data['message'] ?? 'Gagal mengirim laporan kecelakaan');
        }
      } else {
        _showMessage('Terjadi kesalahan pada server');
      }
    } catch (e) {
      _showMessage('Tidak dapat terhubung ke server');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan pesan snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Fungsi untuk memilih waktu
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporkan Kecelakaan'),
        centerTitle: true,
        backgroundColor: Colors.orange, // Menyesuaikan warna AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/lapor.png'), // Pastikan path benar
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Input NIK
            TextField(
              controller: _nikController,
              decoration: const InputDecoration(
                labelText: 'NIK',
                hintText: 'Masukkan NIK Anda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.perm_identity),
              ),
            ),
            const SizedBox(height: 16.0),
            // Input Nama
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                hintText: 'Masukkan Nama Anda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16.0),
            // Input Tanggal
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                hintText: 'Pilih tanggal',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16.0),
            // Input Waktu
            TextField(
              controller: _timeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Waktu',
                hintText: 'Pilih waktu',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              onTap: () => _selectTime(context),
            ),
            const SizedBox(height: 16.0),
            // Input Lokasi
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                hintText: 'Masukkan lokasi kecelakaan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16.0),
            // Input Deskripsi
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi kecelakaan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 24.0),
            // Tombol Kirim Laporan
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: reportAccident,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Kirim Laporan'),
                  ),
          ],
        ),
      ),
    );
  }
}

class ViewReportStatusPage extends StatefulWidget {
  const ViewReportStatusPage({super.key});

  @override
  _ViewReportStatusPageState createState() => _ViewReportStatusPageState();
}

class _ViewReportStatusPageState extends State<ViewReportStatusPage> {
  final String baseUrl = "http://10.0.2.2/db/"; // Ganti dengan URL server Anda
  List<dynamic> reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final url = Uri.parse('${baseUrl}get_reports.php');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            reports = data['reports'];
            _isLoading = false;
          });
        } else {
          _showMessage(data['message'] ?? 'Gagal mengambil data laporan');
        }
      } else {
        _showMessage('Terjadi kesalahan pada server');
      }
    } catch (e) {
      _showMessage('Tidak dapat terhubung ke server');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Laporan'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
              ? const Center(child: Text('Tidak ada laporan ditemukan'))
              : ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Nama: ${report['nama']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NIK: ${report['nik']}'),
                            Text(
                                'Tanggal: ${report['date']} - Waktu: ${report['time']}'),
                            Text('Lokasi: ${report['location']}'),
                            Text('Deskripsi: ${report['description']}'),
                            Text('Status: ${report['status']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
