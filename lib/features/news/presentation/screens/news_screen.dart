import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/grid_background.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = [
    'All',
    'Exams',
    'Results',
    'Admissions',
    'Scholarships',
    'Announcements',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: GridBackground(
          backgroundColor: AppColors.backgroundDark,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.backgroundDark,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.newspaper,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Educational News',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 46),
                      child: Text(
                        'Stay updated with latest educational updates',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.6),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // Category Navigation Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_categories.length, (index) {
                      final category = _categories[index];
                      final isSelected = _tabController.index == index;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _tabController.animateTo(index);
                              setState(() {});
                              _scrollToCategory(index);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primary.withOpacity(0.7),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isSelected 
                                    ? null 
                                    : Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.15),
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getCategoryIcon(category),
                                    size: 18,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.7),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    return _buildNewsList(category);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToCategory(int index) {
    // Calculate the position to scroll to center the selected category
    const itemWidth = 120.0; // Approximate width of each category pill
    final screenWidth = MediaQuery.of(context).size.width;
    final targetScroll = (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2);
    
    _scrollController.animateTo(
      targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNewsList(String category) {
    final news = _getNewsForCategory(category);

    if (news.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No news available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final newsItem = news[index];
          return _buildNewsCard(newsItem, index);
        },
      ),
    );
  }

  Widget _buildNewsCard(NewsItem newsItem, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showNewsDetail(newsItem),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with category and date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(newsItem.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getCategoryColor(newsItem.category).withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(newsItem.category),
                              size: 14,
                              color: _getCategoryColor(newsItem.category),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              newsItem.category,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getCategoryColor(newsItem.category),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(newsItem.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    newsItem.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.95),
                          height: 1.3,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Text(
                    newsItem.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Footer with source and importance indicator
                  Row(
                    children: [
                      if (newsItem.isImportant)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.priority_high,
                                size: 12,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Important',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      Text(
                        newsItem.source,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNewsDetail(NewsItem newsItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(newsItem.category).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(newsItem.category),
                                  size: 16,
                                  color: _getCategoryColor(newsItem.category),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  newsItem.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getCategoryColor(newsItem.category),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title
                          Text(
                            newsItem.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                          ),
                          const SizedBox(height: 12),
                          // Meta info
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMMM dd, yyyy - hh:mm a').format(newsItem.date),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.source,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                newsItem.source,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Content
                          Text(
                            newsItem.content,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.7,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Exams':
        return const Color(0xFF667eea);
      case 'Results':
        return const Color(0xFF11998e);
      case 'Admissions':
        return const Color(0xFFf093fb);
      case 'Scholarships':
        return const Color(0xFFfa709a);
      case 'Announcements':
        return const Color(0xFF4facfe);
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Exams':
        return Icons.assignment_outlined;
      case 'Results':
        return Icons.emoji_events_outlined;
      case 'Admissions':
        return Icons.school_outlined;
      case 'Scholarships':
        return Icons.card_giftcard_outlined;
      case 'Announcements':
        return Icons.campaign_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  List<NewsItem> _getNewsForCategory(String category) {
    final allNews = _getMockNews();
    if (category == 'All') return allNews;
    return allNews.where((news) => news.category == category).toList();
  }

  List<NewsItem> _getMockNews() {
    return [
      NewsItem(
        title: 'G.C.E. A/L Examination 2025 Extended to January',
        description:
            'The Ministry of Education announced that the G.C.E. Advanced Level examination scheduled for December has been postponed to January 2025 due to administrative reasons.',
        category: 'Exams',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        source: 'Ministry of Education',
        isImportant: true,
        content:
            'The Ministry of Education has officially announced the postponement of the G.C.E. Advanced Level examination from December 2024 to January 2025. This decision was made considering various administrative and logistical factors.\n\nAccording to the official statement, all registered candidates will be notified through their respective schools. The exact dates for the rescheduled examination will be announced within the next two weeks.\n\nStudents are advised to continue their preparation and stay updated through official channels for further announcements.',
      ),
      NewsItem(
        title: 'University Admissions 2024/2025 - Application Deadline Extended',
        description:
            'The University Grants Commission has extended the application deadline for university admissions for the academic year 2024/2025.',
        category: 'Admissions',
        date: DateTime.now().subtract(const Duration(hours: 5)),
        source: 'UGC Sri Lanka',
        isImportant: true,
        content:
            'The University Grants Commission (UGC) has decided to extend the application deadline for university admissions for the academic year 2024/2025 by two weeks.\n\nEligible candidates who have not yet submitted their applications are encouraged to do so before the new deadline. The extended deadline is aimed at ensuring that all eligible students have adequate time to complete their applications.\n\nApplications can be submitted through the official UGC online portal.',
      ),
      NewsItem(
        title: 'New Scholarship Program for Science Students Announced',
        description:
            'A new scholarship program worth Rs. 50 million has been announced for outstanding science students pursuing higher education.',
        category: 'Scholarships',
        date: DateTime.now().subtract(const Duration(days: 1)),
        source: 'National Science Foundation',
        isImportant: false,
        content:
            'The National Science Foundation, in collaboration with leading educational institutions, has announced a comprehensive scholarship program worth Rs. 50 million.\n\nThis initiative aims to support talented science students who demonstrate exceptional academic performance and potential in scientific research. The scholarships will cover tuition fees, accommodation, and research expenses.\n\nApplications are now open, and interested students can apply through the NSF website.',
      ),
      NewsItem(
        title: 'O/L Results 2024 to be Released Next Week',
        description:
            'The Department of Examinations confirms that G.C.E. Ordinary Level examination results for 2024 will be released next week.',
        category: 'Results',
        date: DateTime.now().subtract(const Duration(days: 2)),
        source: 'Department of Examinations',
        isImportant: true,
        content:
            'The Commissioner General of Examinations has confirmed that the results of the G.C.E. Ordinary Level examination held in 2024 will be released next week.\n\nStudents will be able to access their results through the official website and via SMS. Schools will also receive the results simultaneously.\n\nThe pass rate and other statistics will be announced during a press conference.',
      ),
      NewsItem(
        title: 'New Digital Learning Platform Launched for Schools',
        description:
            'The Ministry of Education launches a comprehensive digital learning platform to enhance online education across the country.',
        category: 'Announcements',
        date: DateTime.now().subtract(const Duration(days: 3)),
        source: 'Ministry of Education',
        isImportant: false,
        content:
            'In a significant step towards modernizing education, the Ministry of Education has launched a new digital learning platform designed to facilitate online learning for students across Sri Lanka.\n\nThe platform includes interactive lessons, video tutorials, practice tests, and live sessions with experienced teachers. It is accessible via web browsers and mobile applications.\n\nSchools are encouraged to register and integrate this platform into their teaching methodologies.',
      ),
    ];
  }
}

class NewsItem {
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String source;
  final bool isImportant;
  final String content;

  NewsItem({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.source,
    required this.isImportant,
    required this.content,
  });
}
