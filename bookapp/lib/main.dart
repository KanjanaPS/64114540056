import 'package:flutter/material.dart';
import 'books.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void authenticate() {
    // ตัวอย่างข้อมูลผู้ใช้ที่ลงทะเบียนไว้
    if (isLogin) {
      // เข้าสู่ระบบ
      if (mockUsers.containsKey(emailController.text) &&
          mockUsers[emailController.text] == passwordController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookMenuPage(email: emailController.text),
          ),
        );
      } else {
        // แจ้งเตือนเมื่อรหัสผ่านไม่ถูกต้อง
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('เข้าสู่ระบบล้มเหลว'),
            content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    } else {
      // สมัครสมาชิก
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        // บันทึกข้อมูลผู้ใช้ใหม่
        mockUsers[emailController.text] = passwordController.text;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BookMenuPage(email: emailController.text),
          ),
        );
      } else {
        // แจ้งเตือนหากข้อมูลไม่ครบ
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ข้อมูลไม่ครบถ้วน'),
            content: Text('กรุณากรอกอีเมลและรหัสผ่าน'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: authenticate,
              child: Text(isLogin ? 'เข้าสู่ระบบ' : 'สมัครสมาชิก'),
            ),
            TextButton(
              onPressed: toggleView,
              child: Text(isLogin
                  ? 'ยังไม่มีบัญชี? สมัครสมาชิก'
                  : 'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookMenuPage extends StatefulWidget {
  final String email; // รับอีเมลจากหน้าลงชื่อเข้าใช้

  BookMenuPage({required this.email});

  @override
  _BookMenuPageState createState() => _BookMenuPageState();
}

class _BookMenuPageState extends State<BookMenuPage> {
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController bookSummaryController = TextEditingController();

  void addBook() {
    final String title = bookTitleController.text;
    final String summary = bookSummaryController.text;

    if (widget.email == 'kanjana@gmail.com') {
      // เช็คว่าเป็นแอดมิน
      if (title.isNotEmpty && summary.isNotEmpty) {
        setState(() {
          mock.add(Book(
              id: (mock.length + 1).toString(),
              title: title,
              summary: summary));
          bookTitleController.clear();
          bookSummaryController.clear();
        });
      }
    } else {
      // แจ้งเตือนว่าไม่สามารถเพิ่มได้
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('การเข้าถึงถูกจำกัด'),
          content: Text('คุณต้องเป็นแอดมินเพื่อเพิ่มหนังสือ'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  void deleteBook(String id) {
    setState(() {
      mock.removeWhere((book) => book.id == id);
    });
  }

  void logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหนังสือ'),
      ),
      body: Column(
        children: [
          if (widget.email == 'kanjana@gmail.com') ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bookTitleController,
                decoration: InputDecoration(labelText: 'ชื่อหนังสือ'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bookSummaryController,
                decoration: InputDecoration(labelText: 'รายละเอียดหนังสือ'),
              ),
            ),
            ElevatedButton(
              onPressed: addBook,
              child: Text('เพิ่มหนังสือ'),
            ),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: mock.length,
              itemBuilder: (context, index) {
                final book = mock[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.summary),
                  trailing: widget.email == 'kanjana@gmail.com'
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteBook(book.id),
                        )
                      : null, // ไม่แสดงปุ่มลบถ้าไม่ใช่แอดมิน
                );
              },
            ),
          ),
          SizedBox(height: 20), // ช่องว่าง
          ElevatedButton(
            onPressed: logout,
            child: Text('ออกจากระบบ'),
          ),
          SizedBox(height: 20), // ช่องว่าง
          if (widget.email ==
              'kanjana@gmail.com') // แสดงอีเมลผู้ใช้ทั้งหมดถ้าเป็นแอดมิน
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ผู้ใช้ที่ลงทะเบียน:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...mockUsers.keys.map((user) => Text(user)).toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
