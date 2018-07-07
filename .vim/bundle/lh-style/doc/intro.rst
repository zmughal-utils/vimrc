Introduction
============

lh-style is a vim script library that defines vim functions and commands that permit to specify stylistic preferences
like naming conventions, bracket formatting, etc.

In itself the only feature end-users can directly exploit is name converting based on the style name (``snake_case``,
``UpperCamelCase``...) like Abolish plugin does, or on a given identifier kind (*function*, *type*, *class*,
*attribute*...).  Check :ref:`NameConvert` and :ref:`ConvertNames` -- sorry I wasn't inspired.

The main, and unique, feature this plugin offers is core code-style functionalities that other plugins can exploit.
Typical client plugins would be code generating plugins: wizards/snippet/abbreviation plugins, and refactoring plugins.

The style can be tuned through options. The options are meant to be tuned by end-users, and indirectly used by plugin
maintainers.  See :ref:`API section <API>` to see how you could exploit these options from your plugins.

Snippets from `lh-cpp <http://github.com/LucHermitte/lh-cpp>`_ and
`mu-template <http://github.com/LucHermitte/mu-template>`_\ , and refactorings from
`vim-refactor <http://github.com/LucHermitte/vim-refactor>`_ exploit the options offered by lh-style for specifying code
style.

..

   Note: The library has been extracted from `lh-dev <http://github.com/LucHermitte/lh-dev>`_ v2.x.x. in order to remove dependencies to `lh-tags <http://github.com/LucHermitte/lh-tags>`_ and other plugins from template/snippet expander plugins like `mu-template <http://github.com/LucHermitte/mu-template>`_. Yet, I've decided to reset the version counter to 1.0.0.

