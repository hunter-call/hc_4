import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hc_4/const/subjects.dart';
import 'package:hc_4/folder_view/subject_operation_page.dart';
import 'package:hc_4/styles/app_theme.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Folders',
              style: AppTheme.displayMedium.copyWith(color: AppTheme.secondary),
            ),
            const SizedBox(
              height: 36,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.surface, // Цвет границы
                          width: 2.0, // Ширина границы
                        ),
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        // Навигация на страницу операций предмета
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubjectOperationsPage(
                              subject: subjects[index],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          getSubjectIcon(subjects[index]),
                          color: Colors.white,
                        ),
                        title: Text(
                          subjects[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
