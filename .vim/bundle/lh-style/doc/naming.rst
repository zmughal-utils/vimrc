.. _NamingPolicy:

Naming policy
=============

Thanks to lh-style, we can define how the names of functions, classes, constants, attributes, etc. shall be written: in
``UpperCamelCase``, in ``lowerCamelCase``, in ``snake_case``, or in ``Any_otherStyle``).

This information can then be retrieved by plugins through the :ref:`Naming-API`.

This information can also be used from |NameConvert|_ and |ConvertNames|_ commands.

NB: both commands support command-line auto-completion on naming policy names.


.. |NameConvert| replace:: :samp:`:NameConvert`
.. _NameConvert:

:samp:`:NameConvert {policy}`
-----------------------------

:samp:`:NameConvert` converts the identifier under the cursor to one of the following naming policies:


* naming styles: ``upper_camel_case``, ``lower_camel_case``, ``underscore``/``snake``, ``variable``,
* identifier kinds: ``getter``, ``setter``, ``local``, ``global``, ``member``, ``static``, ``constant``, ``param`` (the exact conversion process can be tuned thanks to the `following options <#options-to-tune-the-naming-policy>`_).

.. |ConvertNames| replace:: :samp:`:ConvertNames`
.. _ConvertNames:

:samp:`:[range]ConvertNames/{pattern}/{policy}/[{flags}]`
---------------------------------------------------------

:samp:`ConvertNames` transforms according to the :samp:`{policy}` all names that match the :samp:`{pattern}` -- it
applies |NameConvert| on text matched by ``:substitute``.

See `:h :s_flags <http://vimhelp.appspot.com/change.txt.html#%3as_flags>`_ regarding possible :samp:`{flags}`.

Options to tune the naming policy
---------------------------------

Naming conventions can be defined to:


* Control prefix and suffix on:

  * variables (main name)
  * global and local variables
  * member and static variables
  * (formal) parameters
  * constants
  * getters and setters
  * types

* Control the case policy (``snake_case``, ``UpperCamelCase``, ``lowerCamelCase``) on functions (and thus on setters and
  getters too) and types.

It is done, respectively, with the following options:


* regarding prefix and suffix:

  * ``(bpg):[{ft}_]naming_strip_re`` and ``(bpg):[{ft}_]naming_strip_subst``,
  * ``(bpg):[{ft}_]naming_global_re``, ``(bpg):[{ft}_]naming_global_subst``, ``(bpg):[{ft}_]naming_local_re``, and ``(bpg):[{ft}_]naming_local_subst``,
  * ``(bpg):[{ft}_]naming_member_re``, ``(bpg):[{ft}_]naming_member_subst``, ``(bpg):[{ft}_]naming_static_re``, and ``(bpg):[{ft}_]naming_static_subst``,
  * ``(bpg):[{ft}_]naming_param_re``, and ``(bpg):[{ft}_]naming_param_subst``,
  * ``(bpg):[{ft}_]naming_constant_re``, and ``(bpg):[{ft}_]naming_constant_subst``,
  * ``(bpg):[{ft}_]naming_get_re``, ``(bpg):[{ft}_]naming_get_subst``, ``(bpg):[{ft}_]naming_set_re``, and ``(bpg):[{ft}_]naming_set_subst``
  * ``(bpg):[{ft}_]naming_type_re``, and ``(bpg):[{ft}_]naming_type_subst``,

* regarding case:

  * ``(bpg):[{ft}_]naming_function``
  * ``(bpg):[{ft}_]naming_type``

Once in the *main name* form, the ``..._re`` regex options match the *main name* while the ``..._subst`` replacement text is applied instead.

You can find examples for these options in mu-template
`template <http://github.com/LucHermitte/mu-template/blob/master/after/template/vim/internals/vim-rc-local-cpp-style.template>`_
used by `BuildToolsWrapper <http://github.com/LucHermitte/BuildToolsWrapper>`_'s ``:BTW new_project`` command.
