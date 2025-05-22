import 'dart:io';
import 'dart:math';

import 'package:alamoody/features/contact_us/presentation/screens/contact_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../main/presentation/cubit/main_cubit.dart';
import '../cubits/create_edit_playlist/create_playlist_cubit.dart';
import '../cubits/create_edit_playlist/edit_playlist_cubit.dart';
import '../cubits/create_edit_playlist/playlists_state.dart';
import '../cubits/my_playlists/my_playlists_cubit.dart';

// Constants
const _formPadding = EdgeInsets.all(16);
const _elementSpacing = SizedBox(height: 16);
const _imageSizeFactor = 0.3;
const _minNameLength = 3;

void showEditCreatePlaylistBottomSheet(
  BuildContext context, {
  bool isEdit = false,
  String? id,
  String? existingName,
  String? existingDescription,
  String? existingImage,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => PlaylistForm(
      isEdit: isEdit,
      id: id,
      existingName: existingName,
      existingDescription: existingDescription,
      existingImage: existingImage,
    ),
  );
}

class PlaylistForm extends StatefulWidget {
  final bool isEdit;
  final String? id;
  final String? existingName;
  final String? existingDescription;
  final String? existingImage;

  const PlaylistForm({
    super.key,
    required this.isEdit,
    this.id,
    this.existingName,
    this.existingDescription,
    this.existingImage,
  });

  @override
  State<PlaylistForm> createState() => _PlaylistFormState();
}

class _PlaylistFormState extends State<PlaylistForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.existingName);
    _descriptionController =
        TextEditingController(text: widget.existingDescription);
  }

  Future<void> _handleImageSelection() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('image_selection_error')!,
          ),
        ),
      );
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final accessToken =
        context.read<LoginCubit>().authenticatedUser?.accessToken;
    if (accessToken == null) return;

    widget.isEdit
        ? context.read<EditPlaylistCubit>().editPlaylist(
              playlistId: widget.id!,
              playlistName: _nameController.text,
              playlistDes: _descriptionController.text,
              playlistImage: _selectedImage,
              accessToken: accessToken,
            )
        : context.read<CreatePlaylistCubit>().createPlaylist(
              playlistName: _nameController.text,
              playlistDes: _descriptionController.text,
              playlistImage: _selectedImage,
              accessToken: accessToken,
            );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditPlaylistCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistSuccess) {
              Constants.showToast(message: state.message);

              Navigator.pop(context);
            }
            if (state is PlaylistError) {
              Constants.showError(context, state.error);
            }
          },
        ),
        BlocListener<CreatePlaylistCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistSuccess) {
              Constants.showToast(message: state.message);
            }
            if (state is PlaylistError) {
              Constants.showError(context, state.error);
            }
          },
        ),
      ],
      child: _buildFormContent(context),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        bottom: max(0, MediaQuery.of(context).viewInsets.bottom),
      ),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final bool isDarkMode = MainCubit.isDark;
          return Container(
            decoration:
                Constants.customBackgroundDecoration(isDarkMode: isDarkMode),
            padding: _formPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _elementSpacing,
                _buildImagePicker(screenWidth),
                _elementSpacing,
                _buildFormFields(context),
                _elementSpacing,
                _buildSubmitButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker(double screenWidth) => Center(
        child: GestureDetector(
          onTap: _handleImageSelection,
          child: Container(
            width: screenWidth * _imageSizeFactor,
            height: screenWidth * _imageSizeFactor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: _selectedImage != null
                ? _buildSelectedImage()
                : widget.existingImage != null
                    ? _buildExistingImage()
                    : const Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
          ),
        ),
      );

  Widget _buildSelectedImage() => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_selectedImage!, fit: BoxFit.cover),
      );

  Widget _buildExistingImage() => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(widget.existingImage!, fit: BoxFit.cover),
      );

  Widget _buildFormFields(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: [
            _buildNameField(context),
            const SizedBox(height: 10),
            _buildDescriptionField(context),
          ],
        ),
      );

  Widget _buildNameField(BuildContext context) {
    final myPlaylistsCubit = BlocProvider.of<MyPlaylistsCubit>(context);
    final List<String> existingNames = myPlaylistsCubit.songsMyPlaylists
        .map(
          (playlist) => playlist.title!.trim().toLowerCase(),
        ) // Normalize case
        .toList();

    return SupportTextFormField(
      hintText:
          AppLocalizations.of(context)!.translate('give_your_playlist_a_name')!,
      controller: _nameController,
      icon: Icons.list_sharp,
      title: AppLocalizations.of(context)!.translate('playlist_name')!,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!
              .translate('playlist_name_cant_be_empty');
        }

        final enteredName = value.trim().toLowerCase(); // Normalize case

        if (existingNames.contains(enteredName) && !widget.isEdit) {
          return AppLocalizations.of(context)!.translate(
            'playlist_name_already_exists',
          ); // Custom error message
        }

        return null; // Validation passed
      },
    );
  }

  Widget _buildDescriptionField(BuildContext context) => SupportTextFormField(
        hintText: AppLocalizations.of(context)!
            .translate('tell_us_about_your_playlist')!,
        controller: _descriptionController,
        icon: Icons.playlist_play,
        title: AppLocalizations.of(context)!.translate('playlist_des')!,
        validator: (value) {
          return null;
        },
      );

  Widget _buildSubmitButton(BuildContext context) =>
      widget.isEdit ? _buildEditButton() : _buildCreateButton();

  Widget _buildCreateButton() =>
      BlocBuilder<CreatePlaylistCubit, PlaylistState>(
        builder: (context, state) => _buildActionButton(
          isLoading: state is PlaylistLoading,
          label: AppLocalizations.of(context)!.translate('create')!,
        ),
      );

  Widget _buildEditButton() => BlocBuilder<EditPlaylistCubit, PlaylistState>(
        builder: (context, state) => _buildActionButton(
          isLoading: state is PlaylistLoading,
          label: AppLocalizations.of(context)!.translate('save')!,
        ),
      );

  Widget _buildActionButton({required bool isLoading, required String label}) =>
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: GradientCenterTextButton(
                buttonText: label,
                listOfGradient: [
                  HexColor("#DF23E1"),
                  HexColor("#3820B2"),
                  HexColor("#39BCE9"),
                ],
                onTap: isLoading ? null : _submitForm,
              ),
            );
}
