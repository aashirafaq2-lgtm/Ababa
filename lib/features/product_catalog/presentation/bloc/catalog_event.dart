import 'package:equatable/equatable.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductMatrixEvent extends CatalogEvent {
  final String? productId;

  const FetchProductMatrixEvent({this.productId});

  @override
  List<Object?> get props => [productId];
}

class SearchProductsEvent extends CatalogEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
