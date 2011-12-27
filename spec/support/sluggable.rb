require 'spec_helper'

shared_examples "it has a url slug" do
  let(:record) { described_class.to_s.underscore.to_sym }

  context "with an on_save that" do
    it "converts the name of the entity to a url slug" do
      new_instance = build(record)
      new_instance.save
      expected = new_instance.name.parameterize
      new_instance.slug.should eq expected
    end
  end
end
