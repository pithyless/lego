require 'spec_helper'

describe Legit::Value::Base do
  let(:opts) { {} }

  subject { Legit::Value::Base.new(opts) }

  describe '#parse' do
    context 'nil' do
      specify { subject.parse(nil).should be_nothing }
    end
  end

end
