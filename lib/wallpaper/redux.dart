import 'package:app/wallpaper/api.dart';
import 'package:redux/redux.dart';

class CategoryState {
  final CategoryResult categoryResult;
  CategoryState(this.categoryResult);

  factory CategoryState.init() {
    return CategoryState(CategoryResult([]));
  }
}

class WallpaperState {
  final WallpaperResult wallpaperResult;
  WallpaperState({this.wallpaperResult});

  factory WallpaperState.init() {
    return WallpaperState(wallpaperResult: WallpaperResult([]));
  }
}

class WallpaperCommentState {
  final WallpaperCommentResult wallpaperCommentResult;
  WallpaperCommentState(this.wallpaperCommentResult);

  factory WallpaperCommentState.init() =>
      WallpaperCommentState(WallpaperCommentResult([]));
}

class WallpaperCommentResultAction {
  final WallpaperCommentResult wallpaperCommentResult;
  WallpaperCommentResultAction(this.wallpaperCommentResult);
}

class CategoryResultAction {
  final CategoryResult categoryResult;
  CategoryResultAction(this.categoryResult);
}

class WallpaperClearAction {}

class WallpaperResultAction {
  final WallpaperResult wallpaperResult;
  WallpaperResultAction(this.wallpaperResult);
}

CategoryState _onResult(CategoryState state, CategoryResultAction action) =>
    CategoryState(action.categoryResult);

WallpaperState _onWallpaperClear(
        WallpaperState state, WallpaperClearAction action) =>
    WallpaperState.init();

WallpaperState _onWallpaperResult(
    WallpaperState state, WallpaperResultAction action) {
  state.wallpaperResult.items.addAll(action.wallpaperResult.items);
  return state;
}

WallpaperCommentState _onWallpaperCommentResult(
        WallpaperCommentState state, WallpaperCommentResultAction action) =>
    WallpaperCommentState(action.wallpaperCommentResult);

final wallpaperReducer = combineReducers<WallpaperState>([
  TypedReducer<WallpaperState, WallpaperClearAction>(_onWallpaperClear),
  TypedReducer<WallpaperState, WallpaperResultAction>(_onWallpaperResult),
]);
final categoryReducer = combineReducers<CategoryState>([
  TypedReducer<CategoryState, CategoryResultAction>(_onResult),
]);
final wallpaperCommentReducer = combineReducers<WallpaperCommentState>([
  TypedReducer<WallpaperCommentState, WallpaperCommentResultAction>(
      _onWallpaperCommentResult)
]);

class AppState {
  final CategoryState categoryState;
  final WallpaperState wallpaperState;
  final WallpaperCommentState wallpaperCommentState;
  AppState(
      {this.categoryState, this.wallpaperState, this.wallpaperCommentState});

  factory AppState.init() {
    return AppState(
        categoryState: CategoryState.init(),
        wallpaperState: WallpaperState.init(),
        wallpaperCommentState: WallpaperCommentState.init());
  }
}

AppState appReducer(AppState appstate, dynamic action) {
  return AppState(
      categoryState: categoryReducer(appstate.categoryState, action),
      wallpaperState: wallpaperReducer(appstate.wallpaperState, action),
      wallpaperCommentState:
          wallpaperCommentReducer(appstate.wallpaperCommentState, action));
}
