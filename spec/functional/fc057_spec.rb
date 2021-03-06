require "spec_helper"

describe "FC057" do
  context "with a cookbook with a library provider with use_inline_resources" do
    library_file <<-EOF
    class MyResources
      class Site < Chef::Resource::LWRPBase
        provides :site
        resource_name :site
        actions :create
        attribute :name, :kind_of => String, :name_attribute => true
      end
    end

    class MyProviders
      class Site < Chef::Provider::LWRPBase
        provides :site

        use_inline_resources

        action :create do
          file "/tmp/foo.txt"
        end
      end
    end
    EOF
    it { is_expected.not_to violate_rule }
  end

  context "with a cookbook with a library provider without use_inline_resources" do
    library_file <<-EOF
    class MyResources
      class Site < Chef::Resource::LWRPBase
        provides :site
        resource_name :site
        actions :create
        attribute :name, :kind_of => String, :name_attribute => true
      end
    end

    class MyProviders
      class Site < Chef::Provider::LWRPBase
        provides :site

        action :create do
          file "/tmp/foo.txt"
        end
      end
    end
    EOF
    it { is_expected.to violate_rule }
  end

  context "with a cookbook with plain old library file" do
    library_file <<-EOF
    def something
      puts "I'm just a method"
    end
    EOF
    it { is_expected.not_to violate_rule }
  end
end
