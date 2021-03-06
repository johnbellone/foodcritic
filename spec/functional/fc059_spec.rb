require "spec_helper"

describe "FC059" do
  context "with a cookbook with LWRP not using use_inline_resources" do
    provider_file <<-EOF
    action :create do
      template "/etc/something.conf" do
        notifies :restart, "service[something]"
      end
    end
    EOF
    it { is_expected.to violate_rule }
  end

  context "with a cookbook with LWRP using use_inline_resources" do
    provider_file <<-EOF
    use_inline_resources

    action :create do
      template "/etc/something.conf" do
        notifies :restart, "service[something]"
      end
    end
    EOF
    it { is_expected.not_to violate_rule }
  end
end
