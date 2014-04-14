require 'spec_helper'
require 'controllers/user_helper'
require 'pry'

describe UserAwareController do
  include UserHelper

  describe :current_user do

    def fake_env_set_to_true
      fake_env = double(:fake_env)
      allow(fake_env).to receive(:use_dev_token).and_return 'true'
      allow(Figaro).to receive(:env).and_return fake_env
    end

    def fake_env_set_to_false
      fake_env = double(:fake_env)
      allow(fake_env).to receive(:use_dev_token).and_return 'false'
      allow(Figaro).to receive(:env).and_return fake_env
    end

    it 'should return fake user if the USE_DEV_TOKEN flag is set to true' do
      @env = fake_env_set_to_true
      expect(@controller.current_user.name).to eq ("Development User")
    end

    it 'should throw an error if there are no authentication headers' do
      lambda {@controller.current_user}.should raise_exception
    end

    it 'should throw an error if there are no authentication headers and USE_DEV_TOKEN is false' do
      @env = fake_env_set_to_false
      lambda {@controller.current_user}.should raise_exception
    end

    it 'should return a real user from the session if there is one' do
      add_user_without_role_to_session
      expect(@controller.current_user).to eq (@user)
    end

    it 'should return a real user from the session if there is one even if USE_DEV_TOKEN is set' do
      add_user_without_role_to_session
      @env = fake_env_set_to_true
      expect(@controller.current_user).to eq (@user)
    end

  end
end
