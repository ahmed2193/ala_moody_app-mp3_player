// import 'dart:async';

// import 'package:alamoody/core/helper/app_size.dart';
// import 'package:alamoody/features/search/presentation/widgets/category_grid_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/utils/error_widget.dart' as error_widget;
// import '../../../../core/utils/loading_indicator.dart';
// import '../../../../core/utils/no_data.dart';
// import '../../../auth/presentation/cubit/login/login_cubit.dart';
// import '../cubits/category/category_cubit.dart';

// class GridViewList extends StatefulWidget {
//    GridViewList({
//         Key? key,

//   required this.scrollController,
//     required this.onRetryPressed,
//   }) : super(key: key);
//   ScrollController scrollController = ScrollController();
//   final VoidCallback onRetryPressed;

//   @override
//   State<GridViewList> createState() => _GridViewListState();
// }

// class _GridViewListState extends State<GridViewList> {
//   final _scrollController = ScrollController();

//   void _getCategory() {
//     BlocProvider.of<CategoryCubit>(context).getCategory(
//       accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
//     );
//   }

//   void _setup_scrollController(context) {
//     _scrollController.addListener(() {
//       if (_scrollController.position.atEdge) {
//         if (_scrollController.position.pixels != 0 &&
//             BlocProvider.of<CategoryCubit>(context).pageNo <=
//                 BlocProvider.of<CategoryCubit>(context).totalPages) {
//           _getCategory();
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     BlocProvider.of<CategoryCubit>(context).clearData();

//     _getCategory();
//     _setup_scrollController(context);
//     super.initState();
//   }

//   Widget _buildBodyContent() {
//     return
  
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildBodyContent();
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../../../../../core/utils/error_widget.dart' as error_widget;
// // import '../../../../core/utils/loading_indicator.dart';
// // import '../../../../core/utils/no_data.dart';
// // import '../../../auth/presentation/cubit/login/login_cubit.dart';
// // import '../cubits/category/category_cubit.dart';

// // class GridViewList extends StatefulWidget {
// //   const GridViewList({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   State<GridViewList> createState() => _GridViewListState();
// // }

// // class _GridViewListState extends State<GridViewList> {
// //   final _scrollController = ScrollController();

// //  void _getCategory() {
// //     BlocProvider.of<CategoryCubit>(context).getCategory(
// //       accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
// //     );
// //   }

// //   void _setup_scrollController(context) {
// //     _scrollController.addListener(() {
// //       if (_scrollController.position.atEdge) {
// //         if (_scrollController.position.pixels != 0 &&
// //             BlocProvider.of<CategoryCubit>(context).pageNo <=
// //                 BlocProvider.of<CategoryCubit>(context).totalPages) {
// //           _getCategory();
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     BlocProvider.of<CategoryCubit>(context).clearData();

// //     _getCategory();
// //     _setup_scrollController(context);
// //     super.initState();
// //   }

// //   Widget _buildBodyContent() {
// //     return BlocBuilder<CategoryCubit, CategoryState>(
// //       builder: (context, state) {
// //         if (state is CategoryIsLoading && state.isFirstFetch) {
// //           return const LoadingIndicator();
// //         }
// //         if (state is CategoryIsLoading) {
// //           BlocProvider.of<CategoryCubit>(context).loadMore = true;
// //         } else if (state is CategoryError) {
// //           return error_widget.ErrorWidget(
// //             onRetryPressed: () => _getCategory(),
// //             msg: state.message!,
// //           );
// //         }

// //         return BlocProvider.of<CategoryCubit>(context).category.isNotEmpty
// //             ? Center(child: NoData(height: MediaQuery.of(context).size.height/5.6

            
// //             ,),)
// //             //  GridView.builder(
// //             //     shrinkWrap: true,
// //             //     physics: const BouncingScrollPhysics(),
// //             //     padding: const EdgeInsetsDirectional.only(
// //             //       start: AppPadding.p20,
// //             //       end: AppPadding.p20,
// //             //       top: AppPadding.p10,
// //             //       bottom: AppPadding.p20 * 2,
// //             //     ),
// //             //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //             //       crossAxisCount: 2,
// //             //       crossAxisSpacing: AppPadding.p20,
// //             //       mainAxisSpacing: AppPadding.p20,
// //             //       childAspectRatio: 1.5,
// //             //     ),
// //             //     itemCount: BlocProvider.of<CategoryCubit>(context)
// //             //             .category
// //             //             .length +
// //             //         (BlocProvider.of<CategoryCubit>(context).loadMore ? 1 : 0),
// //             //     itemBuilder: (context, index) {
// //             //       if (index <
// //             //           BlocProvider.of<CategoryCubit>(context).category.length) {
// //             //         return CategoryGridItem(
// //             //           category: BlocProvider.of<CategoryCubit>(context)
// //             //               .category[index],
// //             //         );
// //             //         // FeaturedListSlider(
// //             //         //   index: index,
// //             //         //   category: BlocProvider.of<CategoryCubit>(context)
// //             //         //       .category[index],
// //             //         // );
// //             //       } else if (BlocProvider.of<CategoryCubit>(context).pageNo <=
// //             //           BlocProvider.of<CategoryCubit>(context).totalPages) {
// //             //         Timer(const Duration(milliseconds: 30), () {
// //             //           _scrollController.jumpTo(
// //             //             _scrollController.position.maxScrollExtent,
// //             //           );
// //             //         });

// //             //         return const LoadingIndicator();
// //             //       }
// //             //       return const SizedBox();
// //             //     },
// //             //   )
            
// //             : const Center(
// //                 child: Text('no data'),
// //               );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return _buildBodyContent();
// //   }
// // }
