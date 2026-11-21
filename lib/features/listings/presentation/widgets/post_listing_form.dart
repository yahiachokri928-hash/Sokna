import 'package:flutter/material.dart';

import '../../../../core/strings/messages.dart';
import '../../domain/entities/listing_entity.dart';

class PostListingForm extends StatefulWidget {
  final ValueChanged<ListingEntity> onListingSubmitted;

  const PostListingForm({
    super.key,
    required this.onListingSubmitted,
  });

  @override
  State<PostListingForm> createState() => _PostListingFormState();
}

class _PostListingFormState extends State<PostListingForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _imageController = TextEditingController();
  final _ownerController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPropertyType = CATEGORY_APPARTEMENT;
  double _rooms = 2;
  bool _isFurnished = true;
  bool _hasParking = false;
  DateTime? _selectedDate;

  final List<String> _propertyTypes = [
    CATEGORY_STUDIO,
    CATEGORY_APPARTEMENT,
    CATEGORY_VILLA,
    CATEGORY_MAISON,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _surfaceController.dispose();
    _imageController.dispose();
    _ownerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(VALIDATION_DATE_REQUIRED)),
      );
      return;
    }

    final String dateString =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final newListing = ListingEntity(
      id: "sokna_${DateTime.now().millisecondsSinceEpoch}",
      title: _titleController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      propertyType: _selectedPropertyType,
      price: int.parse(_priceController.text.trim()),
      rooms: _rooms.round(),
      surface: double.parse(_surfaceController.text.trim()),
      isFurnished: _isFurnished,
      hasParking: _hasParking,
      imagePath: _imageController.text.trim().isNotEmpty
          ? _imageController.text.trim()
          : "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=80",
      rating: 5.0,
      reviewCount: 1,
      ownerName: _ownerController.text.trim(),
      availableFrom: dateString,
      description: _descriptionController.text.trim(),
    );

    widget.onListingSubmitted(newListing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre de l'annonce
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: POST_FIELD_TITLE,
                prefixIcon: Icon(Icons.title_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return VALIDATION_REQUIRED;
                }
                if (value.trim().length < 5) {
                  return VALIDATION_TITLE_MIN_LENGTH;
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // Ville & Adresse
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: POST_FIELD_CITY,
                      prefixIcon: Icon(Icons.location_city_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return VALIDATION_REQUIRED;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: POST_FIELD_ADDRESS,
                      prefixIcon: Icon(Icons.pin_drop_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return VALIDATION_REQUIRED;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Type de bien
            DropdownButtonFormField<String>(
              initialValue: _selectedPropertyType,
              decoration: const InputDecoration(
                labelText: POST_FIELD_TYPE,
                prefixIcon: Icon(Icons.home_work_outlined),
              ),
              items: _propertyTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPropertyType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),

            // Loyer mensuel & Surface
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: POST_FIELD_PRICE,
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return VALIDATION_REQUIRED;
                      }
                      final price = int.tryParse(value.trim());
                      if (price == null || price <= 0) {
                        return VALIDATION_PRICE_POSITIVE;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextFormField(
                    controller: _surfaceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: POST_FIELD_SURFACE,
                      prefixIcon: Icon(Icons.square_foot_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return VALIDATION_REQUIRED;
                      }
                      final surface = double.tryParse(value.trim());
                      if (surface == null || surface <= 0) {
                        return VALIDATION_SURFACE_POSITIVE;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Nombre de pièces (Slider 1 à 6)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      POST_FIELD_ROOMS,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '$LISTING_ROOM_PREFIX${_rooms.round()}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _rooms,
                  min: 1,
                  max: 6,
                  divisions: 5,
                  label: '${_rooms.round()}',
                  onChanged: (val) {
                    setState(() {
                      _rooms = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Date de disponibilité (DatePicker)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.calendar_month_rounded,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                _selectedDate == null
                    ? POST_FIELD_DATE
                    : "$POST_FIELD_DATE : ${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: OutlinedButton(
                onPressed: _pickDate,
                child: const Text(ACTION_CONFIRM),
              ),
            ),
            const Divider(),

            // Meublé & Parking switches
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(POST_SWITCH_FURNISHED),
              value: _isFurnished,
              onChanged: (val) {
                setState(() {
                  _isFurnished = val;
                });
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(POST_SWITCH_PARKING),
              value: _hasParking,
              onChanged: (val) {
                setState(() {
                  _hasParking = val ?? false;
                });
              },
            ),
            const SizedBox(height: 12.0),

            // Nom du propriétaire & URL image
            TextFormField(
              controller: _ownerController,
              decoration: const InputDecoration(
                labelText: POST_FIELD_OWNER,
                prefixIcon: Icon(Icons.person_rounded),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return VALIDATION_REQUIRED;
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: POST_FIELD_IMAGE,
                prefixIcon: Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(height: 16.0),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: POST_FIELD_DESCRIPTION,
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return VALIDATION_REQUIRED;
                }
                return null;
              },
            ),
            const SizedBox(height: 24.0),

            // Bouton de soumission
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text(POST_SUBMIT_BUTTON),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50.0),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
