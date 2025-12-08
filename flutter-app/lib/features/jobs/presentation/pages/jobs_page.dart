import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/job_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/widgets/location_filter_dialog.dart';
import '../../../../core/widgets/location_map_widget.dart';
import 'package:latlong2/latlong.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final ApiService _apiService = ApiService();
  List<JobModel> _jobs = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedCategory;
  String? _selectedJobType;
  bool? _isRemote;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Technology', 'Marketing', 'Sales', 'Design', 'Finance', 'Healthcare', 'Education', 'Other'];
  final List<String> _jobTypes = ['All', 'FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERNSHIP', 'REMOTE'];
  
  // Location filter state
  bool _useLocationFilter = false;
  double? _filterLatitude;
  double? _filterLongitude;
  double _filterRadiusKm = 10.0;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<JobModel> jobs;
      
      if (_useLocationFilter && _filterLatitude != null && _filterLongitude != null) {
        // Use location-based search
        jobs = await _apiService.getNearbyJobs(
          _filterLatitude!,
          _filterLongitude!,
          _filterRadiusKm,
        );
        // Apply other filters locally
        if (_selectedCategory != null && _selectedCategory != 'All') {
          jobs = jobs.where((job) => job.category == _selectedCategory).toList();
        }
        if (_selectedJobType != null && _selectedJobType != 'All') {
          jobs = jobs.where((job) => job.jobType == _selectedJobType).toList();
        }
        if (_isRemote == true) {
          jobs = jobs.where((job) => job.isRemote == true).toList();
        }
        if (_searchController.text.isNotEmpty) {
          final search = _searchController.text.toLowerCase();
          jobs = jobs.where((job) => 
            job.title.toLowerCase().contains(search) ||
            (job.description?.toLowerCase().contains(search) ?? false) ||
            (job.companyName?.toLowerCase().contains(search) ?? false)
          ).toList();
        }
      } else {
        // Use regular search
        jobs = await _apiService.getJobs(
          category: _selectedCategory == 'All' ? null : _selectedCategory,
          jobType: _selectedJobType == 'All' ? null : _selectedJobType,
          remote: _isRemote,
          search: _searchController.text.isEmpty ? null : _searchController.text,
        );
      }
      
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  List<MapMarker> _createJobMarkers() {
    if (kDebugMode) {
      debugPrint('📊 Current jobs count: ${_jobs.length}');
      final jobsWithLocation = _jobs.where((job) => job.latitude != null && job.longitude != null && job.isRemote != true).toList();
      debugPrint('✅ Jobs with location (non-remote): ${jobsWithLocation.length} / ${_jobs.length}');
      debugPrint('🔍 Creating markers for ${jobsWithLocation.length} jobs...');
    }
    return _jobs
        .where((job) => job.latitude != null && job.longitude != null && job.isRemote != true)
        .map((job) {
      if (kDebugMode) {
        debugPrint('🎯 Job marker: "${job.title}" at (${job.latitude}, ${job.longitude})');
      }
      return MapMarker(
        position: LatLng(job.latitude!, job.longitude!),
        title: job.title,
        subtitle: job.companyName ?? job.category,
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 3),
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(Icons.work, color: Colors.white, size: 24),
        ),
        onTap: () {
          _showJobInfo(job);
        },
      );
    }).toList();
  }

  void _showJobInfo(JobModel job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(job.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.companyName != null) Text('Şirket: ${job.companyName}'),
            Text('Kategori: ${job.category}'),
            Text('Tip: ${job.displayJobType}'),
            if (job.city != null) Text('Şehir: ${job.city}'),
            if (job.salaryRange != null) Text('Maaş: ${job.salaryRange}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  void _openLocationFilter() async {
    // Eğer veriler yükleniyorsa veya boşsa, önce yükle
    if (_isLoading || _jobs.isEmpty) {
      await _loadJobs();
    }
    
    if (!mounted) return;
    
    if (kDebugMode) {
      debugPrint('🗺️ Opening location filter dialog for Jobs...');
      final markers = _createJobMarkers();
      debugPrint('🎯 Created ${markers.length} markers for dialog');
    }
    
    showDialog(
      context: context,
      builder: (context) => LocationFilterDialog(
        initialLatitude: _filterLatitude,
        initialLongitude: _filterLongitude,
        initialRadiusKm: _filterRadiusKm,
        onApply: (latitude, longitude, radiusKm) {
          setState(() {
            _useLocationFilter = true;
            _filterLatitude = latitude;
            _filterLongitude = longitude;
            _filterRadiusKm = radiusKm;
          });
          _loadJobs();
        },
        markers: _createJobMarkers(),
      ),
    );
  }
  
  void _clearLocationFilter() {
    setState(() {
      _useLocationFilter = false;
      _filterLatitude = null;
      _filterLongitude = null;
    });
    _loadJobs();
  }

  Widget _buildChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      selectedColor: const Color(0xFFCCFF00),
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.white,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected ? const Color(0xFFCCFF00) : Colors.white24,
        width: 1,
      ),
      checkmarkColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/explore'),
        ),
        title: Text(
          'Jobs',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          // Location filter button
          IconButton(
            icon: Icon(
              _useLocationFilter ? Icons.location_on : Icons.location_off,
              color: _useLocationFilter ? Colors.purple : Colors.grey,
            ),
            onPressed: _openLocationFilter,
            tooltip: 'Konum Filtresi',
          ),
          // Clear location filter button (if active)
          if (_useLocationFilter)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: _clearLocationFilter,
              tooltip: 'Konum Filtresini Temizle',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFB3B3B3)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFFB3B3B3)),
                        onPressed: () {
                          _searchController.clear();
                          _loadJobs();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFCCFF00), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _loadJobs(),
            ),
          ),

          // Filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildChip(
                  label: 'Remote',
                  selected: _isRemote == true,
                  onSelected: (selected) {
                    setState(() {
                      _isRemote = selected ? true : null;
                    });
                    _loadJobs();
                  },
                ),
                const SizedBox(width: 8),
                ..._jobTypes.map((type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildChip(
                        label: type == 'All' ? 'All Types' : type.replaceAll('_', ' '),
                        selected: _selectedJobType == type || (_selectedJobType == null && type == 'All'),
                        onSelected: (selected) {
                          setState(() {
                            _selectedJobType = selected ? type : null;
                          });
                          _loadJobs();
                        },
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category || (_selectedCategory == null && category == 'All');
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(
                    label: category,
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                      _loadJobs();
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Jobs List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadJobs,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _jobs.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_outline, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'No jobs found',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadJobs,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _jobs.length,
                              itemBuilder: (context, index) {
                                final job = _jobs[index];
                                return _buildJobCard(job);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // Navigate to job detail
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (job.companyName != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                job.companyName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB3B3B3),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (job.isRemote == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Remote',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (job.description != null && job.description!.isNotEmpty)
                    Text(
                      job.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(Icons.location_on, job.displayLocation),
                      _buildInfoChip(Icons.work, job.displayJobType),
                      if (job.salaryRange != null)
                        _buildInfoChip(Icons.attach_money, job.salaryRange!),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCCFF00)),
                    ),
                    child: Text(
                      job.category,
                      style: const TextStyle(
                        color: Color(0xFFCCFF00),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Map Location Button (Top Right)
          if (job.latitude != null && job.longitude != null && job.isRemote != true)
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showLocationOnMap(job);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFF00),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCCFF00).withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.map,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showLocationOnMap(JobModel job) {
    if (job.latitude == null || job.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu iş ilanının konum bilgisi bulunmuyor.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final marker = MapMarker(
      position: LatLng(job.latitude!, job.longitude!),
      title: job.title,
      subtitle: job.companyName ?? job.category,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.work, color: Colors.white, size: 24),
      ),
    );

    showDialog(
      context: context,
      builder: (context) => LocationFilterDialog(
        initialLatitude: job.latitude!,
        initialLongitude: job.longitude!,
        initialRadiusKm: 10.0,
        onApply: (latitude, longitude, radiusKm) {
          // Sadece gösterim için, filtreleme yapmıyoruz
          Navigator.of(context).pop();
        },
        markers: [marker],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFB3B3B3)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFFB3B3B3)),
          ),
        ],
      ),
    );
  }
}
