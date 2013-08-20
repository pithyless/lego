require 'spec_helper'

describe Lego::Identity do

  it_behaves_like 'a monad' do
    let(:monad) { Lego::Identity }
  end

end
