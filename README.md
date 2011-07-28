# FFI::Tk

This library provides you with a wrapper for the Tk windowing toolkit.


## Installation

    gem install ffi-tk

No compilation is required, but I'm not yet confident that this will run on
every architecture without changes, FFI::Tk is being developed on Archlinux and
Debian on Intel i686 and AMD x86_64, testers for other platforms are invited to
give it a try and report any problems that occur.

You will need to have tk installed in order to actually use the library.

## Ruby-FFI

Ruby-FFI is a ruby extension for programmatically loading dynamic libraries,
binding functions within them, and calling those functions from Ruby code.

It lives at: http://wiki.github.com/ffi/ffi

Ruby-FFI ships with JRuby and Rubinius, and is available as a gem for MRI.


## Hello, World!

    require 'ffi-tk'

    Tk.init

    Tk::Button.new('.', text: 'Press me'){
      Tk.message_box(message: 'Hello, World!')
    }.pack

    Tk.mainloop


## Aims and Means

First of all, FFI::Tk doesn't try to be a drop-in replacement for the tk library
of Ruby's stdlib.

We will try to keep things as simple as possible, and there will not be 10
different ways to achieve the same thing through numerous aliases.

We will not rely on any compiled extensions and the only dependency is FFI to
keep things portable between different Ruby implementations (as far as they do
implement the 1.9.1 standard syntax and core functinoality.)

I (manveru) will not provide a version of FFI::Tk for 1.8.x, there may be other
persons that undertake this step, but due to lack of true encoding support it
will be significant overhead to cater to both versions as you can see if you
read a bit through the stdlib tk library.
We will provide only wrapping for the standard distribution of tcl/tk as of
version 8.5.7.
Earlier versions have not been tested, and later versions may be used by taking
advantage of the Tcl stub mechanism.

Custom extensions of tcl/tk may be wrapped by other people, and we will add a
link to any such project, but we try to keep things simple here.

A comprehensive suite of specs describes the behaviour of FFI::Tk as well as
possible.

The namespaces used are:

* Tk
* FFI::Tk
* FFI::Tcl

The Tk namespace conflicts with the name of the Ruby's stdlib tk, but the use of
them within one application is mutually exclusive anyway.


## License

FFI::Tk is distributed under MIT license.
Parts of the documentation were obtained from the tcl/tk manpages and modified
to clarify and apply to the specifics of the FFI::Tk wrapper.
These parts of the documentation are under Tcl license.

The licenses can be found in doc/TCL_LICENSE and doc/MIT_LICENSE respectively.
