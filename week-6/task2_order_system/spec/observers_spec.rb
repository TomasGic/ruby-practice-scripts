RSpec.describe Orders::EmailNotifier do
  it "initializes with empty events array" do
    email_notifier = Orders::EmailNotifier.new
    expect(email_notifier.events).to eq([])
  end
end