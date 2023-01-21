import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapButtonsPluginOption extends LayerOptions {
  final bool mini;
  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final LatLng initLocation;

  MapButtonsPluginOption({
    Key? key,
    this.mini = true,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
    required this.initLocation,
    Stream<Null>? rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class MapButtonsPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is MapButtonsPluginOption) {
      return MapButtons(options, mapState, stream);
    }
    throw Exception('Unknown options type for ZoomButtonsPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MapButtonsPluginOption;
  }
}

class MapButtons extends StatelessWidget {
  final MapButtonsPluginOption zoomButtonsOpts;
  final MapState map;
  final Stream<void> stream;
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12.0));

  MapButtons(this.zoomButtonsOpts, this.map, this.stream)
      : super(key: zoomButtonsOpts.key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: zoomButtonsOpts.alignment,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: zoomButtonsOpts.padding,
              top: zoomButtonsOpts.padding,
              right: zoomButtonsOpts.padding,
            ),
            child: FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: zoomButtonsOpts.mini,
              backgroundColor:
                  zoomButtonsOpts.zoomInColor ?? Theme.of(context).primaryColor,
              onPressed: () async {
                var location = Location();
                try {
                  var currentLocation = await location.getLocation();
                  map.move(
                    LatLng(
                        currentLocation.latitude!, currentLocation.longitude!),
                    12,
                    source: MapEventSource.custom,
                  );
                } catch (e) {}
              },
              child: Icon(zoomButtonsOpts.zoomInIcon,
                  color: zoomButtonsOpts.zoomInColorIcon ??
                      IconTheme.of(context).color),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(zoomButtonsOpts.padding),
            child: FloatingActionButton(
              heroTag: 'zoomOutButton',
              mini: zoomButtonsOpts.mini,
              backgroundColor: zoomButtonsOpts.zoomOutColor ??
                  Theme.of(context).primaryColor,
              onPressed: () async {
                try {
                  map.move(zoomButtonsOpts.initLocation, 12,
                      source: MapEventSource.custom);
                } catch (e) {}
              },
              child: Icon(
                zoomButtonsOpts.zoomOutIcon,
                color: zoomButtonsOpts.zoomOutColorIcon ??
                    IconTheme.of(context).color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
