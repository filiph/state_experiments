This version of the app shows how you would manage a more complex scenario with the usage
of Streams and BLoC (business logic components).

This app has the following functionality on top of the one in other versions:

* The product list is arbitrarily large (in fact, it is infinite)
* Products are loaded asynchronously from (fake) network in batches
* Only a limited slice of the product catalog is held in memory.
* Products in the catalog that are already in cart are marked as such (their name is underlined).

To make this work, we're introducing two new BLoCs:

* CatalogBloc, which takes care of loading data from network according to the latest indexes
  in the infinite product grid
* ProductSquareBloc, which tracks whether a product is already in cart or not