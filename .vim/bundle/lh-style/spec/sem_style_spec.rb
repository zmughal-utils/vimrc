# encoding: UTF-8
require 'spec_helper'
require 'pp'

# =====[ Semantic Styles {{{1
RSpec.describe "When testing semantic styles", :style, :indent_brace_style do
  let (:filename) { "test.cpp" }
  let (:editorconfig) { ".editorconfig" }

  # ====[ Executed once before all test {{{2
  before :all do
    if !defined? vim.runtime
        vim.define_singleton_method(:runtime) do |path|
            self.command("runtime #{path}")
        end
    end
    vim.runtime('spec/support/input-mock.vim')
    expect(vim.command('verbose function lh#ui#input')).to match(/input-mock.vim/)
    # expect(vim.echo('lh#mut#dirs#get_templates_for("cpp/abstract-class")')).to match(/abstract-class.template/)
    vim.command('SetMarker <+ +>')
    expect(vim.echo('&rtp')).to match(/lh-style/)
  end

  # ====[ Tests in simple directory {{{2
  context "in simple current directory", :api do
    # ====[ Always executed before each test {{{3
    before :each do
      expect(vim.echo('&enc')).to eq 'utf-8'
      vim.command('filetype plugin on')
      vim.command("file #{filename}")
      vim.set('ft=cpp')
      vim.command('set fenc=utf-8')
      vim.set('expandtab')
      vim.set('sw=2')
      vim.command('silent! unlet g:cpp_explicit_default')
      vim.command('silent! unlet g:cpp_std_flavour')
      expect(vim.command('runtime! spec/support/c-snippets.vim')).to eq "" # if snippet
      expect(vim.command('verbose iab if')).to match(/LH_cpp_snippets_def_abbr/)
      vim.command('call lh#style#clear()')
      expect(vim.echo('lh#style#get("c")')).to eq "{}"
      clear_buffer
      set_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */
      EOF
      vim.command(%Q{call append(1, ['', ''])})
      expect(vim.echo('line("$")')).to eq '3'
      expect(vim.echo('setpos(".", [1,3,1,0])')).to eq '0'
      expect(vim.echo('line(".")')).to eq '3'
    end

    # ====[ K&R {{{3
    specify "`if` is correctly expanded in K&R's style", :k_r do
      expect(vim.echo('lh#style#use({"indent_brace_style": "K&R"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ 1TBS {{{3
    specify "`if` is correctly expanded in 1TBS's style", :otbs do
      expect(vim.echo('lh#style#use({"indent_brace_style": "1TBS"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ Stroustrup {{{3
    specify "`if` is correctly expanded in Stroustrup's style", :stroustrup do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Stroustrup"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }
      <++>
      EOF
    end

    # ====[ Horstmann {{{3
    specify "`if` is correctly expanded in Horstmann's style", :horstmann do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Horstmann"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      { <++>
      }
      <++>
      EOF
    end

    # ====[ Pico {{{3
    specify "`if` is correctly expanded in Pico's style", :pico do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Pico"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      { <++> }
      <++>
      EOF
    end

    # ====[ Lisp {{{3
    specify "`if` is correctly expanded in Lisp's style", :lisp do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Lisp"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>}
        <++>
      EOF
      # Note: The extra indent at the end is because Vim adds an extra
      # indentation with this way of organising brackets.
    end

    # ====[ Java {{{3
    specify "`if` is correctly expanded in Java's style", :java do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Java"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ Allman {{{3
    specify "`if` is correctly expanded in Allman's style", :allman do
      expect(vim.echo('lh#style#use({"indent_brace_style": "Allman"}, {"buffer": 1})')).to eq "1"
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      {
        <++>
      }
      <++>
      EOF
    end

  end # }}}2

# ====[ Tests in directories with .editorconfig file {{{2
  context "in directories with .editorconfig file", :editorconfig do
    # ====[ Executed once for this context {{{3
    before :all do
      # Makes sure editor config is present, and loaded
      vim.runtime('plugin/editorconfig.vim')
      expect(vim.command('scriptname')).to match(/editorconfig.vim/)
    end

    # ====[ Always executed before each test {{{3
    before :each do
      expect(vim.echo('&enc')).to eq 'utf-8'
      vim.command('filetype plugin on')
      vim.command("file #{filename}")
      vim.set('ft=cpp')
      vim.command('set fenc=utf-8')
      vim.set('expandtab')
      vim.set('sw=2')
      vim.command('silent! unlet g:cpp_explicit_default')
      vim.command('silent! unlet g:cpp_std_flavour')
      expect(vim.command('runtime! spec/support/c-snippets.vim')).to eq "" # if snippet
      expect(vim.command('verbose iab if')).to match(/LH_cpp_snippets_def_abbr/)
      vim.command('call lh#style#clear()')
      expect(vim.echo('lh#style#get("c")')).to eq "{}"
      clear_buffer
      set_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */
      EOF
      vim.command(%Q{call append(1, ['', ''])})
      expect(vim.echo('line("$")')).to eq '3'
      expect(vim.echo('setpos(".", [1,3,1,0])')).to eq '0'
      expect(vim.echo('line(".")')).to eq '3'
    end

    # ====[ Always executed before after test {{{3
    after :each do
      FileUtils.rm(editorconfig)
      # print "Remove #{editorconfig} file\n"
    end

    # ====[ K&R {{{3
    specify "`if` is correctly expanded in K&R's style", :k_r do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: K&R") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ 1TBS {{{3
    specify "`if` is correctly expanded in 1TBS's style", :otbs do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: 1TBS") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ Stroustrup {{{3
    specify "`if` is correctly expanded in Stroustrup's style", :stroustrup do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: Stroustrup") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }
      <++>
      EOF
    end

    # ====[ Horstmann {{{3
    specify "`if` is correctly expanded in Horstmann's style", :horstmann do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: Horstmann") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      { <++>
      }
      <++>
      EOF
    end

    # ====[ Pico {{{3
    specify "`if` is correctly expanded in Pico's style", :pico do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: Pico") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      { <++> }
      <++>
      EOF
    end

    # ====[ Lisp {{{3
    specify "`if` is correctly expanded in Lisp's style", :lisp do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: LISP") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>}
        <++>
      EOF
      # Note: The extra indent at the end is because Vim adds an extra
      # indentation with this way of organising brackets.
    end

    # ====[ Java {{{3
    specify "`if` is correctly expanded in Java's style", :java do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: Java") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo) {
        <++>
      }<++>
      EOF
    end

    # ====[ Allman {{{3
    specify "`if` is correctly expanded in Allman's style", :allman do
      # Inject editorconfig file, then, reload the settings
      File.open(editorconfig, "w") { |f| f.write("[*]\nindent_brace_style: Allman") }
      vim.command("EditorConfigReload")
      # And then test
      vim.feedkeys('aif foo\<esc>')
      vim.feedkeys('i\<esc>') # pause
      assert_buffer_contents <<-EOF
      /** File Header line to trick auto-inclusion */

      if(foo)
      {
        <++>
      }
      <++>
      EOF
    end

  end # }}}2
end # }}}1
# vim:set sw=2:fdm=marker:
