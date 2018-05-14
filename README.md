Welcome to the companion repository to the Google I/O talk by
@mjohnsullivan and @filiph called [Build reactive mobile apps
with Flutter][session].

[session]: https://www.youtube.com/watch?v=RS36gBEp8OI

The meat of this repo is in the `shared/` directory. That contains our
shopping app example built in many different architectural patterns. The app
decides in runtime (in [`lib/main.dart`][libmain]) which pattern it's going
to use. The architectures themselves are in subdirectories of `lib/src/`.

[libmain]: https://github.com/filiph/state_experiments/blob/master/shared/lib/main.dart

The two `hello_world*/` directories are the incrementer app before
the live coding session and after it.

This is not an official Google product.
