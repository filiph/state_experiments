This version of the app shows how you would manage a more complex scenario with the usage
of Streams and BLoC (business logic components).

This app has the following functionality on top of the ones in other versions:

* The product list is arbitrarily large (in fact, it is infinite).
* Products are loaded asynchronously from (fake) network in batches.
* Only a limited slice of the product catalog is held in memory.
* Products in the catalog that are already in cart are marked as such (their name is underlined).

To make this work, we're introducing two new BLoCs:

* CatalogBloc, which takes care of loading data from network according to the latest indexes
  in the infinite product grid
* ProductSquareBloc, which tracks whether a product is already in cart or not

The concept of BLoC is lightly touched on in [our I/O session][] (for which this is the companion
sample repository) and more thoroughly explained in [this DartConf talk][] by Paolo Soares.

[our I/O session]: https://www.youtube.com/watch?v=RS36gBEp8OI
[this DartConf talk]: https://www.youtube.com/watch?v=PLHln7wHgPE