import 'dart:developer';
import 'dart:io';

import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_drop_down_button_form_field.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/update_profile/update_profile_cubit.dart';

class EditProfileInfoScreen extends StatefulWidget {
  const EditProfileInfoScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileInfoScreen> createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  late List<String> _genders;
  String? _userGender;
  // Country _userCountry = Country(id: 1, name: 'Egypt');
  // Country? _userNationality;
  File? _profilePhoto;
  final _picker = ImagePicker();

  Future<void> _pickProfileImg() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  _initUserGender() {
    _userGender =
        context.read<ProfileCubit>().userProfileData!.user!.gender ?? '';
    for (int gender = 0; gender < _genders.length; gender++) {
      if (_userGender == AppStrings.female) {
        _userGender = _genders[1];
        break;
      } else if (_userGender == AppStrings.male) {
        _userGender = _genders[0];
        break;
      }
    }
  }

  // Future<void> _getUserProfile() =>
  //     BlocProvider.of<ProfileCubit>(context).getUserProfile(
  //       accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
  //     );
  @override
  void initState() {
    //    _genders = [
    //   AppLocalizations.of(context)!.translate('male')!,
    //   AppLocalizations.of(context)!.translate('female')!,
    // ];
    _birthDateController.text =
        context.read<ProfileCubit>().userProfileData!.user!.birth! ?? '';
    _nameController.text =
        context.read<ProfileCubit>().userProfileData!.user!.name! ?? '';
    // _nameController.text =
    //     context.read<ProfileCubit>().userProfileData!.user!.name!;
    _mobileController.text =
        context.read<ProfileCubit>().userProfileData!.user!.phone! ?? '';
    _userNameController.text =
        context.read<ProfileCubit>().userProfileData!.user!.username! ?? '';

    _bioController.text =
        context.read<ProfileCubit>().userProfileData!.user!.bio! ?? '';
    _emailController.text =
        context.read<ProfileCubit>().userProfileData!.user!.email! ?? '';
    _userGender =
        context.read<ProfileCubit>().userProfileData!.user!.gender ?? '';
    // _initUserGender();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  AutovalidateMode autovalidateMode(UpdateProfileState state) => state
          is UpdateProfileValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;

  Widget _buildBodyContent(UpdateProfileState updateProfileState) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileIsLoading) {
          return const LoadingIndicator();
        } else if (state is ProfileError) {
          return error_widget.ErrorWidget(
            msg: state.message!,
            // onRetryPressed: () => _getUserProfile(),
          );
        } else if (state is ProfileLoaded) {
          _genders = [
            AppLocalizations.of(context)!.translate('male')!,
            AppLocalizations.of(context)!.translate('female')!,
          ];

          // // _nameController.text = state.userProfile.user!.name!;
          // // _userNameController.text = state.userProfile.user!.username!;
          // // _mobileController.text = state.userProfile.user!.phone! ?? '';
          // _bioController.text = state.userProfile.user!.bio! ?? '';
          // _emailController.text = state.userProfile.user!.email! ?? '';
          // _userGender = state.userProfile.user!.gender;

          _initUserGender();
          log(
            state.userProfile.user!.image!,
          );
          return SingleChildScrollView(
            child: SafeArea(
              child: Form(
                autovalidateMode: autovalidateMode(updateProfileState),
                key: _formKey,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackArrow(),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate("update_profile")!,
                            style:
                                styleW700(context)!.copyWith(fontSize: 20),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              if (_profilePhoto != null)
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      FileImage(_profilePhoto!),
                                )
                              else
                                CircleAvatar(
                                  radius: 58,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: state.userProfile.user!.image ==
                                            null
                                        ? Image.asset(
                                            ImagesPath.defaultUserIcon,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.29, // Adjust as needed
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.29,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: state
                                                .userProfile
                                                .user!
                                                .image!, // Default placeholder URL
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (
                                              context,
                                              url,
                                              error,
                                            ) =>
                                                Image.asset(
                                              ImagesPath.defaultUserIcon,
                                            ), // Local error image asset
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.29, // Adjust as needed
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.29,
                                          ),
                                  ),
                                ),
                              SvgPicture.network(
                                state.userProfile.user!.image!,
                              ),
                              Positioned(
                                bottom: 5,
                                child: GestureDetector(
                                  onTap: () => _pickProfileImg(),
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.cPrimary,
                                    radius: 20,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
          
                        ///ll
          
                        AuthTextFormField(
                          hintText: AppLocalizations.of(context)!
                              .translate('name'),
                          inputData: TextInputType.text,
                          textEditingController: _nameController,
                          validationFunction: validateName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          svgPath: ImagesPath.userIconSvg,
                        ),
          
                        AuthTextFormField(
                          hintText: AppLocalizations.of(context)!
                              .translate('user_name'),
                          inputData: TextInputType.text,
                          textEditingController: _userNameController,
                          validationFunction: validateUserName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          svgPath: ImagesPath.userIconSvg,
                        ),
                        AuthTextFormField(
                          hintText: AppLocalizations.of(context)!
                              .translate('mobile_number'),
                          inputData: TextInputType.phone,
                          textEditingController: _mobileController,
                          validationFunction: validateUserName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          svgPath: ImagesPath.phoneIconSvg,
                        ),
                        AuthTextFormField(
                          hintText: AppLocalizations.of(context)!
                              .translate('email'),
                          inputData: TextInputType.emailAddress,
                          textEditingController: _emailController,
                          validationFunction: validateEmail,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          svgPath: ImagesPath.emailIconSvg,
                        ),
                        AuthTextFormField(
                          hintText: AppLocalizations.of(context)!
                              .translate('bio'),
                          inputData: TextInputType.text,
                          textEditingController: _bioController,
                          validationFunction: validateName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          svgPath: ImagesPath.bioSvgIcon,
                        ),
                        AuthTextFormField(
                          svgPath: ImagesPath.birthDateSvgIcon,
                          hintText: AppLocalizations.of(context)!
                              .translate('birth_date'),
                          inputData: TextInputType.datetime,
                          textEditingController: _birthDateController,
                          textInputAction: TextInputAction.next,
                          suffixIcon: Icons.edit,
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(FocusNode());
                            DateTime initialDateValue =
                                _birthDateController.text.isNotEmpty
                                    ? DateFormat("yyyy-MM-dd")
                                        .parse(_birthDateController.text)
                                    : DateTime(DateTime.now().year - 15);
          
                            if (initialDateValue.isAfter(
                                DateTime(DateTime.now().year - 1),)) {
                              initialDateValue =
                                  DateTime(DateTime.now().year - 15);
                            }
                            showRoundedDatePicker(
                              height: 350,
                              context: context,
                              theme: ThemeData(
                                primarySwatch: Colors.deepPurple,
                                primaryColor: AppColors.cPrimary,
                              ),
                              initialDate: initialDateValue,
                              firstDate: DateTime(DateTime.now().year - 80),
                              lastDate: DateTime(DateTime.now().year + 20),
                            ).then((value) {
                              if (value != null) {
                                _birthDateController.text =
                                    value.toString().substring(0, 10);
                                //              var outputFormat = DateFormat('MM/dd/yyyy');
                                // var outputDate = outputFormat.format(value);
                                // _birthDateController.text = outputDate;
                              }
                            });
                          },
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
          
                        StatefulBuilder(
                          builder: (context, setState) =>
                              DefaultDropdownButtonFormField(
                            // prefix: SvgPicture.asset(ImagesPath.genderSvgIcon ),
                            hintTxt: AppLocalizations.of(context)!
                                .translate('gender'),
                            validationFunction: validateGender,
                            onChangedFunction: (value) {
                              setState(() {
                                _userGender = value;
                              });
                            },
                            value: _userGender,
                            hintColor: Colors.white,
                            items: _genders.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Container(
                                  height: 48.0,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Text(
                                    item,
                                  ),
                                ),
          
                                //  Text(
                                //   item,
                                //   style: styleW500(context, color: Colors.white),
                                // ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (!context
                                .watch<UpdateProfileCubit>()
                                .isloading ||
                            _profilePhoto == null)
                          GradientCenterTextButton(
                            buttonText: AppLocalizations.of(context)!
                                .translate('save'),
                            listOfGradient: [
                              HexColor("#DF23E1"),
                              HexColor("#3820B2"),
                              HexColor("#39BCE9"),
                            ],
                            onTap: () {
                              // log(_profilePhoto.toString());
                              // log(_nameController.text);
                              printColored(_birthDateController.text);
                              printColored(_nameController.text);
                              printColored(_mobileController.text);
                              BlocProvider.of<UpdateProfileCubit>(context)
                                  .updateProfile(
                                formKey: _formKey,
                                accessToken: context
                                    .read<LoginCubit>()
                                    .authenticatedUser!
                                    .accessToken!,
                                name: _nameController.text,
                                email: _emailController.text,
                                bio: _bioController.text,
                                userName: _userNameController.text,
                                phoneNumber: _mobileController.text,
                                countryId: '',
                                // _userCountry.id!,
                                profilePhoto: _profilePhoto,
                                gender: _userGender ==
                                        AppLocalizations.of(context)!
                                            .translate('male')!
                                    ? AppStrings.male
                                    : AppStrings.female,
                                birthDate: _birthDateController.text,
                              );
                            },
                          )
                        else
                          const LoadingIndicator(),
                      ]
                          .map(
                            (e) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.height * .007,
                                horizontal: context.width * .05,
                              ),
                              child: e,
                            ),
                          )
                          .toList(),
                    ),
                    BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                      builder: (context, state) {
                        return state is UpdateProfileLoading
                            ? Container(
                                // color: Theme.of(context)
                                //     .scaffoldBackgroundColor
                                //     .withOpacity(0.9),
                                alignment: Alignment.center,
                                 color:Colors.white
                          .withOpacity(0.6),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: const CircularProgressIndicator(),
                              )
                            : const SizedBox();
                      },
                    ),
               
                  ],
                ),
              ),
            ),
          );
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusedBackground(
        lightBG: ImagesPath.homeBGLightBG,
        body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              Constants.showToast(
                message: AppLocalizations.of(context)!
                    .translate('change_profile_info_successfully')!,
              );
              // BlocProvider.of<LoginCubit>(context).authenticatedUser =
              //     state.user;
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.mainRoute,
                (Route<dynamic> route) => false,
              );
            } else if (state is UpdateProfileFailed) {
              Constants.showError(
                context,
                state.message != null ? 'error' : state.message,
              );
            }
          },
          builder: (context, state) {
            return _buildBodyContent(state);
          },
        ),
      ),
    );
  }
}
