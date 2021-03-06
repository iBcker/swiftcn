# == Schema Information
#
# Table name: nodes
#
#  id             :integer          not null, primary key
#  name           :string(191)
#  slug           :string(191)
#  parent_node_id :integer
#  topics_count   :integer          default(0)
#  sort           :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#

require 'rails_helper'

RSpec.describe Node, type: :model do

  let(:node) { FactoryGirl.create(:node) }

  it 'should fail saving without name' do
    node = Node.new
    expect(node.save).to eq false
  end

  it 'should fail saving with not uniq name' do
    node2 = Node.new(name:node.name)
    expect(node2.save).to eq false
  end

  it "create node sulg" do
    expect(node.slug).to eq(Pinyin.t(node.name, splitter: '-').downcase)
  end

end
