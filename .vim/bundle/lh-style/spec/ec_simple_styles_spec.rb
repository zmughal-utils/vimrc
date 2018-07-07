# encoding: UTF-8
require 'spec_helper'
require 'pp'

# =====[ Semantic Styles {{{1
RSpec.describe "When testing EditorConfig Domain-Specific styles", :style, :domain do
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
    # expect(vim.echo('&rtp')).not_to match(/lh-dev/)
  end

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
      expect(vim.echo('lh#style#clear()')).to eq "0"
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

    # ====[ curly_bracket_next_line {{{3
    context "while expanding `if`", :curly_bracket_next_line do
      specify "`if` is correctly expanded w/ curly_bracket_next_line = true" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\ncurly_bracket_next_line = true") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('i\<esc>') # pause
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if(foo)
        {<++>}<++>
        EOF
      end
      specify "`if` is correctly expanded w/ curly_bracket_next_line = no" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\ncurly_bracket_next_line = no") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if(foo){<++>}<++>
        EOF
      end
    end

    # ====[ spaces_around_brackets {{{3
    context "while expanding `if`", :spaces_around_brackets do
      specify "`if` is correctly expanded w/ spaces_around_brackets = inside" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\nspaces_around_brackets = inside") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if( foo ){<++>}<++>
        EOF
      end
      specify "`if` is correctly expanded w/ spaces_around_brackets = outside" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\nspaces_around_brackets = outside") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if (foo) {<++>}<++>
        EOF
      end
      specify "`if` is correctly expanded w/ spaces_around_brackets = both" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\nspaces_around_brackets  = both") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if ( foo ) {<++>}<++>
        EOF
      end
      specify "`if` is correctly expanded w/ spaces_around_brackets = none" do # {{{4
        # Inject editorconfig file, then, reload the settings
        File.open(editorconfig, "w") { |f| f.write("[*]\nspaces_around_brackets = none") }
        vim.command("EditorConfigReload")
        # And then test
        vim.feedkeys('aif foo\<esc>')
        vim.feedkeys('i\<esc>') # pause
        assert_buffer_contents <<-EOF
        /** File Header line to trick auto-inclusion */

        if(foo){<++>}<++>
        EOF
      end
    end
  end # }}}2

end # }}}1
# vim:set sw=2:fdm=marker:
