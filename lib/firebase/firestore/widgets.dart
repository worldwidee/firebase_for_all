import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'models.dart';

class CollectionBuilder<T extends Object?> extends StatefulWidget {
  CollectionSnapshots<T> stream;
  Widget Function(BuildContext, AsyncSnapshot<QuerySnapshotForAll<T>>) builder;
  CollectionBuilder({Key? key, required this.stream, required this.builder})
      : super(key: key);

  @override
  State<CollectionBuilder> createState() =>
      _CollectionBuilderState<T>(stream, builder);
}

class _CollectionBuilderState<T extends Object?> extends State<CollectionBuilder<T>> {
  CollectionSnapshots<T> stream;
  Widget Function(BuildContext, AsyncSnapshot<QuerySnapshotForAll<T>>) builder;
  SnapshotState<QuerySnapshotForAll<T>>? state;
  _CollectionBuilderState(this.stream, this.builder) {
    state = const SnapshotState.waiting();
  }

  @override
  void initState() {
    widget.stream.listen((event) {
      state = SnapshotState<QuerySnapshotForAll<T>>.withData(ConnectionState.active, event);
      setState(() {});
    }, onError: (error, stackTrace) {
      state =
          SnapshotState<QuerySnapshotForAll<T>>.withError(ConnectionState.active, error, stackTrace);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (state!.hasData) {
      return builder(
          context, AsyncSnapshot.withData(state!.connectionState, state!.data!));
    } else if (state!.hasError) {
      return builder(
          context,
          AsyncSnapshot.withError(state!.connectionState, state!.error!,
              state!.stackTrace ?? StackTrace.empty));
    } else if (state!.isWaiting) {
      return builder(context, const AsyncSnapshot.waiting());
    } else {
      return builder(context, const AsyncSnapshot.nothing());
    }
  }
}

class DocumentBuilder<T extends Object?> extends StatefulWidget {
  DocumentSnapshots<T> stream;
  Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshotForAll<T>>) builder;
  DocumentBuilder({Key? key, required this.stream, required this.builder})
      : super(key: key);

  @override
  State<DocumentBuilder> createState() =>
      _DocumentBuilderState<T>(stream, builder);
}

class _DocumentBuilderState<T extends Object?> extends State<DocumentBuilder<T>> {
  DocumentSnapshots<T> stream;
  Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshotForAll<T>>) builder;
  SnapshotState<DocumentSnapshotForAll<T>>? state;
  _DocumentBuilderState(this.stream, this.builder) {
    state = const SnapshotState.waiting();
  }

  @override
  void initState() {
    widget.stream.listen((event) {
      state = SnapshotState<DocumentSnapshotForAll<T>>.withData(ConnectionState.active, event);
      setState(() {});
    }, onError: (error, stackTrace) {
      state =
          SnapshotState<DocumentSnapshotForAll<T>>.withError(ConnectionState.active, error, stackTrace);
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (state!.hasData) {
      return builder(
          context, AsyncSnapshot.withData(state!.connectionState, state!.data!));
    } else if (state!.hasError) {
      return builder(
          context,
          AsyncSnapshot.withError(state!.connectionState, state!.error!,
              state!.stackTrace ?? StackTrace.empty));
    } else if (state!.isWaiting) {
      return builder(context, const AsyncSnapshot.waiting());
    } else {
      return builder(context, const AsyncSnapshot.nothing());
    }
  }
}

