import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ahmed_baba/features/product_catalog/data/repositories/catalog_repository.dart';

// ---- Events ----
abstract class CatalogEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends CatalogEvent {
  final String query;
  final int page;
  SearchProductsEvent(this.query, {this.page = 1});
  @override
  List<Object?> get props => [query, page];
}

class LoadProductDetailEvent extends CatalogEvent {
  final String itemId;
  LoadProductDetailEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

// ---- States ----
abstract class CatalogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}
class CatalogLoading extends CatalogState {}

class CatalogSearchSuccess extends CatalogState {
  final List<Map<String, dynamic>> products;
  CatalogSearchSuccess(this.products);
  @override
  List<Object?> get props => [products];
}

class CatalogDetailSuccess extends CatalogState {
  final Map<String, dynamic> product;
  CatalogDetailSuccess(this.product);
  @override
  List<Object?> get props => [product];
}

class CatalogError extends CatalogState {
  final String message;
  CatalogError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---- BLoC ----
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repo;

  CatalogBloc(this._repo) : super(CatalogInitial()) {
    on<SearchProductsEvent>(_onSearch);
    on<LoadProductDetailEvent>(_onDetail);
  }

  Future<void> _onSearch(SearchProductsEvent event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    try {
      final products = await _repo.searchProducts(event.query, page: event.page);
      emit(CatalogSearchSuccess(products));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }

  Future<void> _onDetail(LoadProductDetailEvent event, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    try {
      final product = await _repo.getProductDetail(event.itemId);
      emit(CatalogDetailSuccess(product));
    } catch (e) {
      emit(CatalogError(e.toString()));
    }
  }
}
