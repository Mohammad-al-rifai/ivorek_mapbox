import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mapbox/src/core/utils/resources/color_manager.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:meta/meta.dart';

import '../../../core/utils/resources/assets_manager.dart';
import '../../../data/data_sources/local/cache/cache_helper.dart';
import '../../../data/data_sources/local/cache/keys.dart';

part 'map_box_states.dart';

class MapBoxCubit extends Cubit<MapBoxStates> {
  MapBoxCubit() : super(MapBoxInitial());

  static MapBoxCubit get(context) => BlocProvider.of(context);

  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;
  PolylineAnnotation? polylineAnnotation;
  PolylineAnnotationManager? polylineAnnotationManager;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;

  onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;
    createMarker();
    createLine();
    createCirclePoint();
  }

  createCirclePoint() {
    mapboxMap?.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;

      var options = <CircleAnnotationOptions>[];
      options.add(
        CircleAnnotationOptions(
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
          circleColor: Colors.blue.value,
          circleRadius: 8.0,
        ),
      );

      circleAnnotationManager?.createMulti(options);
    });
  }

  createLine() {
    mapboxMap?.annotations.createPolylineAnnotationManager().then(
      (value) {
        polylineAnnotationManager = value;
        final positions = <List<Position>>[];
        positions.add(
          [
            Position(
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
            Position(
              51.53132875669448,
              25.285563502927413,
            ),
          ],
        );

        polylineAnnotationManager?.createMulti(
          positions
              .map(
                (e) => PolylineAnnotationOptions(
                  geometry: LineString(coordinates: e).toJson(),
                  lineColor: ColorManager.primary.value,
                  lineWidth: 5.0,
                  lineBlur: 3.0,
                  lineBorderColor: 1,
                  lineOpacity: 1.0,
                  lineBorderWidth: 1.0,
                ),
              )
              .toList(),
        );
      },
    );
  }

  createMarker() {
    mapboxMap?.annotations.createPointAnnotationManager().then(
      (value) async {
        pointAnnotationManager = value;
        final ByteData bytes = await rootBundle.load(IconsAssets.marker);
        final Uint8List list = bytes.buffer.asUint8List();
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
            iconSize: 0.3,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list,
          ),
        )
            .then(
          (value) {
            emit(MarkerPositionedDoneState());
            return pointAnnotation = value;
          },
        );
      },
    );
  }

  getUserLocation() async {
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
  }

  onCameraChangeListener(CameraChangedEventData data) {}

  onResourceRequestListener(ResourceEventData data) {}

  onMapIdleListener(MapIdleEventData data) {}

  onMapLoadedListener(MapLoadedEventData data) {}

  onMapLoadingErrorListener(MapLoadingErrorEventData data) {}

  onRenderFrameStartedListener(RenderFrameStartedEventData data) {}

  onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {}

  onSourceAddedListener(SourceAddedEventData data) {}

  onSourceDataLoadedListener(SourceDataLoadedEventData data) {}

  onSourceRemovedListener(SourceRemovedEventData data) {}

  onStyleDataLoadedListener(StyleDataLoadedEventData data) {}

  onStyleImageMissingListener(StyleImageMissingEventData data) {}

  onStyleImageUnusedListener(StyleImageUnusedEventData data) {}
}
