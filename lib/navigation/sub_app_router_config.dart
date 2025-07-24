import 'package:go_router/go_router.dart';

/// Abstract class to be implemented by each sub-app's router configuration.
/// This allows the base app to collect routes from all sub-apps.
abstract class SubAppRouterConfig {
  /// Returns a list of GoRoutes defined by this sub-app.
  /// These routes will be integrated into the main GoRouter.
  List<RouteBase> getRoutes();
}




/*

class SubAppOneRouter implements SubAppRouterConfig {
  static const String basePath = '/sub_app_one';
  static const String detailPath = '$basePath/detail';
  @override
  List<RouteBase> getRoutes() {
    return [
      ShellRoute(
        // path: basePath,
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            HealthScaffoldingApp(child: child),
        routes: [
          GoRoute(
            path: HomeView.route,
            name: 'Health home page',
            builder: (BuildContext context, GoRouterState state) {
              // final String? id = state.queryParameters['id'];
              // return SubAppOneDetailScreen(id: id);
              return HomeView();
            },
          ),
          GoRoute(
            path: CalenderView.route,
            name: 'Health Calender page',
            builder: (BuildContext context, GoRouterState state) {
              return CalenderView();
            },
          ),
          GoRoute(
            path: ExploreView.route,
            name: 'Health ExploreView page',
            builder: (BuildContext context, GoRouterState state) {
              return ExploreView();
            },
          ),
        ],
      ),
    ];
  }
}


then call each sub app config in main app router 


// Define a list of all sub-app router configurations
List<SubAppRouterConfig> _subAppRouterConfigs = [
  HealthAppRouter(),
];


then inject them within the routes of main app 
var routes = [
    ..._subAppRouterConfigs.expand((config) => config.getRoutes()),
    ... other routes of main app
]
*/