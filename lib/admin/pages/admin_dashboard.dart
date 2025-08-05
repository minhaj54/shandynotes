import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../services/appwrite_service.dart';

// File Upload Helper Widget
class FileUploadHelper extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<String> allowedExtensions;
  final FileType fileType;
  final Function(PlatformFile) onFileSelected;
  final Function(String)? onFileUploaded;
  final PlatformFile? selectedFile;
  final String? uploadedUrl;
  final bool isLoading;

  const FileUploadHelper({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.allowedExtensions,
    required this.fileType,
    required this.onFileSelected,
    this.onFileUploaded,
    this.selectedFile,
    this.uploadedUrl,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FileUploadHelper> createState() => _FileUploadHelperState();
}

class _FileUploadHelperState extends State<FileUploadHelper> {
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.fileType,
        allowedExtensions: widget.fileType == FileType.custom
            ? widget.allowedExtensions
            : null,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        widget.onFileSelected(result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Iconsax.document_text;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Iconsax.image;
      case 'doc':
      case 'docx':
        return Iconsax.document;
      case 'txt':
        return Iconsax.note_text;
      default:
        return Iconsax.document_text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFile =
        widget.selectedFile != null && widget.selectedFile!.name.isNotEmpty;
    final hasUploadedUrl =
        widget.uploadedUrl != null && widget.uploadedUrl!.isNotEmpty;
    final isLoading = widget.isLoading;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: hasFile || hasUploadedUrl
              ? Colors.deepPurpleAccent
              : Colors.grey[300]!,
          width: hasFile || hasUploadedUrl ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isLoading
            ? Colors.grey[50]
            : hasFile || hasUploadedUrl
                ? Colors.deepPurpleAccent.withOpacity(0.05)
                : Colors.transparent,
      ),
      child: InkWell(
        onTap: isLoading ? null : _pickFile,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hasFile || hasUploadedUrl
                          ? Colors.deepPurpleAccent.withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.icon,
                      color: hasFile || hasUploadedUrl
                          ? Colors.deepPurpleAccent
                          : Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: hasFile || hasUploadedUrl
                                ? Colors.deepPurpleAccent
                                : Colors.grey[800],
                          ),
                        ),
                        if (widget.subtitle != null)
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(
                      hasFile || hasUploadedUrl
                          ? Iconsax.tick_circle
                          : Iconsax.add_circle,
                      color: hasFile || hasUploadedUrl
                          ? Colors.green
                          : Colors.grey[400],
                      size: 24,
                    ),
                ],
              ),
              if (hasFile) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getFileIcon(widget.selectedFile!.extension),
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedFile!.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _formatFileSize(widget.selectedFile!.size),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          widget.onFileSelected(PlatformFile(
                            name: '',
                            size: 0,
                            path: null,
                          ));
                        },
                        icon: Icon(
                          Iconsax.close_circle,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
              if (hasUploadedUrl) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.link,
                        size: 16,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'File uploaded successfully',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (!hasFile && !hasUploadedUrl && !isLoading) ...[
                const SizedBox(height: 8),
                Text(
                  'Tap to select ${widget.allowedExtensions.join(', ').toUpperCase()} file',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  bool _isEditing = false;
  String? _editingBookId;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  // Form controllers
  final _titleController = TextEditingController();
  final _publisherController = TextEditingController();
  final _pagesController = TextEditingController();
  final _languageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pdfUrlController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _preview1UrlController = TextEditingController();
  final _preview2UrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLatest = false;
  bool _isPopular = false;

  // File selection variables
  PlatformFile? _selectedCoverFile;
  PlatformFile? _selectedPreview1File;
  PlatformFile? _selectedPreview2File;
  PlatformFile? _selectedPdfFile;

  // Predefined categories
  final List<String> _categories = [
    'All',
    'Programming',
    'Technology',
    'JEE',
    'NEET',
    'College',
    'GATE',
    'NDA',
    'UPSC',
    'Business',
    'Literature',
    'History',
    'Geography',
    'Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _publisherController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _descriptionController.dispose();
    _pdfUrlController.dispose();
    _coverUrlController.dispose();
    _preview1UrlController.dispose();
    _preview2UrlController.dispose();
    _categoryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterBooks();
    });
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await AppwriteService.getBooks();
      setState(() {
        _books = books;
        _filterBooks();
      });
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error loading books: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterBooks() {
    List<Map<String, dynamic>> filtered = List.from(_books);

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((book) => book['category'] == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((book) {
        final title = book['title']?.toString().toLowerCase() ?? '';
        final publisher = book['publisher']?.toString().toLowerCase() ?? '';
        final description = book['description']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            publisher.contains(query) ||
            description.contains(query);
      }).toList();
    }

    setState(() {
      _filteredBooks = filtered;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare book data
      final bookData = {
        'title': _titleController.text.trim(),
        'publisher': _publisherController.text.trim(),
        'pages': int.tryParse(_pagesController.text) ?? 0,
        'language': _languageController.text.trim(),
        'description': _descriptionController.text.trim(),
        'pdfUrl': _pdfUrlController.text.trim(),
        'coverUrl': _coverUrlController.text.trim(),
        'preview1Url': _preview1UrlController.text.trim(),
        'preview2Url': _preview2UrlController.text.trim(),
        'category': _categoryController.text.trim(),
        'isLatest': _isLatest,
        'isPopular': _isPopular,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // TODO: Upload files to storage if selected
      // This would require implementing file upload to Appwrite Storage
      // For now, we'll use URLs provided in the form

      if (_isEditing && _editingBookId != null) {
        bookData['updatedAt'] = DateTime.now().toIso8601String();
        await AppwriteService.updateBook(_editingBookId!, bookData);
        _showSnackBar('Note updated successfully');
      } else {
        await AppwriteService.createBook(bookData);
        _showSnackBar('Note added successfully');
      }

      _resetForm();
      await _loadBooks();
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _editBook(Map<String, dynamic> book) {
    setState(() {
      _isEditing = true;
      _editingBookId = book['\$id'];
      _titleController.text = book['title'] ?? '';
      _publisherController.text = book['publisher'] ?? '';
      _pagesController.text = (book['pages'] ?? 0).toString();
      _languageController.text = book['language'] ?? '';
      _descriptionController.text = book['description'] ?? '';
      _pdfUrlController.text = book['pdfUrl'] ?? '';
      _coverUrlController.text = book['coverUrl'] ?? '';
      _preview1UrlController.text = book['preview1Url'] ?? '';
      _preview2UrlController.text = book['preview2Url'] ?? '';
      _categoryController.text = book['category'] ?? '';
      _isLatest = book['isLatest'] ?? false;
      _isPopular = book['isPopular'] ?? false;
    });
  }

  Future<void> _deleteBook(String bookId, String title) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AppwriteService.deleteBook(bookId);
        _showSnackBar('Note deleted successfully');
        await _loadBooks();
      } catch (e) {
        _showSnackBar('Error deleting book: $e', isError: true);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _isEditing = false;
      _editingBookId = null;
      _titleController.clear();
      _publisherController.clear();
      _pagesController.clear();
      _languageController.clear();
      _descriptionController.clear();
      _pdfUrlController.clear();
      _coverUrlController.clear();
      _preview1UrlController.clear();
      _preview2UrlController.clear();
      _categoryController.clear();
      _isLatest = false;
      _isPopular = false;
      _selectedCoverFile = null;
      _selectedPreview1File = null;
      _selectedPreview2File = null;
      _selectedPdfFile = null;
    });
  }

  Widget _buildFilePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Uploads',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // PDF File Picker
        FileUploadHelper(
          title: 'PDF Document',
          subtitle: 'Upload your PDF file',
          icon: Iconsax.document_text,
          fileType: FileType.custom,
          allowedExtensions: ['pdf'],
          selectedFile: _selectedPdfFile,
          isLoading: _isLoading,
          onFileSelected: (file) {
            setState(() {
              _selectedPdfFile = file.name.isNotEmpty ? file : null;
            });
          },
        ),
        const SizedBox(height: 16),

        // Cover Image Picker
        FileUploadHelper(
          title: 'Cover Image',
          subtitle: 'Upload book cover image',
          icon: Iconsax.image,
          fileType: FileType.image,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
          selectedFile: _selectedCoverFile,
          isLoading: _isLoading,
          onFileSelected: (file) {
            setState(() {
              _selectedCoverFile = file.name.isNotEmpty ? file : null;
            });
          },
        ),
        const SizedBox(height: 16),

        // Preview Image 1 Picker
        FileUploadHelper(
          title: 'Preview Image 1',
          subtitle: 'First preview image',
          icon: Iconsax.image,
          fileType: FileType.image,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
          selectedFile: _selectedPreview1File,
          isLoading: _isLoading,
          onFileSelected: (file) {
            setState(() {
              _selectedPreview1File = file.name.isNotEmpty ? file : null;
            });
          },
        ),
        const SizedBox(height: 16),

        // Preview Image 2 Picker
        FileUploadHelper(
          title: 'Preview Image 2',
          subtitle: 'Second preview image',
          icon: Iconsax.image,
          fileType: FileType.image,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
          selectedFile: _selectedPreview2File,
          isLoading: _isLoading,
          onFileSelected: (file) {
            setState(() {
              _selectedPreview2File = file.name.isNotEmpty ? file : null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    final totalBooks = _books.length;
    final latestBooks = _books.where((book) => book['isLatest'] == true).length;
    final popularBooks =
        _books.where((book) => book['isPopular'] == true).length;
    final categoriesCount =
        _books.map((book) => book['category']).toSet().length;

    return Row(
      children: [
        Expanded(
            child: _buildStatCard('Total Books', totalBooks.toString(),
                Iconsax.book, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard(
                'Latest', latestBooks.toString(), Iconsax.clock, Colors.green)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard(
                'Popular', popularBooks.toString(), Iconsax.heart, Colors.red)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard('Categories', categoriesCount.toString(),
                Iconsax.category, Colors.orange)),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1000;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shandy Studio',
          style: TextStyle(
              color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh, color: Colors.deepPurpleAccent),
            onPressed: _loadBooks,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                // Form Section
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[50],
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Stats Cards
                          _buildStatsCards(),
                          const SizedBox(height: 32),

                          // Form
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _isEditing ? Iconsax.edit : Iconsax.add,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isEditing
                                            ? 'Edit Note'
                                            : 'Add New Note',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),

                                  // File Upload Section
                                  _buildFilePickerSection(),
                                  const SizedBox(height: 24),

                                  const Divider(),
                                  const SizedBox(height: 24),

                                  // Basic Information
                                  Text(
                                    'Basic Information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Title and Publisher Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _titleController,
                                          decoration: InputDecoration(
                                            labelText: 'Title *',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon:
                                                const Icon(Iconsax.book),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter the title';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _publisherController,
                                          decoration: InputDecoration(
                                            labelText: 'Publisher *',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon:
                                                const Icon(Iconsax.building),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter the publisher';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Category and Language Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value:
                                              _categoryController.text.isEmpty
                                                  ? null
                                                  : _categoryController.text,
                                          decoration: InputDecoration(
                                            labelText: 'Category *',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon:
                                                const Icon(Iconsax.category),
                                          ),
                                          items: _categories
                                              .where((cat) => cat != 'All')
                                              .map((String category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Text(category),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                _categoryController.text =
                                                    newValue;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a category';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _languageController,
                                          decoration: InputDecoration(
                                            labelText: 'Language *',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon: const Icon(
                                                Iconsax.language_square),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Please enter the language';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Pages
                                  TextFormField(
                                    controller: _pagesController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Number of Pages *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      prefixIcon:
                                          const Icon(Iconsax.document_text),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter the number of pages';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Please enter a valid number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Description
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: 'Description *',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      prefixIcon: const Icon(Iconsax.note_text),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter the description';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  const Divider(),
                                  const SizedBox(height: 24),

                                  // URLs Section
                                  Text(
                                    'URLs (Optional if files uploaded)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 16),

                                  // PDF URL
                                  TextFormField(
                                    controller: _pdfUrlController,
                                    decoration: InputDecoration(
                                      labelText: 'PDF URL',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      prefixIcon: const Icon(Iconsax.link),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Cover Image URL
                                  TextFormField(
                                    controller: _coverUrlController,
                                    decoration: InputDecoration(
                                      labelText: 'Cover Image URL',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      prefixIcon: const Icon(Iconsax.link),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Preview Images URLs
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _preview1UrlController,
                                          decoration: InputDecoration(
                                            labelText: 'Preview Image 1 URL',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon:
                                                const Icon(Iconsax.link),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _preview2UrlController,
                                          decoration: InputDecoration(
                                            labelText: 'Preview Image 2 URL',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            prefixIcon:
                                                const Icon(Iconsax.link),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Flags
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: const Text('Latest'),
                                          subtitle:
                                              const Text('Mark as latest Note'),
                                          value: _isLatest,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isLatest = value ?? false;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        ),
                                      ),
                                      Expanded(
                                        child: CheckboxListTile(
                                          title: const Text('Popular'),
                                          subtitle: const Text(
                                              'Mark as popular Note'),
                                          value: _isPopular,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isPopular = value ?? false;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),

                                  // Submit Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              _isLoading ? null : _submitForm,
                                          icon: _isLoading
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Icon(_isEditing
                                                  ? Iconsax.edit
                                                  : Iconsax.add),
                                          label: Text(_isEditing
                                              ? 'Update Note'
                                              : 'Add Note'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                          ),
                                        ),
                                      ),
                                      if (_isEditing) ...[
                                        const SizedBox(width: 16),
                                        ElevatedButton.icon(
                                          onPressed:
                                              _isLoading ? null : _resetForm,
                                          icon:
                                              const Icon(Iconsax.close_circle),
                                          label: const Text('Cancel'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Books List Section
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with search and filter
                        Row(
                          children: [
                            Icon(Iconsax.book, color: Colors.deepPurpleAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Note List',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                            ),
                            const Spacer(),
                            Text('${_filteredBooks.length} books'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Search and Filter Row
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search Note...',
                                  prefixIcon: const Icon(Iconsax.search_normal),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Filter by Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                items: _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                      _filterBooks();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Books List
                        Expanded(
                          child: _isLoading
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 16),
                                      Text('Loading Notes...'),
                                    ],
                                  ),
                                )
                              : _filteredBooks.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.book,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _books.isEmpty
                                                ? 'No notes added yet'
                                                : 'No notes match your search',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          if (_books.isEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              'Add your first Note using the form',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _filteredBooks.length,
                                      itemBuilder: (context, index) {
                                        final book = _filteredBooks[
                                            _filteredBooks.length - 1 - index];
                                        return _buildBookCard(book);
                                      },
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Mobile Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[50],
                    child: _buildStatsCards(),
                  ),

                  // Mobile Form
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isEditing ? Iconsax.edit : Iconsax.add,
                                color: Colors.deepPurpleAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isEditing ? 'Edit Book' : 'Add New Note',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurpleAccent,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Mobile File Upload Section
                          _buildFilePickerSection(),
                          const SizedBox(height: 24),

                          // Category Dropdown
                          DropdownButtonFormField<String>(
                            value: _categoryController.text.isEmpty
                                ? null
                                : _categoryController.text,
                            decoration: InputDecoration(
                              labelText: 'Category *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.category),
                            ),
                            items: _categories
                                .where((cat) => cat != 'All')
                                .map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _categoryController.text = newValue;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.book),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Publisher
                          TextFormField(
                            controller: _publisherController,
                            decoration: InputDecoration(
                              labelText: 'Publisher *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.building),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the publisher';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Pages and Language
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _pagesController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Pages *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon:
                                        const Icon(Iconsax.document_text),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _languageController,
                                  decoration: InputDecoration(
                                    labelText: 'Language *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixIcon:
                                        const Icon(Iconsax.language_square),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Description
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Description *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.note_text),
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter the description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // URLs
                          TextFormField(
                            controller: _pdfUrlController,
                            decoration: InputDecoration(
                              labelText: 'PDF URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.link),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _coverUrlController,
                            decoration: InputDecoration(
                              labelText: 'Cover Image URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.link),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _preview1UrlController,
                            decoration: InputDecoration(
                              labelText: 'Preview Image 1 URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.link),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _preview2UrlController,
                            decoration: InputDecoration(
                              labelText: 'Preview Image 2 URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Iconsax.link),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Checkboxes
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Latest'),
                                  value: _isLatest,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isLatest = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text('Popular'),
                                  value: _isPopular,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isPopular = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Submit Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _submitForm,
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(_isEditing
                                          ? Iconsax.edit
                                          : Iconsax.add),
                                  label: Text(
                                      _isEditing ? 'Update Note' : 'Add Note'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                ),
                              ),
                              if (_isEditing) ...[
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _resetForm,
                                  icon: const Icon(Iconsax.close_circle),
                                  label: const Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Mobile Books List
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey[50],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.book, color: Colors.deepPurpleAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Notes List',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                            ),
                            const Spacer(),
                            Text('${_filteredBooks.length} books'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mobile Search
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search notes...',
                            prefixIcon: const Icon(Iconsax.search_normal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Mobile Category Filter
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Filter by Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedCategory = newValue;
                                _filterBooks();
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Mobile Books List
                        _isLoading
                            ? const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('Loading Notes...'),
                                  ],
                                ),
                              )
                            : _filteredBooks.isEmpty
                                ? Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Iconsax.book,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          _books.isEmpty
                                              ? 'No books added yet'
                                              : 'No books match your search',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _filteredBooks.length,
                                    itemBuilder: (context, index) {
                                      final book = _filteredBooks[
                                          _filteredBooks.length - 1 - index];
                                      return _buildBookCard(book);
                                    },
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${book['publisher'] ?? 'Unknown Publisher'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (book['isLatest'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (book['isLatest'] == true && book['isPopular'] == true)
                      const SizedBox(width: 4),
                    if (book['isPopular'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Details
            Row(
              children: [
                Expanded(
                  child: _buildBookDetail(
                    icon: Iconsax.category,
                    label: 'Category',
                    value: book['category'] ?? 'Uncategorized',
                  ),
                ),
                Expanded(
                  child: _buildBookDetail(
                    icon: Iconsax.language_square,
                    label: 'Language',
                    value: book['language'] ?? 'Unknown',
                  ),
                ),
                Expanded(
                  child: _buildBookDetail(
                    icon: Iconsax.document_text,
                    label: 'Pages',
                    value: '${book['pages'] ?? 0}',
                  ),
                ),
              ],
            ),

            if (book['description'] != null &&
                book['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                book['description'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _editBook(book),
                  icon: const Icon(Iconsax.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () =>
                      _deleteBook(book['\$id'], book['title'] ?? 'Unknown'),
                  icon: const Icon(Iconsax.trash, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
