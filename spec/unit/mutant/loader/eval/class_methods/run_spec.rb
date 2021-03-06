# encoding: utf-8

require 'spec_helper'

describe Mutant::Loader::Eval, '.run' do

  subject { object.run(node, mutation_subject) }

  let(:object) { described_class }
  let(:path)   { __FILE__        }
  let(:line)   { 1               }

  let(:mutation_subject) do
    double('Subject', source_path: path, source_line: line)
  end

  let(:source) do
    <<-RUBY
      class SomeNamespace
        class Bar
          def some_method
          end
        end

        class SomeOther
          class Foo < Bar
          end
        end
      end
    RUBY
  end

  let(:node) do
    parse(source)
  end

  it 'should load nodes into vm' do
    subject
    ::SomeNamespace::SomeOther::Foo
  end

  it 'should set file and line correctly' do
    subject
    ::SomeNamespace::Bar
      .instance_method(:some_method)
      .source_location.should eql([__FILE__, 3])
  end
end
