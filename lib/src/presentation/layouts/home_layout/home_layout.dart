import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox/src/presentation/cubits/mapbox_cubit/map_box_cubit.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/utils/resources/color_manager.dart';
import '../../../core/utils/resources/strings_manager.dart';
import '../../../data/data_sources/local/cache/cache_helper.dart';
import '../../../data/data_sources/local/cache/keys.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBoxCubit, MapBoxStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MapBoxCubit cubit = MapBoxCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.ivorekMap,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                MapWidget(
                  key: const ValueKey("mapWidget"),
                  cameraOptions: initCameraOpt(),
                  styleUri: MapboxStyles.STANDARD,
                  textureView: true,
                  onMapCreated: cubit.onMapCreated,
                  onStyleLoadedListener: onStyleLoadedCallback,
                  onCameraChangeListener: cubit.onCameraChangeListener,
                  onMapIdleListener: cubit.onMapIdleListener,
                  onMapLoadedListener: cubit.onMapLoadedListener,
                  onMapLoadErrorListener: cubit.onMapLoadingErrorListener,
                  onRenderFrameStartedListener:
                      cubit.onRenderFrameStartedListener,
                  onRenderFrameFinishedListener:
                      cubit.onRenderFrameFinishedListener,
                  onSourceAddedListener: cubit.onSourceAddedListener,
                  onSourceDataLoadedListener: cubit.onSourceDataLoadedListener,
                  onSourceRemovedListener: cubit.onSourceRemovedListener,
                  onStyleDataLoadedListener: cubit.onStyleDataLoadedListener,
                  onStyleImageMissingListener:
                      cubit.onStyleImageMissingListener,
                  onStyleImageUnusedListener: cubit.onStyleImageUnusedListener,
                  onResourceRequestListener: cubit.onResourceRequestListener,
                  onLongTapListener: (coordinate) {},
                ),
              ],
            ),
          ),
          floatingActionButton: locateMeWidget(),
        );
      },
    );
  }

  initCameraOpt() {
    return CameraOptions(
      center: Point(
        coordinates: Position(
          num.parse(
            CacheHelper.getData(
              key: CacheHelperKeys.longitude,
            ).toString(),
          ),
          num.parse(
            CacheHelper.getData(
              key: CacheHelperKeys.latitude,
            ).toString(),
          ),
        ),
      ).toJson(),
      zoom: 17,
    );
  }

  locateMeWidget() {
    return BlocConsumer<MapBoxCubit, MapBoxStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MapBoxCubit cubit = MapBoxCubit.get(context);
        return FloatingActionButton(
          onPressed: () {
            cubit.getUserLocation();
          },
          child: const Icon(Icons.my_location),
        );
      },
    );
  }

  onStyleLoadedCallback(StyleLoadedEventData? data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Style loaded :), time: ${data?.timeInterval}",
        ),
        backgroundColor: ColorManager.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
