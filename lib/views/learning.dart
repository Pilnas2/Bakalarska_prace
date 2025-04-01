import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/views/chatbot_page.dart';
import 'package:bakalarska_prace_pilny/views/edit_profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'grammar_lesson_page.dart';
import 'vocabulary_page.dart';
import 'listening_page.dart';
import 'reading_page.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class LearningMenuPage extends StatefulWidget {
  final String topic;

  const LearningMenuPage({super.key, required this.topic});

  @override
  _LearningMenuPageState createState() => _LearningMenuPageState();
}

class _LearningMenuPageState extends State<LearningMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentPage = 0;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
  ];
  final Color unselectedColor = Colors.pink;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.topic),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildTile(context, 'Gramatika', Icons.menu_book, Colors.blue),
              _buildTile(
                context,
                'Slovní zásoba',
                Icons.translate,
                Colors.green,
              ),
              _buildTile(context, 'Poslech', Icons.hearing, Colors.orange),
              _buildTile(
                context,
                'Čtení',
                Icons.chrome_reader_mode,
                Colors.red,
              ),
              _buildTile(
                context,
                'Test',
                Icons.fact_check_rounded,
                Colors.purple,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(80),
        duration: Duration(seconds: 1),
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: Colors.blueGrey,
        start: 2,
        end: 0,
        offset: 15,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        hideOnScroll: false,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body:
            (context, controller) => TabBarView(
              controller: tabController,
              dragStartBehavior: DragStartBehavior.down,
              physics: const BouncingScrollPhysics(),
              children: [
                ChatbotPage(),
                GrammarLessonPage(),
                VocabularyPage(topic: widget.topic, level: 'A1'),
                LearningMenuPage(topic: widget.topic),
                EditProfilePage(),
              ],
            ),
        child: TabBar(
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color:
                  currentPage == 0
                      ? colors[0]
                      : currentPage == 1
                      ? colors[1]
                      : currentPage == 2
                      ? colors[2]
                      : currentPage == 3
                      ? colors[3]
                      : currentPage == 4
                      ? colors[4]
                      : unselectedColor,
              width: 4,
            ),
            insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
          ),
          tabs: [
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.home,
                  color: currentPage == 0 ? colors[0] : unselectedColor,
                ),
              ),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.search,
                  color: currentPage == 1 ? colors[1] : unselectedColor,
                ),
              ),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: currentPage == 2 ? colors[2] : unselectedColor,
                ),
              ),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.favorite,
                  color: currentPage == 3 ? colors[3] : unselectedColor,
                ),
              ),
            ),
            SizedBox(
              height: 55,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.settings,
                  color: currentPage == 4 ? colors[4] : unselectedColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == 'Gramatika') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GrammarLessonPage()),
          );
        } else if (title == 'Slovní zásoba') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VocabularyPage(
                    topic: widget.topic,
                    level:
                        'A1', // Replace 'A1' with the appropriate level if needed
                  ),
            ),
          );
        } else if (title == 'Poslech') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListeningPage()),
          );
        } else if (title == 'Čtení') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReadingPage()),
          );
        } else {
          // Přidat navigaci na konkrétní stránku pro ostatní dlaždice
        }
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
