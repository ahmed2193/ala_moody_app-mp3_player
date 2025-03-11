
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/locale/app_localizations.dart';
import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/helper/font_style.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../../../core/utils/loading_indicator.dart';
import '../../../cubits/category/category_cubit.dart';
import '../../../widgets/category_grid_item.dart';

class CategorySectionSearchScreen extends StatelessWidget {
   CategorySectionSearchScreen({
        Key? key,

  required this.scrollController,
    required this.onRetryPressed,
  }) : super(key: key);
  ScrollController scrollController = ScrollController();
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return 
    
    
     
    
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppPadding.pDefault),
          child: Text(
            AppLocalizations.of(context)!.translate('categories')!,
            style: styleW600(context, fontSize: FontSize.f16),
          ),
        ),
        const SizedBox(
          height: AppPadding.p4,
        ),
        // // category gridview
        // will send model after api here
         Expanded(child:    BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryIsLoading && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is CategoryIsLoading) {
          BlocProvider.of<CategoryCubit>(context).loadMore = true;
        } else if (state is CategoryError) {
          return error_widget.ErrorWidget(
            onRetryPressed: () => onRetryPressed,
            msg: state.message!,
          );
        }

        return BlocProvider.of<CategoryCubit>(context).category.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.only(
                  start: AppPadding.p18,
                  end: AppPadding.p18,
                  top: AppPadding.p10,
                  bottom: AppPadding.p20 * 7,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppPadding.p18,
                  mainAxisSpacing: AppPadding.p18,
                  childAspectRatio: 1.9,
                ),
                itemCount: BlocProvider.of<CategoryCubit>(context)
                        .category
                        .length +
                    (BlocProvider.of<CategoryCubit>(context).loadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index <
                      BlocProvider.of<CategoryCubit>(context).category.length) {
                    return CategoryGridItem(
                      category: BlocProvider.of<CategoryCubit>(context)
                          .category[index],
                    );
                    // FeaturedListSlider(
                    //   index: index,
                    //   category: BlocProvider.of<CategoryCubit>(context)
                    //       .category[index],
                    // );
                  } else if (BlocProvider.of<CategoryCubit>(context).pageNo <=
                      BlocProvider.of<CategoryCubit>(context).totalPages) {
                    Timer(const Duration(milliseconds: 30), () {
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent,
                      );
                    });

                    return const LoadingIndicator();
                  }
                  return const SizedBox();
                },
              )
            :  Center(
                child: Text(AppLocalizations.of(context)!
                                  .translate("no_data")!,),
              );
      },
         ),
 ),
      ],
    );
  }
}
