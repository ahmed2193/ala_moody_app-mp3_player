import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/your_mood/your_mood_cubit.dart';
import '../../cubits/your_mood/your_mood_state.dart';
import '../../widgets/small_container_item.dart';

class MoodsSection extends StatelessWidget {
  const MoodsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YourMoodCubit, YourMoodState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              BlocProvider.of<YourMoodCubit>(context).mood.length,
              (index) => SmallContainerMood(
                titleMood:
                    BlocProvider.of<YourMoodCubit>(context).mood[index].name,
                isSelected: BlocProvider.of<YourMoodCubit>(context)
                    .mood[index]
                    .moodState!,
                image: BlocProvider.of<YourMoodCubit>(context)
                    .mood[index]
                    .artworkUrl,
                    color:BlocProvider.of<YourMoodCubit>(context).mood[index].color,
                onTap: () => BlocProvider.of<YourMoodCubit>(context)
                    .changeSelectedMood(index),
              ),
            ),
          ),
        );
      },
    );
  }
}
