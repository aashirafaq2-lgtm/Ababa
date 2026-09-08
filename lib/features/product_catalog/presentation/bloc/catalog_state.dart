import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

class CatalogInitialState extends CatalogState {}

class CatalogLoadingState extends CatalogState {}

class CatalogLoadedState extends CatalogState {
  final List<ProductEntity> products;

  const CatalogLoadedState(this.products);

  @override
  List<Object?> get props => [products];
}

class CatalogErrorState extends CatalogState {
  final String message;

  const CatalogErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
