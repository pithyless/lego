require 'spec_helper'

describe Lego::Value::Base do
  let(:opts) { {} }

  subject { Lego::Value::Base.new(opts) }

  describe '#parse' do
    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
    end
  end

end
