import 'package:background_fetch/background_fetch.dart';
import 'location_service.dart';

void backgroundFetchHeadlessTask(String taskId) async {
  // Perform location tracking
  LocationService();

  BackgroundFetch.finish(taskId);
}

void configureBackgroundFetch() {
  BackgroundFetch.configure(BackgroundFetchConfig(
    minimumFetchInterval: 30,
    stopOnTerminate: false,
    startOnBoot: true,
    enableHeadless: true,
  ), (String taskId) async {
    LocationService();
    BackgroundFetch.finish(taskId);
  });

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
