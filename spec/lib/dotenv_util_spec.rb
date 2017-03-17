# frozen_string_literal: true
require "spec_helper"
require "dotenv_util"

RSpec.describe DotenvUtil do
  let(:env_text) do
    <<-EOF
      FAVORITE_FOOD=POTATO
      FAVORITE_COLOR="RED"
      NO_CONTENT=
    EOF
  end

  describe "#generate_env" do
    it "Replaces an env variable in the file with a given string" do
      util = DotenvUtil.new(env_text)
      util.set("FAVORITE_FOOD", "FILET MIGNON")
      new_env = util.generate_env

      favorite_food = new_env.match(/^FAVORITE_FOOD="(?<env>.*)"$/)[:env]
      expect(favorite_food).to eq "FILET MIGNON"
    end

    it "Sets a new env variable which doesn't exist in the file" do
      util = DotenvUtil.new(env_text)
      util.set("BANANA", "YES")
      new_env = util.generate_env

      banananess = new_env.match(/^BANANA="(?<env>.*)"$/)[:env]
      expect(banananess).to eq "YES"
    end

    it "Has no problem when the has no values" do
      empty_envs = <<-EOF
        NOTHING=
        ALSO_NOTHING=
      EOF

      expect { DotenvUtil.new(empty_envs) }.to_not raise_error
    end

    it "Can handle non-matching lines like comments" do
      commented_contents = <<-EOF
        FOO=BAR
        # FOO=OLDBAR
      EOF

      expect { DotenvUtil.new(commented_contents) }.to_not raise_error
    end
  end
end