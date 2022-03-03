# PERME 0.0.0
## What is this?
PERsistent MEmoisation.

This is a damn naive implementation, so do not ever trust, please.

## Alternatives and differences.
Please tell me if exists.

### Related libraries.
If you want in-memory memoization the libraries below may help you.

* [function-cache]
* [fare-memoization]
* [defmemo]

## Usage

```lisp
* (perme:memoise your-function-name)

* (perme:forget your-function-name)
```

## From developer
### Constraint about object serialization.
PERME depends on [cl-store] to store object.
And [cl-store] says

> not all yet

So the objects that [cl-store] can not serialize are can not memoized by perme too.

### Constraint about argument keys.
PERME uses [sxhash] to make [pathname] that holds the memoized results.

CLHS says

> (let ((r (make-random-state)))
>  (= (sxhash r) (sxhash (make-random-state r))))
>  =>  implementation-dependent

So conflict may occur.

### Product's goal

### License
MIT

### Developed with

### Tested with

## Installation

<!-- Links -->

[function-cache]:https://github.com/AccelerationNet/function-cache
[fare-memoization]:https://gitlab.common-lisp.net/frideau/fare-memoization
[defmemo]:https://github.com/orivej/defmemo
[cl-store]:https://github.com/kingcons/cl-store
[sxhash]:http://clhs.lisp.se/Body/f_sxhash.htm
[pathname]:http://www.lispworks.com/documentation/HyperSpec/Body/t_pn.htm
