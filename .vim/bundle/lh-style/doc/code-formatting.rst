.. _CodeFormatting:

Code formatting
===============

Some projects will want to have open curly-brackets on new lines (see
`Allman indenting style <https://en.wikipedia.org/wiki/Indentation_style#Allman_style>`_), other will prefer to have the
open bracket on the same line as the function/control-statement/... (see
`K&R indenting style <https://en.wikipedia.org/wiki/Indentation_style#K.26R>`_,
`Java coding style <https://en.wikipedia.org/wiki/Indentation_style#Variant:_Java>`_...). We can also choose whether
one space shall be inserted before opening braces, and so on.

Of course we could apply reformatting tools (like :program:`clang-format`) on demand, but then we'd need to identify a set of
different tools dedicated to different languages. The day code formatting is handled by
`Language Server Protocol <http://langserver.org/>`_, we would have access to a simple and extensible solution. In the
mean time, here is lh-style.

lh-style doesn't do any replacement by itself on snippets or abbreviations. It is expected to be used by snippet plugins
or from abbreviation definitions.  So far, only `mu-template <http://github.com/LucHermitte/mu-template>`_ and `lh-cpp
<http://github.com/LucHermitte/lh-cpp>`_ exploit this feature.

Different people will need to do different things:


* Plugin maintainers will use the :ref:`dedicated API <Formatting-api>` to reformat on-the-fly the code they generate.
* End-users will specify the coding style used on their project(s):

  * either by specifying a set of independent styles on different topics (:ref:`families <StyleFamilies>`) (|UseStyle|_, |editorconfig|_, |clang-format|_),
  * or by being extremely precise (|AddStyle|_).


.. _StyleFamilies:

Style families
--------------

Families already implemented
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

At this time, the following style families are implemented:

* `EditorConfig styles <https://github.com/editorconfig/editorconfig/wiki/EditorConfig-Properties#ideas-for-domain-specific-properties>`_:


  * ``curly_bracket_next_line``  = [``yes``, ``no``] // ``true,`` ``false,`` ``0,`` ``1``.
  * ``indent_brace_style``       = [``0tbs``, ``1tbs``, ``allman``, ``bsd_knf``, ``gnu``, ``horstmann``, ``java``, ``K&R``, ``linux_kernel``, ``lisp``, ``none``, ``pico``, ``ratliff``, ``stroustrup``, ``whitesmiths``]
  * ``spaces_around_brackets``   = [``inside``, ``outside``, ``both``, ``none``]

* `Clang-Format styles <https://clangformat.com/>`_:


  * ``breakbeforebraces``        = [``allman``, ``attach``, ``gnu``, ``linux``, ``none``, ``stroustrup`` ]
  * ``spacesbeforeparens``       = [``none``, ``never``, ``always``, ``control-statements``]
  * ``spacesinemptyparentheses`` = [``yes``, ``no``] // ``true,`` ``false,`` ``0,`` ``1``.
  * ``spacesinparentheses``      = [``yes``, ``no``] // ``true,`` ``false,`` ``0,`` ``1``.

Styles `can easilly be added <#extending-the-families>`_ in ``{&rtp}/autoload/lh/style/``.

If you want more precise control, without family management, you can use |AddStyle|_ instead.


.. |UseStyle| replace:: :samp:`:UseStyle`
.. _UseStyle:

:samp:`:UseStyle {style-family}={value} [-buffer] [-ft[={ft}]] [-prio={prio}]`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Given *style families*, :samp:`:UseStyle` can be used to specify which particular style shall be used when generating
code.

For instance,

.. code-block:: vim

   :UseStyle breakbeforebraces=Allman -ft=c
   :UseStyle spacesbeforeparens=control-statements -ft=c
   :UseStyle spacesinparentheses=no

will tune snippets/abbreviations to follow `Allman indenting style <https://en.wikipedia.org/wiki/Indentation_style#Allman_style>`_, and to add a space before control-statement parentheses, and to never insert a space inside parentheses.

.. note::
    Some families are incompatible with other families. It happens quickly when we mix overlapping families from different origins.

``:UseStyle`` options
~~~~~~~~~~~~~~~~~~~~~~~~~


* :samp:`{style-family}={value}` specifies, given a style family, what choice has been made.

   If you don't remember them all, don't worry, :samp:`:UseStyle` supports command-line completion.

   Setting the style to ``none`` unsets the whole family for the related
   `buffers <http://vimhelp.appspot.com/windows.txt.html#buffers>`_/`filetype <http://vimhelp.appspot.com/filetype.txt.html#filetype>`_.
   Giving a new :samp:`{value}`, overrides the style for the related
   `buffers <http://vimhelp.appspot.com/windows.txt.html#buffers>`_/`filetype <http://vimhelp.appspot.com/filetype.txt.html#filetype>`_.

* :samp:`-buffer` defines this association only for the current buffer. This option is meant to be used with plugins like `local_vimrc <https://github.com/LucHermitte/local_vimrc>`_.

* :samp:`-ft[={ft}]` defines this association only for the specified filetype. When :samp:`{ft}` is not specified, it applies only to the current filetype. This option is meant to be used in .vimrc, in the global zone of `filetype-plugin <http://vimhelp.appspot.com/usr_43.txt.html#filetype%2dplugin>`_\ s or possibly in `local_vimrcs <https://github.com/LucHermitte/local_vimrc>`_ (when combined with :samp:`-buffer`).
* :samp:`-prio={prio}` Sets a priority that'll be used to determine which key is matching the text to enhance. By default all styles have a priority of 1. The typical application is to have template expander ignore single curly brackets.

.. note::
    Local configuration (with :samp:`-buffer`) have the priority over filetype specialized configuration (with :samp:`-ft`).


.. |editorconfig| replace:: :file:`.editorconfig`
.. _editorconfig:

:file:`.editorconfig`
^^^^^^^^^^^^^^^^^^^^^

lh-style registers a hook to `editorconfig-vim <https://github.com/editorconfig/editorconfig-vim>`_ in order to extract
style choices expressed in any |editorconfig| file that applies.

The syntax would be:

.. code-block:: ini

   [*]
   indent_brace_style=Allman

In every buffer where EditorConfig applies its settings, it will be translated into:

.. code-block:: vim

   :UseStyle -b indent_brace_style=allman

.. |clang-format| replace:: :file:`.clang-format`
.. _clang-format:

:file:`.clang-format`
^^^^^^^^^^^^^^^^^^^^^

The idea is the same: to detect automatically a |clang-format| configuration file in project root directory and apply
the styles supported by lh-style.

.. warning:: At this time, this feature isn't implemented yet.

Extending the families
^^^^^^^^^^^^^^^^^^^^^^

New style families can be defined (and even contributed back -- as soon as I write the contributing guide...). The
following procedure has to be respected:

1. Create a new `autoload plugin <http://vimhelp.appspot.com/eval.txt.html#autoload>`_ named :file:`{rtp}/autoload/lh/style/{family-name}.vim`

2. Define the following (required) functions:

  * :samp:`lh#style#{family-name}#_known_list()` which will be used by command-line completion

  * :samp:`lh#style#{family-name}#use({styles}, {value} [, {options}])` which defines the chosen style.

    The typical content of this function is the following:

    .. code-block:: vim

        function! lh#style#{family-name}#use(styles, value, ...) abort
          let input_options = get(a:, 1, {})
          let [options, local_global, prio, ft] = lh#style#_prepare_options_for_add_style(input_options)

          " I usually use a `lh#style#{family-name}#__new()` function for this purpose.
          let s:crt_style = lh#style#define_group('some.unique.family.id', name, local_global, ft)

          " Then we dispatch the a:value option to decide how the text should be displayed
          if     a:value =~? value_pattern1
            call s:crt_style.add(regex1, repl1, prio)
          elseif a:value =~? value_pattern2
            call s:crt_style.add(regex2, repl2, prio)
          else
            call s:crt_style.add(regex3, repl3, prio)
          endif
          return 1
        endfunction

  .. note::
        * It'll be best to also define the other functions I have in all my autoload plugins in order to simplify logging and debugging.
        * I highly recommand you take the time to write some unit tests -- yeah, I know, I haven't written them for all possible cases supported by lh-style.

  .. todo::
        * Describe ``!cursorhere!``, ``!mark!`` and ``lh#marker#txt()``
        * Describe negative pattern
        * Describe how priorities applies
        * Describe other ways to dispatch
        * Describe  ``none()``

----

Low-level style configuration
-----------------------------

Historically, there wasn't any way to group style configurations as |UseStyle|_.
permits. We add to define everything manually, and switching from one complex
configuration to another was tedious.

While using |UseStyle|_. is now the preferred method, we can still use the low level method.


.. |AddStyle| replace:: :samp:`:AddStyle`
.. _AddStyle:

:samp:`:AddStyle {key} [-buffer] [-ft[={ft}]] [-prio={prio}] {Replacement}`
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* :samp:`{key}` is a regex that will get replaced automatically (by plugins supporting this API)
* :samp:`{replacement}` is what will be inserted in place of :samp:`{key}`
* :samp:`-buffer` defines this association only for the current buffer. This option is meant to be used with plugins like `local_vimrc <https://github.com/LucHermitte/local_vimrc>`_.
* :samp:`-ft[={ft}]` defines this association only for the specified filetype. When :samp:`{ft}` is not specified, it applies only to the current filetype. This option is meant to be used in .vimrc, in the global zone of `filetype-plugin <http://vimhelp.appspot.com/usr_43.txt.html#filetype%2dplugin>`_\ s or possibly in `local_vimrcs <https://github.com/LucHermitte/local_vimrc>`_ (when combined with :samp:`-buffer`).
* :samp:`-prio={prio}` Sets a priority that'll be used to determine which key is matching the text to enhance. By default all styles have a priority of 1. The typical application is to have template expander ignore single curly brackets.

.. note::
    Local configuration (with :samp:`-buffer`) have the priority over filetype specialized configuration (with :samp:`-ft`).

(Deprecated) ``:AddStyle`` Examples:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: vim

   " # Space before open bracket in C & al {{{2
   " A little space before all C constructs in C and child languages
   " NB: the spaces isn't put before all open brackets
   AddStyle if(     -ft=c   if\ (
   AddStyle while(  -ft=c   while\ (
   AddStyle for(    -ft=c   for\ (
   AddStyle switch( -ft=c   switch\ (
   AddStyle catch(  -ft=cpp catch\ (

   " # Ignore style in comments after curly brackets {{{2
   AddStyle {\ *// -ft=c &
   AddStyle }\ *// -ft=c &

   " # Multiple C++ namespaces on same line {{{2
   AddStyle {\ *namespace -ft=cpp &
   AddStyle }\ *} -ft=cpp &

   " # Doxygen {{{2
   " Doxygen Groups
   AddStyle @{  -ft=c @{
   AddStyle @}  -ft=c @}

   " Doxygen Formulas
   AddStyle \\f{ -ft=c \\\\f{
   AddStyle \\f} -ft=c \\\\f}

   " # Default style in C & al: Stroustrup/K&R {{{2
   AddStyle {  -ft=c -prio=10 {\n
   AddStyle }; -ft=c -prio=10 \n};\n
   AddStyle }  -ft=c -prio=10 \n}

   " # Inhibated style in C & al: Allman, Whitesmiths, Pico {{{2
   " AddStyle {  -ft=c -prio=10 \n{\n
   " AddStyle }; -ft=c -prio=10 \n};\n
   " AddStyle }  -ft=c -prio=10 \n}\n

   " # Ignore curly-brackets on single lines {{{2
   AddStyle ^\ *{\ *$ -ft=c &
   AddStyle ^\ *}\ *$ -ft=c &

   " # Handle specifically empty pairs of curly-brackets {{{2
   " On its own line
   " -> Leave it be
   AddStyle ^\ *{}\ *$ -ft=c &
   " -> Split it
   " AddStyle ^\ *{}\ *$ -ft=c {\n}

   " Mixed
   " -> Split it
   " AddStyle {} -ft=c -prio=5 {\n}
   " -> On the next line (unsplit)
   AddStyle {} -ft=c -prio=5 \n{}
   " -> On the next line (split)
   " AddStyle {} -ft=c -prio=5 \n{\n}

   " # Java style {{{2
   " Force Java style in Java
   AddStyle { -ft=java -prio=10 {\n
   AddStyle } -ft=java -prio=10 \n}

When you wish to adopt Allman coding style, in :file:`${project_root}/_vimrc_local.vim`

.. code-block:: vim

   AddStyle { -b -ft=c -prio=10 \n{\n
   AddStyle } -b -ft=c -prio=10 \n}
