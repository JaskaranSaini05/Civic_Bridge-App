import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'register_complaint_screen.dart';
import 'profile_screen.dart';
import 'complaint_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot? lastComplaint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D2C59),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final name = snapshot.hasData
                        ? (snapshot.data!.get('name') ?? '')
                        : '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome",
                          style:
                              TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Hope you're having a great day!",
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
                      .where('userId', isEqualTo: user!.uid)
                      .orderBy('createdAt', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      lastComplaint = snapshot.data!.docs.first;
                    }

                    if (lastComplaint == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "No complaint registered yet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    final c = lastComplaint!;

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Most Recent Complaint",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF1D2C59),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                c['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD66B),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  c['status'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "Date: ${c['createdAt'].toDate().toString()}"),
                          Text("Category: ${c['category']}"),
                          Text("Address: ${c['address']}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('complaints')
                      .where('userId', isEqualTo: user!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    int pending = 0;
                    int progress = 0;
                    int resolved = 0;
                    int rejected = 0;

                    if (snapshot.hasData) {
                      for (var d in snapshot.data!.docs) {
                        switch (d['status']) {
                          case 'Pending':
                            pending++;
                            break;
                          case 'In Progress':
                            progress++;
                            break;
                          case 'Resolved':
                            resolved++;
                            break;
                          case 'Rejected':
                            rejected++;
                            break;
                        }
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Complaints",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2C59),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.4,
                          children: [
                            StatusCard(
                                count: pending.toString(),
                                title: "Pending",
                                color: const Color(0xFFFFF2A0)),
                            StatusCard(
                                count: progress.toString(),
                                title: "In Progress",
                                color: const Color(0xFFCCE0FF)),
                            StatusCard(
                                count: resolved.toString(),
                                title: "Resolved",
                                color: const Color(0xFFBFFFD0)),
                            StatusCard(
                                count: rejected.toString(),
                                title: "Rejected",
                                color: const Color(0xFFFFC7C7)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "Report municipal issues quickly and track their resolution.",
                            style: TextStyle(
                              color: Color(0xFF1D2C59),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.home, "Home", 0),
              navItem(Icons.add_circle_outline, "New Complaint", 1),
              navItem(Icons.history, "History", 2),
              navItem(Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(IconData icon, String label, int index) {
    final isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterComplaintScreen(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ComplaintHistoryScreen(),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        } else {
          setState(() {
            selectedIndex = index;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isActive
                  ? const Color(0xFF1D2C59)
                  : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF1D2C59)
                  : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String count;
  final String title;
  final Color color;

  const StatusCard(
      {super.key,
      required this.count,
      required this.title,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
