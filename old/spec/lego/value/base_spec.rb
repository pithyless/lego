#require 'spec_helper'
#
#describe Lego::Value::Base do
#  let(:opts) { {} }
#
#  subject { Lego::Value::Base.new(opts) }
#
#  describe '#parse' do
#    context 'nil is missing' do
#      context 'with default handler' do
#        let(:opts) { { default: ->{ 'default' } } }
#        specify { subject.parse(nil).should be_just('default') }
#      end
#
#      context 'without default handler' do
#        specify { subject.parse(nil).should be_error('missing value') }
#      end
#    end
#
#  end
#
#end
