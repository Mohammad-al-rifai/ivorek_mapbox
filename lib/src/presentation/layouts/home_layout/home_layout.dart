import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:mapbox/src/core/utils/resources/color_manager.dart';
import 'package:mapbox/src/data/data_sources/lacal/cache/cache_helper.dart';
import 'package:mapbox/src/data/data_sources/lacal/cache/keys.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/utils/resources/assets_manager.dart';
import '../../../core/utils/resources/strings_manager.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;

  Position createRandomPosition() {
    var random = Random();
    return Position(
      random.nextDouble() * -360.0 + 180.0,
      random.nextDouble() * -180.0 + 90.0,
    );
  }

  Point createRandomPoint() {
    return Point(coordinates: createRandomPosition());
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    mapboxMap.annotations.createPointAnnotationManager().then(
      (value) async {
        pointAnnotationManager = value;
        final ByteData bytes = await rootBundle.load(IconsAssets.marker);
        final Uint8List list = bytes.buffer.asUint8List();
        createOneAnnotation(list);
      },
    );
  }

  void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(
          PointAnnotationOptions(
            geometry: Point(
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
            textField: "Marker",
            textOffset: [0.0, -2.0],
            textColor: Colors.red.value,
            iconSize: 0.2,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list,
          ),
        )
        .then(
          (value) => pointAnnotation = value,
        );
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Style loaded :), time: ${data.timeInterval}",
        ),
        backgroundColor: ColorManager.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  _onCameraChangeListener(CameraChangedEventData data) {}

  _onResourceRequestListener(ResourceEventData data) {}

  _onMapIdleListener(MapIdleEventData data) {}

  _onMapLoadedListener(MapLoadedEventData data) {}

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {}

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {}

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {}

  _onSourceAddedListener(SourceAddedEventData data) {}

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {}

  _onSourceRemovedListener(SourceRemovedEventData data) {}

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {}

  _onStyleImageMissingListener(StyleImageMissingEventData data) {}

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {}

  @override
  Widget build(BuildContext context) {
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
              onMapCreated: _onMapCreated,
              onStyleLoadedListener: _onStyleLoadedCallback,
              onCameraChangeListener: _onCameraChangeListener,
              onMapIdleListener: _onMapIdleListener,
              onMapLoadedListener: _onMapLoadedListener,
              onMapLoadErrorListener: _onMapLoadingErrorListener,
              onRenderFrameStartedListener: _onRenderFrameStartedListener,
              onRenderFrameFinishedListener: _onRenderFrameFinishedListener,
              onSourceAddedListener: _onSourceAddedListener,
              onSourceDataLoadedListener: _onSourceDataLoadedListener,
              onSourceRemovedListener: _onSourceRemovedListener,
              onStyleDataLoadedListener: _onStyleDataLoadedListener,
              onStyleImageMissingListener: _onStyleImageMissingListener,
              onStyleImageUnusedListener: _onStyleImageUnusedListener,
              onResourceRequestListener: _onResourceRequestListener,
              onLongTapListener: (coordinate) {},
            ),
          ],
        ),
      ),
      floatingActionButton: locateMeWidget(),
    );
  }

  initCameraOpt() {
    return CameraOptions(
      center: Point(
        coordinates: Position(
          num.parse(CacheHelper.getData(
            key: CacheHelperKeys.longitude,
          ).toString()),
          num.parse(CacheHelper.getData(
            key: CacheHelperKeys.latitude,
          ).toString()),
        ),
      ).toJson(),
      zoom: 17,
    );
  }

  locateMeWidget() {
    return FloatingActionButton(
      onPressed: () async {
        Location location = Location();
        LocationData locationData = await location.getLocation();

        mapboxMap?.flyTo(
          CameraOptions(
            anchor: ScreenCoordinate(x: 0, y: 0),
            center: Point(
              coordinates: Position(
                num.parse(locationData.longitude.toString()),
                num.parse(locationData.latitude.toString()),
              ),
            ).toJson(),
            zoom: 17,
            bearing: 180,
            pitch: 30,
          ),
          MapAnimationOptions(
            duration: 2000,
            startDelay: 0,
          ),
        );
      },
      child: const Icon(Icons.my_location),
    );
  }
}
